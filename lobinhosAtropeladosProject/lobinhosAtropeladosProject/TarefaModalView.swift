import SwiftUI

struct TarefaModalView: View {
    // Adicione esta propriedade para poder fechar a sheet
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text("Esta é a sua Nova Sheet!")
                .font(.largeTitle)
                .padding()

            Text("Ela ocupa a tela inteira.")
                .font(.title2)
                .padding(.bottom, 20)

            Button("Fechar Sheet") {
                dismiss() // Fecha a sheet
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Faz a VStack preencher a tela
        .background(Color.yellow.opacity(0.3).ignoresSafeArea()) // Um fundo para destacar
    }
}

#Preview {
    TarefaModalView()
}
