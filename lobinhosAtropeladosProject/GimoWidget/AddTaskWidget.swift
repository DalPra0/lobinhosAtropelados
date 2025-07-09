//
//  AddTaskWidget.swift
//  lobinhosAtropeladosProject
//
//  Created by Lucas Dal Pra Brascher on 07/07/25.
//

import WidgetKit
import SwiftUI


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

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct AddTaskWidgetEntryView : View {
    var entry: AddTaskProvider.Entry
    
    let addTaskURL = URL(string: "gimo://addTask")

    var body: some View {
        ZStack {
            Color("corPrimaria")

            if let url = addTaskURL {
                Link(destination: url) {
                    Image(systemName: "plus")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                }
            }
        }.ignoresSafeArea()
    }
}


struct AddTaskWidget: Widget {
    let kind: String = "AddTaskWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: AddTaskProvider()) { entry in
            AddTaskWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Adicionar Tarefa")
        .description("Um atalho rápido para criar uma nova tarefa.")
        .supportedFamilies([.systemSmall])
    }
}
