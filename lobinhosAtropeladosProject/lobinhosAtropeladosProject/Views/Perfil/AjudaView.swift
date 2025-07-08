//
//  AjudaView.swift
//  lobinhosAtropeladosProject
//
//  Created by Beatriz Perotto Muniz on 08/07/25.
//

import SwiftUI

struct AjudaView: View {
    
    @Environment(\.dismiss) var dismiss//para fazer funcao de back

    
    var body: some View {
        ZStack {
            Color("corFundo").ignoresSafeArea()
            
            ScrollView {
                VStack(alignment:.leading, spacing : 24){
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.corPrimaria)
                                .font(.system(size: 22))
                                .bold()
                        }
                        Spacer()
                    }
                    .padding(.top, 20)
                    
                    VStack(alignment:.leading, spacing : 8){
                        
                        Text("Hello, World!")
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AjudaView()
}
