import SwiftUI

struct TudoProntoView: View {
    @Binding var appState: AppState
    @Binding var foiApresentada: Bool
    @ObservedObject private var userModel = UserModel.shared

    private var modoInfo: (mascote: String, descricao: String) {
        switch userModel.user.modo_selecionado {
        case 1:
            return ("gimoMascoteVerde", "Modo **tranquilo** ativado. **Não se preocupe**: você pode mudar para outro modo sempre que quiser!")
        case 3:
            return ("gimoMascoteLaranja", "Modo **intenso** ativado. **Não se preocupe**: você pode mudar para outro modo sempre que quiser!")
        default:
            return ("gimoMascoteAmarelo", "Modo **moderado** ativado. **Não se preocupe**: você pode mudar para outro modo sempre que quiser!")
        }
    }
    
    var body: some View {
        ZStack {
            Color("corFundo").ignoresSafeArea()
            
            VStack(spacing: 10) {
                
                HStack{
                    Button{
                        appState = .cadastro2
                    }label:
                    {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.corPrimaria)
                            .font(.system(size: 22))
                            .bold()
                    }
                    Spacer()
                }
                
                VStack(spacing: 85){
                    
                    VStack(spacing: 30) {
                        Spacer()
                        
                        if let uiImage = UIImage(named: modoInfo.mascote) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 303)
                        }
                        
                        VStack(alignment:.leading,spacing: 30) {
                            Text("Tudo pronto!")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(Color("corPrimaria"))
                            
                            Text(try! AttributedString(markdown: modoInfo.descricao))
                                .font(.system(size: 16))
                                .foregroundColor(Color("corTextoSecundario"))
                                .multilineTextAlignment(.leading)
                                .lineSpacing(4)
                        }
                        
                        
                        /*Text("Não se preocupe, você pode mudar para outro modo sempre que quiser!")
                         .font(.system(size: 14))
                         .foregroundColor(.gray)
                         .multilineTextAlignment(.center)*/
                    }
                        
                        Button(action: {
                            foiApresentada = true
                        }) {
                            Text("COMEÇAR")
                                .font(.system(size: 16, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("corPrimaria"))
                                .foregroundColor(.white)
                                .cornerRadius(16)
                        }
                    
                }
            }
            .padding(.top,4)
            .padding(.bottom,24)
            .padding(.horizontal,24)
        }
    }
}
