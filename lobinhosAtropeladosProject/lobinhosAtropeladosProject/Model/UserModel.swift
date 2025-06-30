import Foundation

class UserModel : ObservableObject {
    static let shared = UserModel()   // Instância única singleton
    
    private init() {}
    
    private(set) var user = User(nome: "generico", bio: "generico", curso: "generico", periodo: "generico")
    
    func criarUsuario(nome: String, bio: String, curso: String, periodo: String) {
        self.user = User(nome: nome, bio: bio, curso: curso, periodo: periodo)
    }
    
    func atualizarUsuario(nome: String, bio: String, curso: String, periodo: String) {
        self.user.nome = nome
        self.user.bio = bio
        self.user.curso = curso
        self.user.periodo = periodo
    }
    
   func atualizar_horas_disponiveis(horas:Date) { //usar na hora de setar quanto tempo disponivel tem, vem de um picker que retorna Date com horas e minutos
        let calendario = Calendar.current
        let componentes = calendario.dateComponents([.hour, .minute], from: horas)
        self.user.tempo_disponível_minutos = (componentes.hour ?? 0) * 60 + (componentes.minute ?? 0)
    }
    
    func atualizar_modo(modo:Int) { //quando setar o modo, use esse
        self.user.modo_selecionado = modo
    }
}
