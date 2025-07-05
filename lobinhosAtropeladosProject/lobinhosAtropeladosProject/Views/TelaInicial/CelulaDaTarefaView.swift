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
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(tarefa.nome)
                        .font(.system(size: 16, weight: .semibold))
                        .strikethrough(tarefa.concluida, color: Color("corTextoSecundario"))
                    
                    if !tarefa.concluida {
                        Text(tempoRestante)
                            .font(.caption)
                            .foregroundColor(Color("corTextoSecundario"))
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
                    Divider().padding(.vertical, 4)
                    
                    if let descricao = tarefa.descricao, !descricao.isEmpty {
                        Text(descricao).font(.callout)
                    }
                    
                    // CORREÇÃO APLICADA AQUI: .long foi trocado por .wide
                    detalheItem(titulo: "Prazo", valor: tarefa.data_entrega.formatted(.dateTime.day().month(.wide).year()))
                    detalheItem(titulo: "Dificuldade", valor: "Nível \(tarefa.dificuldade)")
                }
                .padding([.horizontal, .bottom])
                .transition(.asymmetric(insertion: .opacity.combined(with: .move(edge: .top)), removal: .opacity))
            }
        }
        .padding(.horizontal)
        .background(Color("corCardPrincipal"))
        .cornerRadius(16)
        .foregroundColor(tarefa.concluida ? Color("corTextoSecundario") : .black)
        .swipeActions {
            if !tarefa.concluida {
                Button(role: .destructive, action: { tarefaModel.deletar_tarefa(id: tarefa.id) }) {
                    Label("Excluir", systemImage: "trash")
                }
                Button(action: {
                    tarefaParaEditar = tarefa.id
                    showEditModal = true
                }) {
                    Label("Editar", systemImage: "pencil")
                }.tint(.blue)
            }
        }
    }
    
    // A definição da função permanece a mesma.
    private func detalheItem(titulo: String, valor: String) -> some View {
        HStack {
            Text(titulo)
                .font(.caption.bold())
            Spacer()
            Text(valor)
                .font(.caption)
        }
    }
}
