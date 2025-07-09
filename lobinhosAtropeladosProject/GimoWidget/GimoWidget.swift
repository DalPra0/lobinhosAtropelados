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
                VStack(alignment: .leading, spacing: 6) {
                    Text(tarefa.nome)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color("corTextoPrincipal"))
                        .lineLimit(2)

                    Text(tarefa.descricao ?? "Sem descrição.")
                        .font(.caption)
                        .foregroundColor(Color("corTextoSecundario"))
                        .lineLimit(3)
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "hourglass")
                            .font(.caption2)
                        Text(tarefa.data_entrega, style: .date)
                            .font(.caption2)
                    }
                    .foregroundColor(Color("corTextoSecundario"))

                }
                .padding()
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
        let tarefaExemplo = Tarefa(nome: "Entregar o relatório de física quântica", descricao: "Não esquecer de citar o artigo do Dr. Schrödinger sobre o gato.", dificuldade: "5", data_entrega: Date())
        GimoWidgetEntryView(entry: TaskEntry(date: Date(), tarefa: tarefaExemplo))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
