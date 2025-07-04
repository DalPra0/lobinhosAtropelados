//
//  CadastroStep3View.swift
//  lobinhosAtropeladosProject
//
//  Created by Lucas Dal Pra Brascher on 04/07/25.
//

import SwiftUI

struct CadastroStep3View: View {
    var body: some View {
        VStack {
            Spacer()
            
            Text("Tudo pronto!")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color("corPrimaria"))
            
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    ZStack {
        Color("corFundo").ignoresSafeArea()
        CadastroStep3View()
    }
}
