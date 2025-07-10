import SwiftUI

struct CadastroStep2View: View {
    @Binding var estiloOrganizacao: String
    
    private let opcoes = [
        "Um dia **tranquilo**, com poucas tarefas.",
        "Um dia **moderado**, que seja produtivo mas sem exageros.",
        "Um dia **intenso**. Quero aproveitar para realizar muitas atividades."
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 31) {
                Text("Na sua rotina de tarefas,qual seu modo preferido?")
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(Color("corPrimaria"))
                
                Text("Eu prefiro...")
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
                    .foregroundColor(Color("corTextoSecundario"))
            }
            .padding(.top, 82)

            VStack(spacing: 10) {
                ForEach(opcoes, id: \.self) { opcao in
                    BotaoDeOpcao(
                        texto: opcao,
                        selecaoAtual: $estiloOrganizacao
                    )
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}


private struct BotaoDeOpcao: View {
    let texto: String
    @Binding var selecaoAtual: String
    
    var isSelected: Bool {
        texto == selecaoAtual
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                selecaoAtual = texto
            }
        }) {
            HStack(spacing: 16) {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .font(.title2)
                    .foregroundColor(Color("corPrimaria"))
                
                Text((try! AttributedString(markdown: texto)))
                    .font(.system(size: 15))
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("corCardPerfil"))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color("corPrimaria") : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
        .foregroundColor(.black)
    }
}
