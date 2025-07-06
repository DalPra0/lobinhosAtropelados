import Foundation
import SwiftUI

@MainActor
class TarefaModel: ObservableObject {
    static let shared = TarefaModel()
    
    private let saveKey = "TarefasLoboApp"
    private let lastUpdateKey = "LastPlanUpdateDate"
    private let geminiService = GeminiService()
    
    @Published var estaPriorizando = false
    @Published var tarefas: [Tarefa] = [] {
        didSet {
            salvarTarefas()
        }
    }
    
    private init() {
        carregarTarefas()
    }
    
    // MARK: - Funções Públicas de Gerenciamento
    
    // NOVA FUNÇÃO: Verifica se o plano do dia precisa ser gerado.
    // Esta função será chamada toda vez que a tela inicial aparecer.
    func verificarEGerarPlanoDoDia() {
        let ultimaAtualizacao = UserDefaults.standard.object(forKey: lastUpdateKey) as? Date
        
        // Condição 1: É um novo dia (a data da última atualização não é hoje).
        let éNovoDia = ultimaAtualizacao == nil || !Calendar.current.isDateInToday(ultimaAtualizacao!)
        
        // Condição 2: Não existe nenhuma tarefa marcada como parte do plano de hoje.
        // Isso cobre o caso de o usuário ter concluído tudo ou adicionado tarefas sem um plano ativo.
        let naoExistePlano = !tarefas.contains(where: { $0.fazParteDoPlanoDeHoje && !$0.concluida })

        if éNovoDia || naoExistePlano {
            print("Gerando novo plano do dia. Motivo: É novo dia ou não existe plano ativo.")
            chamarIA(paraGerarPlanoCompleto: true)
        } else {
            print("O plano do dia já está atualizado e ativo.")
        }
    }
    
    // A função antiga foi removida para evitar confusão.
    // A nova função `chamarIA` agora é a única responsável por isso.
    
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
                tarefas[index].fazParteDoPlanoDeHoje = false
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

    // MARK: - Lógica Central da IA
    
    // FUNÇÃO ATUALIZADA: Agora é pública para ser chamada de outros locais, como a tela de alterar modo.
    func chamarIA(paraGerarPlanoCompleto: Bool) {
        Task {
            self.estaPriorizando = true
            
            let tarefasPendentes = self.tarefas.filter { !$0.concluida }
            let tarefasConcluidas = self.tarefas.filter { $0.concluida }
            
            guard !tarefasPendentes.isEmpty else {
                self.estaPriorizando = false
                // Se não há tarefas pendentes, garantimos que não há plano ativo.
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

    // MARK: - Funções de Persistência e Utilitários
    
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
