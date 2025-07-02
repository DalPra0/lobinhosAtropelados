import SwiftUI

struct TarefaAddModalView: View {
    
    @ObservedObject var tarefaModel = TarefaModel.shared
    @Environment(\.dismiss) var dismiss
    
    @State private var titulo: String = ""
    @State private var descricao: String = ""
    @State private var dificuldade: String = ""
    @State private var esforco: String = ""
    @State private var importancia: String = ""
    @State private var duracao: Int = 0
    @State private var showAlertMessage = false
    
    var body: some View {
        ZStack {
            // Usando a cor de fundo do seu design
            Color("corFundo").ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) { // Ajustado o espaçamento geral
                    
                    // --- Título da Tela ---
                    Text("Adicionar Tarefa")
                        .font(.secularOne(size: 24))
                        .foregroundColor(Color("corTextoPrimario"))
                    
                    // --- Campos de Texto ---
                    VStack(alignment: .leading, spacing: 16) {
                        CustomInputField(placeholder: "Nome da Tarefa...", text: $titulo)
                        CustomInputField(placeholder: "Descrição (opcional)...", text: $descricao)
                    }
                    
                    // --- Grupos de Seleção ---
                    VStack(alignment: .leading, spacing: 24) {
                        GrupoDeSelecao(titulo: "🏋️‍♂️ Dificuldade", subtitulo: "Qual a dificuldade dessa tarefa?", opcoes: ["Baixa", "Média", "Alta"], selecao: $dificuldade)
                        GrupoDeSelecao(titulo: "💪 Esforço", subtitulo: "Quanto de esforço preciso aplicar?", opcoes: ["Baixo", "Médio", "Alto"], selecao: $esforco)
                        GrupoDeSelecao(titulo: "📝 Importância", subtitulo: "Qual a importância dessa tarefa?", opcoes: ["Baixa", "Média", "Alta"], selecao: $importancia)
                        
                        // --- Seção de Duração ---
                        VStack(alignment: .leading, spacing: 10) {
                            Text("🕐 Duração")
                                .font(.secularOne(size: 18))
                            Text("Quanto tempo vou levar para fazer?")
                                .font(.subheadline)
                                .foregroundStyle(Color("corTextoSecundario"))
                            
                            ContadorDeTempo(minutos: $duracao)
                        }
                    }
                    
                    // Mensagem de alerta
                    if showAlertMessage {
                        Text("Preencha todos os campos obrigatórios!")
                            .foregroundColor(Color("corDestaqueAlta"))
                            .font(.caption)
                    }
                    
                    // --- Botões de Ação ---
                    HStack {
                        Button("Cancelar") {
                            dismiss()
                        }
                        .buttonStyle(ModalButtonStyle(tipo: .cancelar))
                        
                        Spacer()
                        
                        Button("Salvar") {
                            if titulo.isEmpty || dificuldade.isEmpty || esforco.isEmpty || importancia.isEmpty {
                                showAlertMessage = true
                            } else {
                                tarefaModel.adiciona_tarefa(
                                    Nome: titulo,
                                    Descricao: descricao.isEmpty ? nil : descricao,
                                    Duracao_minutos: duracao,
                                    Dificuldade: dificuldade,
                                    Esforco: esforco,
                                    Importancia: importancia
                                )
                                dismiss()
                            }
                        }
                        .buttonStyle(ModalButtonStyle(tipo: .salvar))
                    }
                    .padding(.top)
                    
                }
                .padding()
                .foregroundColor(Color("corTextoPrimario"))
            }
        }
    }
}


// MARK: - Componentes Auxiliares (para manter o código limpo)

private struct GrupoDeSelecao: View {
    let titulo: String
    let subtitulo: String
    let opcoes: [String]
    @Binding var selecao: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(titulo)
                .font(.secularOne(size: 18))
            
            Text(subtitulo)
                .font(.subheadline)
                .foregroundStyle(Color("corTextoSecundario"))
            
            HStack(spacing: 10) {
                ForEach(opcoes, id: \.self) { opcao in
                    Button(action: {
                        selecao = opcao
                    }) {
                        Text(opcao)
                            .font(.secularOne(size: 14))
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(selecao == opcao ? Color("corTextoPrimario") : Color("corDestaqueMedia"))
                            .background(
                                Capsule()
                                    .fill(selecao == opcao ? Color("corDestaqueMedia") : Color("corCardSecundario"))
                            )
                    }
                }
            }
        }
    }
}

private struct ContadorDeTempo: View {
    @Binding var minutos: Int
    
    var body: some View {
        HStack {
            Button(action: {
                if minutos >= 30 { minutos -= 30 }
            }) {
                Image(systemName: "minus.circle.fill")
            }
            
            Spacer()
            
            Text(String(format: "%dh %02dmin", minutos / 60, minutos % 60))
                .font(.secularOne(size: 24))
            
            Spacer()
            
            Button(action: {
                minutos += 30
            }) {
                Image(systemName: "plus.circle.fill")
            }
        }
        .font(.title)
        .foregroundColor(Color("corDestaqueMedia"))
        .padding()
        .background(Color("corCardSecundario"))
        .cornerRadius(12)
    }
}

// Estilo para os botões de Salvar/Cancelar
private struct ModalButtonStyle: ButtonStyle {
    enum TipoBotao { case salvar, cancelar }
    var tipo: TipoBotao
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.secularOne(size: 16))
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .background(tipo == .salvar ? Color("corDestaqueBaixa") : Color("corDestaqueAlta").opacity(0.3))
            .foregroundColor(tipo == .salvar ? .black : Color("corDestaqueAlta"))
            .cornerRadius(40)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
    }
}


#Preview {
    TarefaAddModalView()
        .preferredColorScheme(.dark)
}
