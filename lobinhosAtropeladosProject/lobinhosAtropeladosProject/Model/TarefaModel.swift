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
        // Ao iniciar, dispara uma priorização inicial se houver tarefas pendentes.
        if !tarefas.filter({ !$0.concluida }).isEmpty {
            repriorizarLista()
        }
    }
    
    func adiciona_tarefa(Nome: String, Descricao: String?, Dificuldade: String, Data_entrega: Date) {
        let novaTarefa = Tarefa(nome: Nome, descricao: Descricao, dificuldade: Dificuldade, data_entrega: Data_entrega)
        tarefas.append(novaTarefa)
        tarefas.sort() // Ordena localmente para feedback imediato
        repriorizarLista() // Chama a IA em segundo plano
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
                let resultado = try await geminiService.gerarPlanoDiario(
                    tarefasPendentes: tarefasPendentes,
                    tarefasConcluidas: tarefasConcluidas,
                    perfilUsuario: UserModel.shared.user
                )
                
                let tarefasAtualizadasPelaIA = resultado.planoDoDia + resultado.naoPlanejado
                let mapaDeTarefas = Dictionary(uniqueKeysWithValues: tarefasAtualizadasPelaIA.map { ($0.id, $0) })
                
                for i in 0..<self.tarefas.count {
                    let idDaTarefa = self.tarefas[i].id
                    // Se a IA retornou informações para esta tarefa, nós a atualizamos.
                    if let tarefaAtualizada = mapaDeTarefas[idDaTarefa] {
                        // Apenas atualiza a prioridade.
                        self.tarefas[i].prioridade = tarefaAtualizada.prioridade
                    }
                }
                
                self.tarefas.sort()
                
            } catch {
                print("Erro ao gerar plano diário com a IA: \(error). A lista local será mantida.")
            }
            
            self.estaPriorizando = false
        }
    }
    
    func limparTarefasConcluidas() {
        // Mantém apenas as tarefas que não estão concluídas
        tarefas.removeAll { $0.concluida }
    }
}
