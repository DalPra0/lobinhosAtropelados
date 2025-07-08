//
//  CalendarManager.swift
//  lobinhosAtropeladosProject
//
//  Created by Lucas Dal Pra Brascher on 07/07/25.
//

import Foundation
import EventKit

enum CalendarExportResult {
    case success(exportedCount: Int)
    case failure(error: Error)
    case permissionDenied
    case noTasksToExport
}

class CalendarManager {
    static let shared = CalendarManager()
    private let eventStore = EKEventStore()

    func requestAccess(completion: @escaping (Bool) -> Void) {
        eventStore.requestFullAccessToEvents { (granted, error) in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    func exportar(
        tarefas: [Tarefa],
        completion: @escaping (Result<[UUID: String], Error>) -> Void
    ) {
        let tarefasParaExportar = tarefas.filter { $0.idDoEventoNoCalendario == nil && !$0.concluida }

        guard !tarefasParaExportar.isEmpty else {
            completion(.success([:]))
            return
        }

        var eventosExportadosComSucesso = [UUID: String]()

        for tarefa in tarefasParaExportar {
            let evento = EKEvent(eventStore: self.eventStore)
            evento.title = tarefa.nome
            evento.notes = tarefa.descricao
            
            evento.startDate = tarefa.data_entrega
            evento.endDate = tarefa.data_entrega
            evento.isAllDay = true
            
            evento.calendar = self.eventStore.defaultCalendarForNewEvents

            do {
                try self.eventStore.save(evento, span: .thisEvent)
                if let eventIdentifier = evento.eventIdentifier {
                    eventosExportadosComSucesso[tarefa.id] = eventIdentifier
                }
            } catch {
                print("Erro ao salvar evento para a tarefa \(tarefa.nome): \(error.localizedDescription)")
            }
        }
        
        completion(.success(eventosExportadosComSucesso))
    }
}
