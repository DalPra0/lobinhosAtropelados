import SwiftUI

struct CadastroStep1View: View {
    @Binding var nome: String
    @Binding var curso: String
    @Binding var periodo: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                
                Text("Vamos nos conhecer melhor?")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(Color("corPrimaria"))
                
                VStack(spacing: 10) {
                    campoDeEdicao(titulo: "Como você gostaria de ser chamado?", placeholder: "APELIDO", texto: $nome, numerico: false)
                    campoDeEdicao(titulo: "Qual o seu curso?", placeholder: "CURSO", texto: $curso, numerico: false)
                    campoDeEdicao(titulo: "Em qual período você está?", placeholder: "PERÍODO", texto: $periodo, numerico : true)
                }
                
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 180)
            .padding(.top,133)
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    @ViewBuilder
    private func campoDeEdicao(titulo: String, placeholder: String, texto: Binding<String>, numerico : Bool) -> some View {
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
                .keyboardType(numerico ? .numberPad : .default)
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
