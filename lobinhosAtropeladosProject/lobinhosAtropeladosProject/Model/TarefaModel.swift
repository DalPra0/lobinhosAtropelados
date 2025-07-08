import Foundation
import SwiftUI

@MainActor
class TarefaModel: ObservableObject {
    static let shared = TarefaModel()
    
    private let saveKey = "TarefasLoboApp"
    private let lastUpdateKey = "LastPlanUpdateDate"
    private let tutorialKey = "HasCreatedTutorialTasks"
    private let geminiService = GeminiService()
    
    @Published var estaPriorizando = false
    @Published var tarefas: [Tarefa] = [] {
        didSet {
            salvarTarefas()
        }
    }
    
    private init() {
        carregarTarefas()
        // Chama a criação do tutorial logo na inicialização
        criarTarefasIniciaisSeNecessario()
    }
    
    // --- NOVA FUNÇÃO PARA CRIAR TAREFAS DO TUTORIAL ---
    func criarTarefasIniciaisSeNecessario() {
        let tutorialJaCriado = UserDefaults.standard.bool(forKey: tutorialKey)
        
        // Se as tarefas do tutorial ainda não foram criadas e a lista está vazia
        if !tutorialJaCriado && tarefas.isEmpty {
            print("Criando tarefas do tutorial pela primeira vez.")
            
            let umDia: TimeInterval = 60 * 60 * 24
            
            let tarefasTutorial = [
                Tarefa(nome: "Bem-vindo(a) ao Gimo! ✨", descricao: "Este é o seu plano de hoje, montado especialmente para você! Para concluir uma tarefa como esta, basta tocar no círculo à esquerda. Experimente agora e sinta a satisfação!", dificuldade: "1", data_entrega: Date().addingTimeInterval(umDia * 2), fazParteDoPlanoDeHoje: true),
                Tarefa(nome: "Toque aqui para ver os detalhes", descricao: "Toda tarefa tem informações extras. Toque no corpo de uma tarefa (nesta, por exemplo!) para expandir e ver a descrição, o prazo e a dificuldade. Toque novamente para fechar.", dificuldade: "1", data_entrega: Date().addingTimeInterval(umDia * 3), fazParteDoPlanoDeHoje: true),
                Tarefa(nome: "Deslize para editar ou excluir", descricao: "Precisou ajustar algo ou a tarefa não é mais necessária? Deslize o dedo da direita para a esquerda sobre ela para revelar as opções. É fácil assim! (Só não me exclua, ok?)", dificuldade: "2", data_entrega: Date().addingTimeInterval(umDia * 4), fazParteDoPlanoDeHoje: true),
                Tarefa(nome: "Adicione sua primeira tarefa real", descricao: "Agora é sua vez! Quando estiver pronto, toque no botão azul com o sinal de \"+\" no canto inferior direito para cadastrar suas próprias atividades da faculdade.", dificuldade: "3", data_entrega: Date().addingTimeInterval(umDia * 5), fazParteDoPlanoDeHoje: true),
                Tarefa(nome: "Explore suas outras tarefas", descricao: "No topo da tela, você pode usar os filtros para alternar entre as tarefas que eu priorizei \"Para hoje\", \"Todas\" as suas tarefas pendentes ou as que você já finalizou em \"Concluídas\".", dificuldade: "1", data_entrega: Date().addingTimeInterval(umDia * 6)),
                Tarefa(nome: "Ajuste seu perfil e seu ritmo", descricao: "Toque no ícone de pessoa no topo para ver seu perfil. E se o dia estiver mais corrido ou mais leve, clique em \"Alterar seu ritmo\" logo abaixo do seu nome para que eu possa ajustar o plano para você.", dificuldade: "2", data_entrega: Date().addingTimeInterval(umDia * 7))
            ]
            
            self.tarefas.append(contentsOf: tarefasTutorial)
            
            // Marca que o tutorial foi criado para não criar de novo
            UserDefaults.standard.set(true, forKey: tutorialKey)
        }
    }
    
    func verificarEGerarPlanoDoDia() {
        let ultimaAtualizacao = UserDefaults.standard.object(forKey: lastUpdateKey) as? Date
        
        let éNovoDia = ultimaAtualizacao == nil || !Calendar.current.isDateInToday(ultimaAtualizacao!)
        
        let naoExistePlano = !tarefas.contains(where: { $0.fazParteDoPlanoDeHoje && !$0.concluida })

        if éNovoDia || naoExistePlano {
            print("Gerando novo plano do dia. Motivo: É novo dia ou não existe plano ativo.")
            chamarIA(paraGerarPlanoCompleto: true)
        } else {
            print("O plano do dia já está atualizado e ativo.")
        }
    }
    
    
    func adiciona_tarefa(Nome: String, Descricao: String?, Dificuldade: String, Data_entrega: Date) {
        let novaTarefa = Tarefa(nome: Nome, descricao: Descricao, dificuldade: Dificuldade, data_entrega: Data_entrega)
        tarefas.append(novaTarefa)
        NotificationManager.shared.scheduleNotifications(for: novaTarefa)
        chamarIA(paraGerarPlanoCompleto: false)
    }
    
