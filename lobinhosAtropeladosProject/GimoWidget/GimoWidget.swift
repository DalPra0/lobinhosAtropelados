import WidgetKit
import SwiftUI

// Passo 1: O "Fornecedor" de Dados do Widget
// Esta estrutura é responsável por buscar os dados (nossas tarefas)
// e criar "snapshots" do widget para serem exibidos na tela de início.
struct Provider: TimelineProvider {
    // Define um tipo de entrada para o nosso widget, que conterá a tarefa a ser exibida.
    typealias Entry = TaskEntry

    // Mostra uma versão genérica do widget na galeria.
    func placeholder(in context: Context) -> TaskEntry {
        let tarefaExemplo = Tarefa(nome: "Planejar o próximo semestre", descricao: "Verificar matérias e horários.", dificuldade: "3", data_entrega: Date())
        return TaskEntry(date: Date(), tarefa: tarefaExemplo)
    }

    // Fornece um snapshot rápido para exibições temporárias.
    func getSnapshot(in context: Context, completion: @escaping (TaskEntry) -> ()) {
        let tarefa = lerTarefaPrioritaria()
        let entry = TaskEntry(date: Date(), tarefa: tarefa)
        completion(entry)
    }

    // A função principal: busca os dados e define quando o widget deve ser atualizado.
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // Busca a tarefa mais importante.
        let tarefa = lerTarefaPrioritaria()
        let entry = TaskEntry(date: Date(), tarefa: tarefa)

        // Define a política de atualização. Vamos pedir para o sistema atualizar daqui a uma hora.
        let proximaAtualizacao = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(proximaAtualizacao))
        
        completion(timeline)
    }
    
    // Função auxiliar para ler as tarefas do armazenamento compartilhado.
    private func lerTarefaPrioritaria() -> Tarefa? {
        // Acessa os dados salvos através do nosso App Group.
        if let savedData = AppGroup.userDefaults.data(forKey: "TarefasLoboApp"),
           let tarefasDecodificadas = try? JSONDecoder().decode([Tarefa].self, from: savedData) {
            
            // A sua lista de tarefas já está ordenada por prioridade.
            // A tarefa mais importante é a primeira da lista que não está concluída.
            return tarefasDecodificadas.first(where: { !$0.concluida })
        }
        return nil
    }
}

// Passo 2: A Estrutura de Dados do Widget
// Um "TimelineEntry" que representa um momento na linha do tempo do widget.
struct TaskEntry: TimelineEntry {
    let date: Date
    let tarefa: Tarefa? // A tarefa pode ser nula se não houver nenhuma.
}

// Passo 3: O Visual do Widget
// Esta é a View em SwiftUI que será exibida na tela de início.
struct GimoWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        // Usamos um ZStack para o fundo e o conteúdo.
        ZStack {
            // Cor de fundo para combinar com o app.
            Color("corFundoTarefa")

            if let tarefa = entry.tarefa {
                // Se temos uma tarefa, mostramos seus detalhes.
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
                // Se não há tarefas, mostramos uma view de placeholder.
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

// Passo 4: A Definição Principal do Widget
// Aqui juntamos tudo e configuramos o widget.
// --- CORREÇÃO: O atributo @main foi removido daqui. ---
struct GimoWidget: Widget {
    let kind: String = "GimoWidget" // Um identificador único para este tipo de widget.

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            GimoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Próxima Tarefa")
        .description("Veja sua tarefa mais importante diretamente na tela de início.")
        .supportedFamilies([.systemMedium]) // Define que este widget é 1x2 (retangular médio).
    }
}

// Passo 5: Preview para o Xcode (Opcional, mas útil)
struct GimoWidget_Previews: PreviewProvider {
    static var previews: some View {
        let tarefaExemplo = Tarefa(nome: "Entregar o relatório de física quântica", descricao: "Não esquecer de citar o artigo do Dr. Schrödinger sobre o gato.", dificuldade: "5", data_entrega: Date())
        GimoWidgetEntryView(entry: TaskEntry(date: Date(), tarefa: tarefaExemplo))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
