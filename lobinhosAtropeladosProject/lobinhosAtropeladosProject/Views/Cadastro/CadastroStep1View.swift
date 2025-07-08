import SwiftUI
import Combine

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
                    campoDeEdicao(titulo: "Qual o seu nome?", placeholder: "NOME", texto: $nome)
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
                .font(.system(size: 14))
                .foregroundColor(Color("corTextoSecundario"))
            
            let baseTextField = TextField(placeholder, text: texto)
                .font(.system(size: 16))
                .padding()
                .background(Color("corCardPrincipal"))
                .cornerRadius(12)
                .foregroundColor(.black)

            // --- CORREÇÃO APLICADA AQUI ---
            if placeholder == "PERÍODO" {
                baseTextField
                    .keyboardType(.numberPad)
                    .onReceive(Just(texto.wrappedValue)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            texto.wrappedValue = filtered
                        }
                    }
            } else {
                baseTextField
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
