import SwiftUI

struct CarregamentoView: View {
    @Binding var isActive: Bool
    
    private let frames: [String] = Array(1...7).map { "Acenar-0\($0)" }
    @State private var currentFrame = 0
    @State private var drawingWidth = false
    
    private let animationTimer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
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
                        .animation(.easeInOut(duration: 3), value: drawingWidth)
                }
                .frame(width: 250, height: 12)
            }
        }
        .onAppear {
            drawingWidth = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation {
                    self.isActive = false
                }
            }
        }
        .onReceive(animationTimer) { _ in
            currentFrame = (currentFrame + 1) % frames.count
        }
    }
}

struct CarregamentoView_Previews: PreviewProvider {
    static var previews: some View {
        CarregamentoView(isActive: .constant(true))
    }
}
