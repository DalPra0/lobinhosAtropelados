import SwiftUI

struct CadastroStep3View: View {
    let estiloOrganizacao: String

    private var modoInfo: (mascote: String, descricao: String) {
        switch estiloOrganizacao {
        case "Um dia **tranquilo**, com poucas tarefas.":
            return ("gimoMascoteVerde", "Modo **tranquilo** ativado. **Não se preocupe**: você pode mudar para outro modo sempre que quiser!")
        
        case "Um dia **intenso**. Quero aproveitar para realizar muitas atividades.":
            return ("gimoMascoteLaranja", "Modo **moderado** ativado. **Não se preocupe**: você pode mudar para outro modo sempre que quiser!")
        
        default:
            return ("gimoMascoteAmarelo", "Modo **intenso** ativado. **Não se preocupe**: você pode mudar para outro modo sempre que quiser!")
        }
    }
    

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
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
