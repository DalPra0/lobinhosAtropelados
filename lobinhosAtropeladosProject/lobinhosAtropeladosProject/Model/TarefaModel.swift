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
        verificarEGerarPlanoDoDia()
    }
    
    
    func adiciona_tarefa(Nome: String, Descricao: String?, Dificuldade: String, Data_entrega: Date) {
        let novaTarefa = Tarefa(nome: Nome, descricao: Descricao, dificuldade: Dificuldade, data_entrega: Data_entrega)
        tarefas.append(novaTarefa)
        NotificationManager.shared.scheduleNotifications(for: novaTarefa)
        atualizarPrioridades()
    }
    
    func deletar_tarefa(id: UUID) {
        if let index = tarefas.firstIndex(where: { $0.id == id }) {
            let tarefaRemovida = tarefas[index]
            NotificationManager.shared.cancelNotifications(for: tarefaRemovida)
            tarefas.remove(at: index)
        }
    }
    
    func atualizar_tarefa(id: UUID, Nome: String, Descricao: String?, Dificuldade: String, Data_entrega: Date) {
        if let index = tarefas.firstIndex(where: { $0.id == id }) {
            tarefas[index].nome = Nome
            tarefas[index].descricao = Descricao
            tarefas[index].dificuldade = Dificuldade
            tarefas[index].data_entrega = Data_entrega
            
            let tarefaAtualizada = tarefas[index]
            NotificationManager.shared.scheduleNotifications(for: tarefaAtualizada)
            atualizarPrioridades()
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
    
    
    private func verificarEGerarPlanoDoDia() {
        let ultimaAtualizacao = UserDefaults.standard.object(forKey: lastUpdateKey) as? Date
        
        if ultimaAtualizacao == nil || !Calendar.current.isDateInToday(ultimaAtualizacao!) {
            print("Gerando novo plano do dia...")
            gerarPlanoDoDiaCompleto()
        } else {
            print("Plano do dia já está atualizado para hoje.")
        }
    }
    
    private func gerarPlanoDoDiaCompleto() {
        chamarIA(atualizarPlanoDoDia: true)
    }
    
    private func atualizarPrioridades() {
        chamarIA(atualizarPlanoDoDia: false)
    }
    
    private func chamarIA(atualizarPlanoDoDia: Bool) {
        Task {
            self.estaPriorizando = true
            
            var tarefasAtuais = self.tarefas
            let tarefasPendentes = tarefasAtuais.filter { !$0.concluida }
            let tarefasConcluidas = tarefasAtuais.filter { $0.concluida }
            
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
                
                let mapaDePrioridades = Dictionary(uniqueKeysWithValues: (resultado.planoDoDia + resultado.naoPlanejado).map { ($0.id, $0.prioridade) })
                
                for i in 0..<tarefasAtuais.count {
                    let idDaTarefa = tarefasAtuais[i].id
                    
                    if atualizarPlanoDoDia {
                        let planoDoDiaIDs = Set(resultado.planoDoDia.map { $0.id })
                        tarefasAtuais[i].fazParteDoPlanoDeHoje = planoDoDiaIDs.contains(idDaTarefa)
                    }
                    
                    if let novaPrioridade = mapaDePrioridades[idDaTarefa] {
                        tarefasAtuais[i].prioridade = novaPrioridade
                    }
                }
                
                if atualizarPlanoDoDia {
                    UserDefaults.standard.set(Date(), forKey: lastUpdateKey)
                }
                
                self.tarefas = tarefasAtuais.sorted()
                
            } catch {
                print("Erro ao gerar plano diário com a IA: \(error). A lista local será mantida.")
                self.tarefas.sort()
            }
            
            self.estaPriorizando = false
        }
    }
    
    
    func detalhe(id: UUID) -> Tarefa {
        return tarefas.first(where: { $0.id == id }) ?? Tarefa(nome: "Não encontrada", descricao: nil, dificuldade: "1", data_entrega: Date())
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
    
    func limparTarefasConcluidas() {
        let tarefasParaLimpar = tarefas.filter { $0.concluida }
        for tarefa in tarefasParaLimpar {
            NotificationManager.shared.cancelNotifications(for: tarefa)
        }
        tarefas.removeAll { $0.concluida }
    }
}
