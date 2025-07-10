import SwiftUI

struct CelulaDaTarefaView: View {
    let index: Int
    let filtro: String
    let tarefa: Tarefa
    
    @Binding var tarefaExpandidaID: UUID?
    @Binding var tarefaParaEditar: UUID?
    @Binding var showEditModal: Bool
    
    let onDelete: () -> Void
    
    @ObservedObject var tarefaModel = TarefaModel.shared
    
    @State private var isCheckedForDelay: Bool = false
    @State private var workItem: DispatchWorkItem?
    
    private var isExpanded: Bool {
        tarefaExpandidaID == tarefa.id
    }
    
    private var isVisuallyCompleted: Bool {
        tarefa.concluida || isCheckedForDelay
    }
    
    var corFundo : Color{
        if index == 1{
            return Color(.corPrioridade1)
        }
        else if index == 2{
            return Color(.corSelect)
        }
        else{
            return Color(.corPrioridade3)
        }
    }
    
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
        let cellContent = VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 16) {
                Button(action: handleTap) {
                    Image(systemName: isVisuallyCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .foregroundColor(isVisuallyCompleted ? Color("corSelect") : Color("corPrimaria"))
                }.buttonStyle(.plain)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(tarefa.nome)
                        .font(.system(size: 16, weight: .bold))
                        .strikethrough(isVisuallyCompleted, color: Color("corTextoSecundario"))
                    
                    if !isVisuallyCompleted {
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
                
                // Prioridade
                if filtro == "Para hoje" {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(corFundo)
                        .frame(width: 30, height: 30)
                        .overlay(
                            Text("\(index)")
                                .font(.system(size: 16))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        )
                }
                
                /*if !isVisuallyCompleted {
                    Image(systemName: "chevron.down")
                        .font(.caption.bold())
                        .foregroundColor(Color("corTextoSecundario"))
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }*/
            }
            .padding()
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    tarefaExpandidaID = isExpanded ? nil : tarefa.id
                }
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    if let descricao = tarefa.descricao, !descricao.isEmpty {
                        (Text("Descrição: ").bold() + Text(descricao))
                            .font(.callout)
                            .foregroundColor(Color(UIColor.darkGray))
                    }
                    
                    HStack{
                        
                        VStack (alignment: .center, spacing: 12){
                            Image(systemName: "hourglass")
                                .font(.system(size: CGFloat(13)))
                                .foregroundColor(.secondary)
                            
                            Image(systemName: "dumbbell.fill")
                                .font(.system(size: CGFloat(12)))
                                .foregroundColor(.secondary)
                        }
                        VStack(alignment: .leading, spacing: 12){
                            detalheItem(label: "Prazo: ", value: tarefa.data_entrega.formatted(.dateTime.locale(Locale(identifier: "pt_BR")).day().month(.wide).year()))
                            detalheItem(label: "Dificuldade: ", value: "Nível \(tarefa.dificuldade)")
                        }
                    }

                }
                .padding([.horizontal, .bottom])
                .transition(.asymmetric(insertion: .opacity.combined(with: .move(edge: .top)), removal: .opacity.animation(nil)))
            }
        }
        .background(Color("corFundoTarefa"))
        .cornerRadius(16)
        .foregroundColor(isVisuallyCompleted ? Color("corTextoSecundario") : Color(UIColor.label))

        return cellContent
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                if !tarefa.concluida {
                    Button(role: .destructive) {
                        onDelete()
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
    
    private func handleTap() {
        if self.tarefa.concluida {
            self.workItem?.cancel()
            self.isCheckedForDelay = false
            tarefaModel.marcarTarefa(tarefa: tarefa)
            return
        }

        if self.isCheckedForDelay {
            self.workItem?.cancel()
            self.isCheckedForDelay = false
        } else {
            self.isCheckedForDelay = true
            
            let newWorkItem = DispatchWorkItem {
                tarefaModel.marcarTarefa(tarefa: tarefa)
            }
            self.workItem = newWorkItem
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: newWorkItem)
        }
    }
    
    private func detalheItem(label: String, value: String) -> some View {
        HStack(alignment: .top) {
            
            (Text(label).bold() + Text(value))
                .font(.caption)
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}
