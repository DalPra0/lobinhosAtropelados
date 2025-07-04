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
            
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    ZStack {
        Color("corFundo").ignoresSafeArea()
        CadastroStep1View(
            nome: .constant(""),
            curso: .constant(""),
            periodo: .constant("")
        )
    }
}
