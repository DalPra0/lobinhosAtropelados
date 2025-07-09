import Foundation

struct Tarefa: Codable, Identifiable, Comparable {
    
    let id: UUID
    var nome: String
    var descricao: String?
    var dificuldade: String
    var concluida: Bool
    var data_conclusao: Date? = nil
    var data_entrega: Date
    var prioridade: Int?
    var fazParteDoPlanoDeHoje: Bool
    var idDoEventoNoCalendario: String?
    var duracaoEstimadaMinutos: Int? // <-- NOVO CAMPO ADICIONADO

    init(id: UUID = UUID(), nome: String, descricao: String?, dificuldade: String, concluida: Bool = false, data_entrega : Date, prioridade: Int? = nil, fazParteDoPlanoDeHoje: Bool = false, idDoEventoNoCalendario: String? = nil, duracaoEstimadaMinutos: Int? = nil) {
        self.id = id
        self.nome = nome
        self.descricao = descricao
        self.dificuldade = dificuldade
        self.concluida = concluida
        self.data_entrega = data_entrega
        self.prioridade = prioridade
        self.fazParteDoPlanoDeHoje = fazParteDoPlanoDeHoje
        self.idDoEventoNoCalendario = idDoEventoNoCalendario
        self.duracaoEstimadaMinutos = duracaoEstimadaMinutos // <-- NOVO CAMPO ADICIONADO
    }
    
    static func < (lhs: Tarefa, rhs: Tarefa) -> Bool {
        if lhs.concluida != rhs.concluida {
            return !lhs.concluida
        }
        
        if !lhs.concluida {
            return lhs.prioridade ?? Int.max < rhs.prioridade ?? Int.max
        }
        
        return lhs.data_conclusao ?? Date() > rhs.data_conclusao ?? Date()
    }
}
