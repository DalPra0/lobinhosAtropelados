import SwiftUI

struct PerfilView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var userModel = UserModel.shared
    @ObservedObject var tarefaModel = TarefaModel.shared

    @State private var curso: String
    @State private var periodo: String

    init() {
        _curso = State(initialValue: UserModel.shared.user.curso)
        _periodo = State(initialValue: UserModel.shared.user.periodo)
    }

    private var tarefasConcluidasCount: Int {
        tarefaModel.tarefas.filter { $0.concluida }.count
    }

    var body: some View {
        ZStack {
            Color("corFundo").ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("corPrimaria"))
                            .font(.title2.weight(.semibold))
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 30)

                VStack(alignment: .leading, spacing: 24) {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Meu perfil")
                            .font(.system(size: 16))
                            .foregroundColor(Color("corTextoSecundario"))
                        
                        Text(userModel.user.nome)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color("corPrimaria"))
                    }

                    VStack(spacing: 24) {
                        campoDeEdicao(titulo: "Eu curso:", placeholder: "MEU CURSO", texto: $curso)
                        campoDeEdicao(titulo: "E estou no:", placeholder: "PERÍODO DO CURSO", texto: $periodo)
                    }
                }
                .padding(.horizontal, 24)

                Spacer()

                ZStack {
                    Image("gimoMascoteIntenso")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 220)

                    VStack(spacing: 4) {
                        Text("\(tarefasConcluidasCount)")
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(Color("corPrimaria"))

                        Text("Total de tarefas concluídas")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color("corTextoSecundario"))
                    }
                    .offset(y: -20)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 24)

                Button(action: salvarAlteracoes) {
                    Text("SALVAR")
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("corPrimaria"))
                        .foregroundColor(Color("corFundo"))
                        .cornerRadius(16)
                }
                .padding(.horizontal, 24)
            }
            .padding(.bottom, 40)
        }
        .navigationBarHidden(true)
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
    private func campoDeEdicao(titulo: String, placeholder: String, texto: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(titulo)
                    .font(.system(size: 14))
                    .foregroundColor(Color("corTextoSecundario"))
                Spacer()
                Button("Editar") {}
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color("corPrimaria"))
            }
            
            TextField(placeholder, text: texto)
                .font(.system(size: 16))
                .padding()
                .background(Color("corCardPrincipal"))
                .cornerRadius(12)
                .foregroundColor(.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color("corStroke"), lineWidth: 1)
                )
        }
    }
}

#Preview {
    PerfilView()
}
