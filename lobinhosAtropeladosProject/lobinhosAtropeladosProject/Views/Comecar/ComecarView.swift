import SwiftUI

struct ComecarView: View {
    @State private var irParaApp = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("corFundo").ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Text("Gimo")
                        .font(.secularOne(size: 60))
                        .foregroundColor(Color("corPrimaria"))
                    
                    Text("Seu assistente de produtividade chegou.")
                        .font(.body)
                        .foregroundColor(Color("corTextoSecundario"))
                    
                    Button("CONTINUAR") {
                        irParaApp = true
                    }
                    .font(.secularOne(size: 16))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("corPrimaria"))
                    .foregroundColor(Color("corFundo"))
                    .cornerRadius(16)
                    .padding(.horizontal, 40)
                    .padding(.top, 40)
                }
            }
            .navigationDestination(isPresented: $irParaApp) {
                ContentView()
            }
        }
    }
}

#Preview {
    ComecarView()
}
