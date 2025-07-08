//
//  AddTaskWidget.swift
//  lobinhosAtropeladosProject
//
//  Created by Lucas Dal Pra Brascher on 07/07/25.
//

import WidgetKit
import SwiftUI

// Este widget é muito mais simples, pois não precisa carregar dados dinâmicos.

// 1. Provider simples que não faz nada.
struct AddTaskProvider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let timeline = Timeline(entries: [SimpleEntry(date: Date())], policy: .never)
        completion(timeline)
    }
}

// 2. Estrutura de dados mínima.
struct SimpleEntry: TimelineEntry {
    let date: Date
}

// 3. O Visual do Widget de Atalho
struct AddTaskWidgetEntryView : View {
    var entry: AddTaskProvider.Entry
    
    // URL que será aberta quando o widget for tocado.
    let addTaskURL = URL(string: "gimo://addTask")

    var body: some View {
        // ZStack para colocar o ícone sobre a cor de fundo.
        ZStack {
            Color("corPrimaria") // Usa a cor primária do seu app.

            if let url = addTaskURL {
                // O Link envolve toda a área, transformando o widget em um botão.
                Link(destination: url) {
                    Image(systemName: "plus")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                }
            }
        }
    }
}

// 4. A Definição do Widget de Atalho
struct AddTaskWidget: Widget {
    let kind: String = "AddTaskWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: AddTaskProvider()) { entry in
            AddTaskWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Adicionar Tarefa")
        .description("Um atalho rápido para criar uma nova tarefa.")
        .supportedFamilies([.systemSmall]) // Define que este widget é 1x1 (quadrado pequeno).
    }
}
