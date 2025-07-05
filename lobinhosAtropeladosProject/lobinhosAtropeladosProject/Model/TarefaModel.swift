import Foundation
import SwiftUI

@MainActor
class TarefaModel: ObservableObject {
    static let shared = TarefaModel()
    
    private let saveKey = "TarefasLoboApp"
    private let geminiService = GeminiService()
    
    @Published var estaPriorizando = false
    @Published var tarefas: [Tarefa] = [] {
        didSet {
            salvarTarefas()
        }
    }
    
    private init() {
        carregarTarefas()
        // Ao iniciar, dispara uma priorização inicial se houver tarefas.
        if !tarefas.filter({ !$0.concluida }).isEmpty {
            repriorizarLista()
        }
    }
    
    // As assinaturas das suas funções foram mantidas.
    func adiciona_tarefa(Nome: String, Descricao: String?, Dificuldade: String, Data_entrega: Date) {
        let novaTarefa = Tarefa(nome: Nome, descricao: Descricao, dificuldade: Dificuldade, data_entrega: Data_entrega)
        
        // 1. A tarefa é adicionada e a lista é ordenada localmente.
        // Isso garante que ela apareça na tela IMEDIATAMENTE.
        tarefas.append(novaTarefa)
        tarefas.sort()
        
        // 2. A chamada para a IA acontece em segundo plano.
        repriorizarLista()
    }
    
    func deletar_tarefa(id: UUID) {
        if let index = tarefas.firstIndex(where: { $0.id == id }) {
            tarefas.remove(at: index)
        }
    }
    
    func atualizar_tarefa(id: UUID, Nome: String, Descricao: String?, Dificuldade: String, Data_entrega: Date) {
        if let index = tarefas.firstIndex(where: { $0.id == id }) {
            tarefas[index].nome = Nome
            tarefas[index].descricao = Descricao
            tarefas[index].dificuldade = Dificuldade
            tarefas[index].data_entrega = Data_entrega
        }
        repriorizarLista()
    }
    
    func detalhe(id: UUID) -> Tarefa {
        return tarefas.first(where: { $0.id == id }) ?? Tarefa(
            nome: "Tarefa não encontrada",
            descricao: "Nenhuma tarefa com esse ID.",
            dificuldade: "1",
            data_entrega: Date()
        )
    }
    
    func marcarTarefa(tarefa: Tarefa) {
        if let index = tarefas.firstIndex(where: { $0.id == tarefa.id }) {
            tarefas[index].concluida.toggle()
            if tarefas[index].concluida {
                tarefas[index].data_conclusao = Date()
            } else {
                tarefas[index].data_conclusao = nil
            }
            tarefas.sort()
        }
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
        self.tarefas = decodedTasks.sorted()
    }

    // --- FUNÇÃO DE PRIORIZAÇÃO ATUALIZADA E MAIS SEGURA ---
    func repriorizarLista() {
        Task {
            self.estaPriorizando = true
            
            let tarefasPendentes = self.tarefas.filter { !$0.concluida }
            let tarefasConcluidas = self.tarefas.filter { $0.concluida }
            
            guard !tarefasPendentes.isEmpty else {
                self.estaPriorizando = false
                return
            }
            
            do {
                // A chamada para a IA continua a mesma
                let resultado = try await geminiService.gerarPlanoDiario(
                    tarefasPendentes: tarefasPendentes,
                    tarefasConcluidas: tarefasConcluidas,
                    perfilUsuario: UserModel.shared.user
                )
                
                // --- NOVA LÓGICA SEGURA ---
                // Em vez de substituir a lista, nós a atualizamos.
                // 1. Juntamos todas as tarefas que a IA retornou (plano + não planejadas)
                let tarefasAtualizadasPelaIA = resultado.planoDoDia + resultado.naoPlanejado
                
                // 2. Criamos um "mapa" para encontrar as novas informações rapidamente.
                let mapaDeTarefas = Dictionary(uniqueKeysWithValues: tarefasAtualizadasPelaIA.map { ($0.id, $0) })
                
                // 3. Percorremos a nossa lista local de tarefas.
                for i in 0..<self.tarefas.count {
                    let idDaTarefa = self.tarefas[i].id
                    // 4. Se a IA retornou informações para esta tarefa, nós a atualizamos.
                    if let tarefaAtualizada = mapaDeTarefas[idDaTarefa] {
                        self.tarefas[i].prioridade = tarefaAtualizada.prioridade
                        // Adicione aqui outros campos que a IA possa alterar no futuro
                    }
                }
                
                // 5. Reordenamos a lista com as novas prioridades.
                self.tarefas.sort()
                
            } catch {
                // Se a IA falhar, nós apenas imprimimos o erro. A tarefa nova já está na lista.
                print("Erro ao gerar plano diário com a IA: \(error). A lista local será mantida.")
            }
            
            self.estaPriorizando = false
        }
    }
}
