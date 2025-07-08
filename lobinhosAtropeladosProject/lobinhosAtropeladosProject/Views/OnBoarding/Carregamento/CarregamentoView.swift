//
//  CarregamentoView.swift
//  lobinhosAtropeladosProject
//
//  Created by Lucas Dal Pra Brascher on 08/07/25.
//

import SwiftUI
 
struct CarregamentoView: View {
    @State private var drawingWidth = false
 
    var body: some View {
        VStack(alignment: .leading) {

            ZStack {
                Color("corFundo").ignoresSafeArea()
                
                
                ZStack(alignment: .leading) {
                    
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(.systemGray6))
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color("corPrimaria"))
                        .frame(width: drawingWidth ? 250 : 0, alignment: .leading)
                        .animation(.easeInOut(duration: 10).repeatForever(autoreverses: false), value: drawingWidth)
                }
                .frame(width: 250, height: 12)
                .onAppear {
                    drawingWidth.toggle()
                }
            }
        }
    }
}

#Preview {
    CarregamentoView()
}
