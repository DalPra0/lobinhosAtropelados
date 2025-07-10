import Foundation

@MainActor
class UserModel: ObservableObject {
    static let shared = UserModel()
    
    private let userSaveKey = "SavedUser"
    
    @Published private(set) var user: User {
        didSet {
            saveUser()
        }
    }
    
    private init() {
        if let savedData = AppGroup.userDefaults.data(forKey: userSaveKey),
           let decodedUser = try? JSONDecoder().decode(User.self, from: savedData) {
            self.user = decodedUser
            print("Usuário carregado com sucesso.")
            return
        }
        
        self.user = User(nome: "Fulano", bio: "", curso: "", periodo: "")
        print("Nenhum usuário salvo encontrado. Criado usuário padrão.")
    }
    
    private func saveUser() {
        if let encodedData = try? JSONEncoder().encode(user) {
            AppGroup.userDefaults.set(encodedData, forKey: userSaveKey)
            print("Usuário salvo no App Group.")
        }
    }
    
    
    func criarUsuario(nome: String, bio: String, curso: String, periodo: String) {
        self.user = User(nome: nome, bio: bio, curso: curso, periodo: periodo)
    }
    
    func atualizarUsuario(nome: String, bio: String, curso: String, periodo: String) {
        self.user.nome = nome
        self.user.bio = bio
        self.user.curso = curso
        self.user.periodo = periodo
    }
    
    func atualizarEstiloOrganizacao(estilo: String) {
        self.user.estiloOrganizacao = estilo
    }
    
    func atualizar_horas_disponiveis(horas:Date) {
        let calendario = Calendar.current
        let componentes = calendario.dateComponents([.hour, .minute], from: horas)
        self.user.tempo_disponível_minutos = (componentes.hour ?? 0) * 60 + (componentes.minute ?? 0)
    }
    
    func atualizar_modo(modo:Int) {
        self.user.modo_selecionado = modo
    }
}