    func atualizar_tarefa(id: UUID, Nome: String, Descricao: String?, Dificuldade: String, Data_entrega: Date) {
        if let index = tarefas.firstIndex(where: { $0.id == id }) {
            tarefas[index].nome = Nome
            tarefas[index].descricao = Descricao
            tarefas[index].dificuldade = Dificuldade
            tarefas[index].data_entrega = Data_entrega
            
            let tarefaAtualizada = tarefas[index]
            NotificationManager.shared.scheduleNotifications(for: tarefaAtualizada)
            chamarIA(paraGerarPlanoCompleto: false)
        }
    }
    
    func deletar_tarefa(id: UUID) {
        if let index = tarefas.firstIndex(where: { $0.id == id }) {
            let tarefaRemovida = tarefas[index]
            NotificationManager.shared.cancelNotifications(for: tarefaRemovida)
            tarefas.remove(at: index)
        }
    }
    
    func marcarTarefa(tarefa: Tarefa) {
        if let index = tarefas.firstIndex(where: { $0.id == tarefa.id }) {
            tarefas[index].concluida.toggle()
            
            if tarefas[index].concluida {
                tarefas[index].data_conclusao = Date()
                NotificationManager.shared.cancelNotifications(for: tarefas[index])
            } else {
                tarefas[index].data_conclusao = nil
                NotificationManager.shared.scheduleNotifications(for: tarefas[index])
            }
            tarefas.sort()
        }
    }
    
    func detalhe(id: UUID) -> Tarefa {
        return tarefas.first(where: { $0.id == id }) ?? Tarefa(nome: "Não encontrada", descricao: nil, dificuldade: "1", data_entrega: Date())
    }

    
    func chamarIA(paraGerarPlanoCompleto: Bool) {
        Task {
            self.estaPriorizando = true
            
            let tarefasPendentes = self.tarefas.filter { !$0.concluida }
            let tarefasConcluidas = self.tarefas.filter { $0.concluida }
            
            guard !tarefasPendentes.isEmpty else {
                self.estaPriorizando = false
                self.tarefas.indices.forEach { self.tarefas[$0].fazParteDoPlanoDeHoje = false }
                return
            }
            
            do {
                let resultado = try await geminiService.gerarPlanoDiario(
                    tarefasPendentes: tarefasPendentes,
                    tarefasConcluidas: tarefasConcluidas,
                    perfilUsuario: UserModel.shared.user
                )
                
                var tarefasAtualizadas = tarefasConcluidas
                tarefasAtualizadas.append(contentsOf: resultado.planoDoDia)
                tarefasAtualizadas.append(contentsOf: resultado.naoPlanejado)
                
                let planoDoDiaIDs = Set(resultado.planoDoDia.map { $0.id })
                for i in 0..<tarefasAtualizadas.count {
                    tarefasAtualizadas[i].fazParteDoPlanoDeHoje = planoDoDiaIDs.contains(tarefasAtualizadas[i].id)
                }
                
                if paraGerarPlanoCompleto {
                    UserDefaults.standard.set(Date(), forKey: lastUpdateKey)
                    print("Plano do dia gerado e data salva.")
                }
                
                self.tarefas = tarefasAtualizadas.sorted()
                
            } catch {
                print("Erro ao gerar plano diário com a IA: \(error). A lista local será mantida e apenas ordenada.")
                self.tarefas.sort()
            }
            
            self.estaPriorizando = false
        }
    }

    
    func limparTarefasConcluidas() {
        let tarefasParaLimpar = tarefas.filter { $0.concluida }
        for tarefa in tarefasParaLimpar {
            NotificationManager.shared.cancelNotifications(for: tarefa)
        }
        tarefas.removeAll { $0.concluida }
    }
    
    private func salvarTarefas() {
        if let encodedData = try? JSONEncoder().encode(tarefas) {
            UserDefaults.standard.set(encodedData, forKey: saveKey)
        }
    }
    
    private func carregarTarefas() {
        guard let savedData = UserDefaults.standard.data(forKey: saveKey),
              let decodedTasks = try? JSONDecoder().decode([Tarefa].self, from: savedData) else {
            self.tarefas = []
            return
        }
        self.tarefas = decodedTasks
    }
}

