//
//  ModoModeradoView.swift
//  lobinhosAtropeladosProject
//
//  Created by Lucas Dal Pra Brascher on 06/07/25.
//

import SwiftUI

struct ModoModeradoView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image("gimoMascoteModerado")
                .resizable()
                .scaledToFit()
                .frame(height: 150)

            Text("Tudo pronto!")
                .font(.title).bold()
                .foregroundColor(Color("corTextoPrincipal"))

            Text("Seu modo é **moderado**. Você prefere dias produtivos e sem exageros. Consegue lidar com algumas tarefas, mas prioriza o seu bem-estar.\n\nFique tranquilo(a), você pode mudar para outro modo sempre que quiser!")
                .font(.subheadline)
                .foregroundColor(Color("corTextoPrincipal"))
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

struct ModoModeradoView_Previews: PreviewProvider {
    static var previews: some View {
        ModoModeradoView()
    }
}
