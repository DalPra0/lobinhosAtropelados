import SwiftUI

struct CadastroStep1View: View {
    @Binding var nome: String
    @Binding var curso: String
    @Binding var periodo: String

    var body: some View {
        // VStack principal para organizar o conteúdo verticalmente
        VStack(alignment: .leading, spacing: 32) {
            
            // Título da tela
            Text("Vamos nos conhecer melhor?")
                .font(.system(size: 28, weight: .bold)) // Fonte SF Pro
                .foregroundColor(Color("corPrimaria"))
                .padding(.top, 40) // Espaço superior

            // --- Campos de Input ---
            VStack(spacing: 24) {
                // Campo "Nome"
                VStack(alignment: .leading, spacing: 8) {
                    Text("Qual o seu nome?")
                        .font(.system(size: 14))
                        .foregroundColor(Color("corTextoSecundario"))
                    
                    TextField("NOME", text: $nome)
                        .font(.system(size: 16))
                        .padding()
                        .background(Color("corCardPrincipal"))
                        .cornerRadius(12)
                        .foregroundColor(.black)
                }
                
                // Campo "Curso"
                VStack(alignment: .leading, spacing: 8) {
                    Text("Qual o seu curso?")
                        .font(.system(size: 14))
                        .foregroundColor(Color("corTextoSecundario"))
                    
                    TextField("CURSO", text: $curso)
                        .font(.system(size: 16))
                        .padding()
                        .background(Color("corCardPrincipal"))
                        .cornerRadius(12)
                        .foregroundColor(.black)
                }
                
                // Campo "Período"
                VStack(alignment: .leading, spacing: 8) {
                    Text("Em qual período você está?")
                        .font(.system(size: 14))
                        .foregroundColor(Color("corTextoSecundario"))
                    
                    TextField("PERÍODO", text: $periodo)
                        .font(.system(size: 16))
                        .padding()
                        .background(Color("corCardPrincipal"))
                        .cornerRadius(12)
                        .foregroundColor(.black)
                }
            }
            
            // Spacer para empurrar todo o conteúdo para cima
            Spacer()
        }
        .padding(.horizontal, 24) // Padding lateral como no seu design
    }
}

// Preview para visualização no Xcode
#Preview {
    // Para o preview funcionar, passamos valores constantes.
    ZStack {
        Color("corFundo").ignoresSafeArea()
        CadastroStep1View(
            nome: .constant(""),
            curso: .constant(""),
            periodo: .constant("")
        )
    }
}
