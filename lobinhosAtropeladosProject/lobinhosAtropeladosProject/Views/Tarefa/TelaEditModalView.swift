import SwiftUI

struct TelaEditModalView: View {
    
    @ObservedObject var tarefaModel = TarefaModel.shared
    @Environment(\.dismiss) var dismiss
    
    // O ID da tarefa a ser editada
    @State var id: UUID

    // Estados para guardar os dados do formulário
    @State private var titulo: String
    @State private var descricao: String
    @State private var dificuldade: String
    @State private var esforco: String
    @State private var importancia: String
    @State private var duracao: Int
    @State private var showAlertMessage = false
    
    // O 'init' carrega os dados da tarefa existente quando a tela é aberta.
    init(id: UUID) {
        self._id = State(initialValue: id)
        
        // Busca a tarefa no modelo de dados
        let tarefa = TarefaModel.shared.detalhe(id: id)
        
        // Preenche os campos do formulário com os dados da tarefa
        self._titulo = State(initialValue: tarefa.nome)
        self._descricao = State(initialValue: tarefa.descricao ?? "")
        self._dificuldade = State(initialValue: tarefa.dificuldade)
        self._esforco = State(initialValue: tarefa.esforco)
        self._importancia = State(initialValue: tarefa.importancia)
        self._duracao = State(initialValue: tarefa.duracao_minutos)
    }
    
    var body: some View {
        ZStack {
            Color("corFundo").ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    
                    Text("Editar Tarefa")
                        .font(.secularOne(size: 24))
                        .foregroundColor(Color("corTextoPrimario"))
                    
                    VStack(alignment: .leading, spacing: 16) {
                        CustomInputField(placeholder: "Nome da Tarefa...", text: $titulo)
                        CustomInputField(placeholder: "Descrição (opcional)...", text: $descricao)
                    }
                    
                    VStack(alignment: .leading, spacing: 24) {
                        GrupoDeSelecao(titulo: "🏋️‍♂️ Dificuldade", subtitulo: "Qual a dificuldade dessa tarefa?", opcoes: ["Baixa", "Média", "Alta"], selecao: $dificuldade)
                        GrupoDeSelecao(titulo: "💪 Esforço", subtitulo: "Quanto de esforço preciso aplicar?", opcoes: ["Baixo", "Médio", "Alto"], selecao: $esforco)
                        GrupoDeSelecao(titulo: "📝 Importância", subtitulo: "Qual a importância dessa tarefa?", opcoes: ["Baixa", "Média", "Alta"], selecao: $importancia)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("🕐 Duração")
                                .font(.secularOne(size: 18))
                            Text("Quanto tempo vou levar para fazer?")
                                .font(.subheadline)
                                .foregroundStyle(Color("corTextoSecundario"))
                            
                            ContadorDeTempo(minutos: $duracao)
                        }
                    }
                    
                    if showAlertMessage {
                        Text("O nome da tarefa não pode estar vazio!")
                            .foregroundColor(Color("corDestaqueAlta"))
                            .font(.caption)
                    }
                    
                    HStack {
                        Button("Cancelar") {
                            dismiss()
                        }
                        .buttonStyle(ModalButtonStyle(tipo: .cancelar))
                        
                        Spacer()
                        
                        Button("Salvar") {
                            if titulo.isEmpty {
                                showAlertMessage = true
                            } else {
                                tarefaModel.atualizar_tarefa(
                                    id: id,
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


// MARK: - Componentes Auxiliares (Reutilizados da Tela de Adicionar)

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
                            .foregroundColor(selecao == opcao ? .white : .blue)
                            .background(
                                Capsule()
                                    .fill(selecao == opcao ? Color.blue : Color.blue.opacity(0.15))
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
        .foregroundColor(.blue)
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
}

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
