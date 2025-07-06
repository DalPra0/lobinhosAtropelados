import SwiftUI

struct CadastroStep3View: View {
    // Recebe o estilo para saber o que mostrar
    let estiloOrganizacao: String

    // Propriedade que retorna a imagem e o texto corretos
    private var modoInfo: (mascote: String, descricao: String) {
        switch estiloOrganizacao {
        case "Poucas tarefas e um dia tranquilo.":
            return ("gimoMascoteTranquilo", "Seu modo é **tranquilo**. Você gosta de dias leves, calmos e com poucas tarefas. O essencial é progredir sem se sobrecarregar!")
        
        case "Foco total, quero finalizar minhas tarefas o mais rápido possível.":
            return ("gimoMascoteIntenso", "Seu modo é **intenso**. Você tem muita energia e quer aproveitar cada minuto para ser super produtivo(a). Adora um dia cheio de desafios!")
        
        default: // Cobre as duas opções de modo "moderado"
            return ("gimoMascoteModerado", "Seu modo é **moderado**. Você prefere dias produtivos sem exageros. Consegue lidar com algumas tarefas, mas prioriza o seu bem-estar.")
        }
    }

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Garante que a imagem existe antes de tentar usá-la
            if let uiImage = UIImage(named: modoInfo.mascote) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            }
            
            VStack(spacing: 16) {
                Text("Tudo pronto!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color("corPrimaria"))
                
                // Usando AttributedString para poder usar **negrito** no meio do texto
                Text(try! AttributedString(markdown: modoInfo.descricao))
                    .font(.system(size: 16))
                    .foregroundColor(Color("corTextoSecundario"))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            
            Spacer()
            
            Text("Não se preocupe, você pode mudar para outro modo sempre que quiser!")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(40)
    }
}
