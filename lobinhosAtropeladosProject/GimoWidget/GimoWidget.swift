import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    typealias Entry = TaskEntry

    func placeholder(in context: Context) -> TaskEntry {
        let tarefaExemplo = Tarefa(nome: "Planejar o próximo semestre", descricao: "Verificar matérias e horários.", dificuldade: "3", data_entrega: Date())
        return TaskEntry(date: Date(), tarefa: tarefaExemplo)
    }

    func getSnapshot(in context: Context, completion: @escaping (TaskEntry) -> ()) {
        let tarefa = lerTarefaPrioritaria()
        let entry = TaskEntry(date: Date(), tarefa: tarefa)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let tarefa = lerTarefaPrioritaria()
        let entry = TaskEntry(date: Date(), tarefa: tarefa)

        let proximaAtualizacao = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(proximaAtualizacao))
        
        completion(timeline)
    }
    
    private func lerTarefaPrioritaria() -> Tarefa? {
        if let savedData = AppGroup.userDefaults.data(forKey: "TarefasLoboApp"),
           let tarefasDecodificadas = try? JSONDecoder().decode([Tarefa].self, from: savedData) {
            return tarefasDecodificadas.first(where: { !$0.concluida })
        }
        return nil
    }
}

struct TaskEntry: TimelineEntry {
    let date: Date
    let tarefa: Tarefa?
}

struct GimoWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Color("corFundoTarefa")
            
            if let tarefa = entry.tarefa {
                HStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("corCardPrincipal"))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(tarefa.nome)
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(Color("corTextoPrincipal"))
                            
                            Text(formatarDiasRestantes(from: tarefa.data_entrega))
                                .font(.caption)
                                .foregroundColor(Color("corTextoSecundario"))
                            
                            (Text("Descrição: ").bold() + Text(tarefa.descricao ?? "Sem descrição."))
                                .font(.caption)
                                .lineLimit(3)
                                .foregroundColor(Color("corTextoSecundario"))
                            
                            Spacer()
                            
                            InfoLinha(icone: "hourglass", label: "Prazo:", value: tarefa.data_entrega.formatted(.dateTime.day().month().year()))
                            
                            InfoLinha(icone: "chart.bar.fill", label: "Dificuldade:", value: formatarDificuldade(tarefa.dificuldade))
                        }
                        .padding()
                    }
                }
                .padding(12)
                
            } else {
                VStack {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(Color("corPrimaria"))
                    Text("Tudo em dia!")
                        .font(.headline)
                        .foregroundColor(Color("corTextoPrincipal"))
                    Text("Nenhuma tarefa pendente.")
                        .font(.caption)
                        .foregroundColor(Color("corTextoSecundario"))
                }
                .padding()
            }
        }
    }
    
    private func InfoLinha(icone: String, label: String, value: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icone)
                .font(.caption2)
                .frame(width: 12)
            (Text(label).bold() + Text(" \(value)"))
                .font(.caption)
        }
        .foregroundColor(Color("corTextoSecundario"))
    }
    
    private func formatarDiasRestantes(from dataEntrega: Date) -> String {
        let calendar = Calendar.current
        let hoje = calendar.startOfDay(for: Date())
        let dataFinal = calendar.startOfDay(for: dataEntrega)
        
        let components = calendar.dateComponents([.day], from: hoje, to: dataFinal)
        if let dias = components.day {
            if dias < 0 { return "Atrasada" }
            if dias == 0 { return "Entrega hoje" }
            if dias == 1 { return "Entrega amanhã" }
            return "\(dias) dias restantes"
        }
        return "Prazo indefinido"
    }
    
    private func formatarDificuldade(_ dificuldade: String) -> String {
        switch dificuldade {
        case "1": return "Muito Baixa"
        case "2": return "Baixa"
        case "3": return "Média"
        case "4": return "Alta"
        case "5": return "Muito Alta"
        default: return "Não definida"
        }
    }
}

struct GimoWidget: Widget {
    let kind: String = "GimoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            GimoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Próxima Tarefa")
        .description("Veja sua tarefa mais importante diretamente na tela de início.")
        .supportedFamilies([.systemMedium])
    }
}

struct GimoWidget_Previews: PreviewProvider {
    static var previews: some View {
        let tarefaExemplo = Tarefa(nome: "Tarefa 1", descricao: "essa tarefa é uma tarefa da matéria de biologia e a data de entrega é em 29/12", dificuldade: "4", data_entrega: Calendar.current.date(byAdding: .day, value: 10, to: Date())!)
        
        Group {
            GimoWidgetEntryView(entry: TaskEntry(date: Date(), tarefa: tarefaExemplo))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .environment(\.colorScheme, .light)

            GimoWidgetEntryView(entry: TaskEntry(date: Date(), tarefa: tarefaExemplo))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .environment(\.colorScheme, .dark)
        }
    }
}


