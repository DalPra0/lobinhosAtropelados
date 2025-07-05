import SwiftUI

struct PerfilView: View {
    @ObservedObject var userModel = UserModel.shared
    @Environment(\.dismiss) var dismiss

    // States locais para edição, inicializados com os dados do usuário
    @State private var curso: String
    @State private var periodo: String

    // Controla o foco dos campos de texto para o botão "Editar" funcionar
    @FocusState private var isCursoFocused: Bool
    @FocusState private var isPeriodoFocused: Bool

    init() {
        // Inicializa os states com os valores atuais do usuário
        _curso = State(initialValue: UserModel.shared.user.curso)
        _periodo = State(initialValue: UserModel.shared.user.periodo)
    }

    var body: some View {
        ZStack {
            Color("corFundo").ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                // 1. Cabeçalho com botão de voltar
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("corPrimaria"))
                            .font(.title2.weight(.semibold))
                    }
                    Spacer()
                }
                .padding(.bottom, 30)

                // 2. Títulos
                Text("Meu perfil")
                    .font(.system(size: 16))
                    .foregroundColor(Color("corTextoSecundario"))
                
                Text(userModel.user.nome)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color("corPrimaria"))
                    .padding(.bottom, 40)

                // 3. Campos de Edição
                campoDeEdicao(titulo: "Eu curso:", placeholder: "MEU CURSO", texto: $curso, isFocused: $isCursoFocused)
                    .padding(.bottom, 30)
                
                campoDeEdicao(titulo: "E estou no:", placeholder: "PERÍODO DO CURSO", texto: $periodo, isFocused: $isPeriodoFocused)

                Spacer() // Empurra o botão de salvar para baixo

                // 4. Botão de Salvar
                Button(action: salvarAlteracoes) {
                    Text("SALVAR")
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("corPrimaria"))
                        .foregroundColor(Color("corFundo"))
                        .cornerRadius(16)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
        .navigationBarHidden(true)
    }

    /// View reutilizável para os campos de texto, para manter o código limpo.
    @ViewBuilder
    private func campoDeEdicao(titulo: String, placeholder: String, texto: Binding<String>, isFocused: FocusState<Bool>.Binding) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(titulo)
                    .font(.system(size: 14))
                    .foregroundColor(Color("corTextoSecundario"))
                Spacer()
                Button("Editar") {
                    isFocused.wrappedValue = true
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color("corPrimaria"))
            }
            
            // --- CAMPO DE TEXTO COM DESIGN 100% CORRIGIDO ---
            TextField("", text: texto, prompt: Text(placeholder)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(Color("corStroke"))
            )
                .textInputAutocapitalization(.words)
                .font(.system(size: 16))
                .padding()
                .background(Color("corCardPrincipal"))
                .cornerRadius(12)
                .foregroundColor(.black)
                .focused(isFocused)
                .overlay(
                    // Borda visível o tempo todo, que muda de cor quando focada.
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isFocused.wrappedValue ? Color("corPrimaria") : Color("corStroke"), lineWidth: 1)
                )
        }
    }

    /// Salva os dados alterados no UserModel e fecha a tela.
    private func salvarAlteracoes() {
        userModel.atualizarUsuario(
            nome: userModel.user.nome,
            bio: userModel.user.bio,
            curso: curso,
            periodo: periodo
        )
        dismiss()
    }
}

#Preview {
    PerfilView()
}
