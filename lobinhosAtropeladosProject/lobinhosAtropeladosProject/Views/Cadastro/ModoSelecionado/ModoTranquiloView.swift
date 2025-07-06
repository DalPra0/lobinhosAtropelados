//
//  ModoTranquiloView.swift
//  lobinhosAtropeladosProject
//
//  Created by Lucas Dal Pra Brascher on 06/07/25.
//

import SwiftUI

struct ModoTranquiloView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image("gimoMascoteTranquilo")
                .resizable()
                .scaledToFit()
                .frame(height: 150)

            Text("Tudo pronto!")
                .font(.title).bold()
                .foregroundColor(Color("corTextoPrincipal"))

            Text("Seu modo é **tranquilo**. Você gosta de dias leves, calmos e com poucas tarefas de feito. O essencial é progredir sem se sobrecarregar meu caro(a)!\n\nNão se preocupe, você pode mudar para outro modo sempre que quiser!")
                .font(.subheadline)
                .foregroundColor(Color("corTextoPrincipal"))
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

struct ModoTranquiloView_Previews: PreviewProvider {
    static var previews: some View {
        ModoTranquiloView()
    }
}
