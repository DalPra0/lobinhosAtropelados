import SwiftUI

struct CadastroStep1View: View {
    @Binding var nome: String
    @Binding var curso: String
    @Binding var periodo: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                
                Text("Vamos nos conhecer melhor?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color("corPrimaria"))
                    .padding(.top, 40)

                VStack(spacing: 24) {
                    campoDeEdicao(titulo: "Como quer ser chamado?", placeholder: "APELIDO", texto: $nome)
                    campoDeEdicao(titulo: "Qual o seu curso?", placeholder: "CURSO", texto: $curso)
                    campoDeEdicao(titulo: "Em qual período você está?", placeholder: "PERÍODO", texto: $periodo)
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 50)
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    @ViewBuilder
    private func campoDeEdicao(titulo: String, placeholder: String, texto: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(titulo)
                .font(.system(size: 16))
                .fontWeight(.medium)
                .foregroundColor(Color("corTextoSecundario"))
            
            TextField(placeholder, text: texto,
                      prompt: Text(placeholder)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.corStroke)
                )
                .font(.system(size: 16))
                .foregroundColor(.black)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.corFundo)
                        .stroke(Color.corStroke, lineWidth: 2)
                }
        }
    }
}



#if canImport(UIKit)


extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
