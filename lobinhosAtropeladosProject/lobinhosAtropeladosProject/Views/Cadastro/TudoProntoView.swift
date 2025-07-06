//
//  TudoProntoView.swift
//  lobinhosAtropeladosProject
//
//  Created by Lucas Dal Pra Brascher on 06/07/25.
//

import SwiftUI

struct TudoProntoView: View {
    @Binding var foiApresentada: Bool
    @ObservedObject private var userModel = UserModel.shared

    private var modoInfo: (mascote: String, descricao: String) {
        switch userModel.user.modo_selecionado {
        case 1:
            return ("gimoMascoteTranquilo", "Seu modo é **tranquilo**. Você gosta de dias leves, calmos e com poucas tarefas. O essencial é progredir sem se sobrecarregar!")
        case 3:
            return ("gimoMascoteIntenso", "Seu modo é **intenso**. Você tem muita energia e quer aproveitar cada minuto para ser super produtivo(a). Adora um dia cheio de desafios!")
        default:
            return ("gimoMascoteModerado", "Seu modo é **moderado**. Você prefere dias produtivos sem exageros. Consegue lidar com algumas tarefas, mas prioriza o seu bem-estar.")
        }
    }
    
    var body: some View {
        ZStack {
            Color("corFundo").ignoresSafeArea()
            
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
                
                Button(action: {
                    // Ao clicar, marca que a tela já foi vista e some
                    foiApresentada = true
                }) {
                    Text("COMEÇAR A USAR")
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("corPrimaria"))
                        .foregroundColor(Color("corFundo"))
                        .cornerRadius(16)
                }
            }
            .padding(40)
        }
    }
}
