import SwiftUI

struct PerfilView: View {

    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var userModel = UserModel.shared
    @ObservedObject var tarefaModel = TarefaModel.shared

    @State private var curso: String
    @State private var periodo: String
    
    @State var editando_0 = false
    @State var editando_1 = false

    private let cursoOriginal: String
    private let periodoOriginal: String

    init() {
        let cursoInicial = UserModel.shared.user.curso
        let periodoInicial = UserModel.shared.user.periodo
        
        _curso = State(initialValue: cursoInicial)
        _periodo = State(initialValue: periodoInicial)
        
        self.cursoOriginal = cursoInicial
        self.periodoOriginal = periodoInicial
    }
    
    private var houveMudancas: Bool {
        return curso != cursoOriginal || periodo != periodoOriginal
    }

    private var tarefasConcluidasCount: Int {
        tarefaModel.tarefas.filter { $0.concluida }.count
    }

    private var modoPreferido: String {
        switch userModel.user.modo_selecionado {
        case 1:
            return "Tranquilo"
        case 3:
            return "Intenso"
        default:
            return "Moderado"
        }
    }
    
    private var corDoModo: Color {
        switch userModel.user.modo_selecionado {
        case 1:
            return Color("corModoTranquilo")
        case 3:
            return Color("corModoIntenso")
        default:
            return Color("corModoModerado")
        }
    }

    var body: some View {
        NavigationView{
            ZStack {
                Color("corFundo").ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        HStack {
                            Button(action: { dismiss() }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.corPrimaria)
                                    .font(.system(size: 22))
                                    .bold()
                            }
                            Spacer()
                            
                            NavigationLink(destination: AjudaView()) {
                                Image(systemName: "questionmark.circle")
                                    .foregroundColor(.corPrimaria)
                                    .font(.system(size: 22))
                                    .bold()
                            }
                        }
                        .padding(.top, 20)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Meu perfil")
                                .font(.system(size: 17))
                                .fontWeight(.semibold)
                                .foregroundColor(Color("corTextoSecundario"))
                            
                            Text(userModel.user.nome)
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(Color("corPrimaria"))
                        }
                        
                        VStack(spacing: 24) {
                            campoDeEdicao(titulo: "Eu curso:", placeholder: "Ex: Design de Produto", texto: $curso, editando: $editando_0, numerico: false)
                            campoDeEdicao(titulo: "E estou no período:", placeholder: "Ex: 4", texto: $periodo, editando: $editando_1, numerico:true)
                        }
                        
                        VStack(alignment: .leading, spacing: 18) {
                            Text("Resumo de Atividades")
                                .font(.system(size: 20))
                                .fontWeight(.semibold)
                                .foregroundColor(Color("corPrimaria"))
                            
                            tarefasConcluidasCard()
                            modoPreferidoCard()
                            
                        }
                        
                        Spacer(minLength: 16)
                        
                        if houveMudancas {
                            Button{
                                salvarAlteracoes()
                                editando_0 = false
                                editando_1 = false
                            } label: {
                                Text("SALVAR")
                                    .font(.system(size: 16, weight: .bold))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 52)
                                    .background(Color("corPrimaria"))
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                            .animation(.easeInOut, value: houveMudancas)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
                .onTapGesture {
                    hideKeyboard()
                }
            }
            .navigationBarHidden(true)
        }
    }

    private func salvarAlteracoes() {
        userModel.atualizarUsuario(
            nome: userModel.user.nome,
            bio: userModel.user.bio,
            curso: curso,
            periodo: periodo
        )
        dismiss()
    }

    @ViewBuilder
    private func tarefasConcluidasCard() -> some View {
        HStack(spacing: 16) {
                ZStack {
                    Image("gimoMascotePerfil")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 132, height: 132)
                    
                    Text("\(tarefasConcluidasCount)")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color("corPrimaria"))
                        .offset(y: 15)
                }
                .frame(width: 132)
            
            Text("Tarefas\nConcluídas")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color("corTextoSecundario"))
                .lineSpacing(4)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .frame(minHeight: 112)
        .background(Color("corCardPerfil"))
        .cornerRadius(12)
    }

    @ViewBuilder
    private func modoPreferidoCard() -> some View {
        HStack(spacing: 10) {
            Text("Modo Preferido")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(Color("corTextoSecundario"))
                .lineSpacing(4)
            
            Spacer()
            
            Text(modoPreferido)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(corDoModo)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 7)
        .frame(maxWidth: .infinity)
        .frame(minHeight: 73)
        .background(Color("corCardPerfil"))
        .cornerRadius(12)
    }

    @ViewBuilder
    private func campoDeEdicao(titulo: String, placeholder: String, texto: Binding<String>, editando: Binding<Bool>, numerico:Bool) -> some View {
        
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(titulo)
                    .font(.system(size: 14))
                    .foregroundColor(Color("corTextoSecundario"))
                Spacer()
                Button("Editar") {
                    editando.wrappedValue = true
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color("corTextoTerciario"))
            }

            TextField(placeholder, text: texto)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color("corTextoSecundario"))
                .padding(.horizontal, 16)
                .frame(height: 52)
                .frame(maxWidth: .infinity)
                .disabled(!editando.wrappedValue)
                .keyboardType(numerico ? .numberPad : .default)
                .cornerRadius(12)
                .background {
                    if editando.wrappedValue {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.clear)
                            .stroke(Color.corStroke, lineWidth: 2)
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color("corCardPerfil"))
                    }
                }
        }
    }
}

#Preview {
    PerfilView()
}
