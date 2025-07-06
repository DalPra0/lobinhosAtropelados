import SwiftUI

struct CelulaDaTarefaView: View {
    // A tarefa que esta célula representa
    let tarefa: Tarefa
    
    // Bindings para controlar o estado da UI na tela principal
    @Binding var tarefaExpandidaID: UUID?
    @Binding var tarefaParaEditar: UUID?
    @Binding var showEditModal: Bool
    
    // Acesso ao modelo para ações
    @ObservedObject var tarefaModel = TarefaModel.shared
    
    // Propriedade computada para saber se esta célula está expandida
    private var isExpanded: Bool {
        tarefaExpandidaID == tarefa.id
    }
    
    // Calcula o tempo restante para a entrega
    private var tempoRestante: String {
        let calendar = Calendar.current
        let hoje = calendar.startOfDay(for: Date())
        let dataEntrega = calendar.startOfDay(for: tarefa.data_entrega)
        
        let components = calendar.dateComponents([.day], from: hoje, to: dataEntrega)
        let dias = components.day ?? 0
        
        if dias < 0 { return "Atrasada" }
        if dias == 0 { return "Entrega hoje" }
        if dias == 1 { return "Entrega amanhã" }
        return "Faltam \(dias) dias"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // --- LINHA PRINCIPAL (SEMPRE VISÍVEL) ---
            HStack(spacing: 16) {
                Button(action: { tarefaModel.marcarTarefa(tarefa: tarefa) }) {
                    Image(systemName: tarefa.concluida ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .foregroundColor(tarefa.concluida ? Color("corSelect") : Color("corPrimaria"))
                }.buttonStyle(.plain)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(tarefa.nome)
                        .font(.system(size: 16, weight: .bold))
                        .strikethrough(tarefa.concluida, color: Color("corTextoSecundario"))
                    
                    if !tarefa.concluida {
                        HStack(spacing: 4) {
                            Image(systemName: "hourglass")
                                .font(.caption)
                                .foregroundColor(Color("corTextoSecundario"))
                            Text(tempoRestante)
                                .font(.caption)
                                .foregroundColor(Color("corTextoSecundario"))
                        }
                    }
                }
                Spacer()
                
                if !tarefa.concluida {
                    Image(systemName: "chevron.down")
                        .font(.caption.bold())
                        .foregroundColor(Color("corTextoSecundario"))
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
            }
            .padding()
            .contentShape(Rectangle())
            .onTapGesture {
                guard !tarefa.concluida else { return }
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    tarefaExpandidaID = isExpanded ? nil : tarefa.id
                }
            }
            
            // --- CONTEÚDO EXPANDIDO ---
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    
                    if let descricao = tarefa.descricao, !descricao.isEmpty {
                        (Text("Descrição: ").bold() + Text(descricao))
                            .font(.callout)
                            .foregroundColor(Color(UIColor.darkGray))
                    }
                    
                    detalheItem(icone: "hourglass", label: "Prazo: ", value: tarefa.data_entrega.formatted(.dateTime.day().month(.wide).year()))
                    detalheItem(icone: "bolt.horizontal.icloud.fill", label: "Dificuldade: ", value: "Nível \(tarefa.dificuldade)")

                }
                .padding([.horizontal, .bottom])
                .transition(.asymmetric(insertion: .opacity.combined(with: .move(edge: .top)), removal: .opacity.animation(nil)))
            }
        }
        .background(Color("corFundoTarefa"))
        .cornerRadius(16)
        .foregroundColor(tarefa.concluida ? Color("corTextoSecundario") : Color(UIColor.label))
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            if !tarefa.concluida {
                Button(role: .destructive) {
                    // A chamada da função está dentro da closure, que é a forma correta.
                    tarefaModel.deletar_tarefa(id: tarefa.id)
                } label: {
                    Label("Excluir", systemImage: "trash")
                }
                
                Button {
                    tarefaParaEditar = tarefa.id
                    showEditModal = true
                } label: {
                    Label("Editar", systemImage: "pencil")
                }.tint(.blue)
            }
        }
    }
    
    private func detalheItem(icone: String, label: String, value: String) -> some View {
        HStack(alignment: .top) {
            Image(systemName: icone)
                .font(.caption)
                .foregroundColor(.secondary)
            
            (Text(label).bold() + Text(value))
                .font(.caption)
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}
