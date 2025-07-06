import SwiftUI

struct CadastroStep1View: View {
    @Binding var nome: String
    @Binding var curso: String
    @Binding var periodo: String

    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            
            Text("Vamos nos conhecer melhor?")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color("corPrimaria"))
                .padding(.top, 40)

            VStack(spacing: 24) {
                campoDeEdicao(titulo: "Qual o seu nome?", placeholder: "NOME", texto: $nome)
                campoDeEdicao(titulo: "Qual o seu curso?", placeholder: "CURSO", texto: $curso)
                campoDeEdicao(titulo: "Em qual período você está?", placeholder: "PERÍODO", texto: $periodo)
            }
            
            Spacer()
        }
        .padding(.horizontal, 24)
    }
    
    @ViewBuilder
    private func campoDeEdicao(titulo: String, placeholder: String, texto: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(titulo)
                .font(.system(size: 14))
                .foregroundColor(Color("corTextoSecundario"))
            
            TextField(placeholder, text: texto)
                .font(.system(size: 16))
                .padding()
                .background(Color("corCardPrincipal"))
                .cornerRadius(12)
                .foregroundColor(.black)
        }
    }
}
