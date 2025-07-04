import SwiftUI

struct CadastroStep2View: View {
    // Binding para conectar com a view principal do cadastro
    @Binding var estiloOrganizacao: String
    
    // As opções que serão exibidas na tela
    private let opcoes = [
        "Poucas tarefas e um dia tranquilo.",
        "Algumas tarefas, mas sem sobrecarregar meu dia.",
        "Ser produtivo, mas ter pausas para um descanso.",
        "Foco total, quero finalizar minhas tarefas o mais rápido possível."
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            
            // --- Título ---
            VStack(alignment: .leading, spacing: 8) {
                Text("Quando o assunto é organização, o que você prefere?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color("corPrimaria"))
                
                Text("Eu prefiro...")
                    .font(.system(size: 16))
                    .foregroundColor(Color("corTextoSecundario"))
            }
            .padding(.top, 40)

            // --- Botões de Opção ---
            VStack(spacing: 16) {
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

// MARK: - Componente Auxiliar

// Um componente reutilizável para o botão de opção com estilo de "radio button"
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
                Image(systemName: isSelected ? "record.circle" : "circle")
                    .font(.title2)
                    .foregroundColor(Color("corPrimaria"))
                
                Text(texto)
                    .font(.system(size: 16))
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color("corCardPrincipal"))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color("corPrimaria") : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
        .foregroundColor(.black)
    }
}


#Preview {
    ZStack {
        Color("corFundo").ignoresSafeArea()
        CadastroStep2View(estiloOrganizacao: .constant("Poucas tarefas e um dia tranquilo."))
    }
}
