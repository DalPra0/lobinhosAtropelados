//
//  CarregamentoView.swift
//  lobinhosAtropeladosProject
//
//  Created by Lucas Dal Pra Brascher on 08/07/25.
//

import SwiftUI
 
struct CarregamentoView: View {
    private let frames: [String] = Array(1...7).map { "Acenar-0\($0)" }
    @State private var currentFrame = 0
    
    @State private var drawingWidth = false
    
    @State private var timer = Timer.publish(every: 1e-7, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color("corFundo").ignoresSafeArea()
            
            VStack{
                Image(frames[currentFrame])
                    .resizable()
                    .frame(width: 200, height: 200)
                
                ZStack(alignment: .leading) {
                    
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(.systemGray6))
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color("corPrimaria"))
                        .frame(width: drawingWidth ? 250 : 0, alignment: .leading)
                        .animation(.easeInOut(duration: 3).repeatForever(autoreverses: false), value: drawingWidth)
                }
                .frame(width: 250, height: 12)
                .onAppear {
                    drawingWidth.toggle()
                }
                .onReceive(timer) { _ in
                    currentFrame = (currentFrame + 1) % frames.count
                    print(currentFrame)
                }
            }
        }
    }
}

#Preview {
    CarregamentoView()
}
