import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    private init() {}

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Permissão para notificações concedida.")
            } else if let error = error {
                print("Erro ao pedir permissão para notificações: \(error.localizedDescription)")
            }
        }
    }

    func scheduleNotifications(for task: Tarefa) {
        cancelNotifications(for: task)
        
        let intervals = [7, 3, 1]
        let taskName = task.nome
        let taskId = task.id.uuidString

        for daysBefore in intervals {
            let notificationDate = Calendar.current.date(byAdding: .day, value: -daysBefore, to: task.data_entrega)
            
            guard let date = notificationDate, date > Date() else { continue }

            let content = UNMutableNotificationContent()
            content.title = "Lembrete de Tarefa"
            content.sound = .default

            switch daysBefore {
            case 7:
                content.body = "Sua tarefa '\(taskName)' vence em uma semana!"
            case 3:
                content.body = "Atenção! Faltam 3 dias para entregar '\(taskName)'."
            case 1:
                content.body = "É amanhã! Sua tarefa '\(taskName)' vence em 24 horas."
            default:
                continue
            }

            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: "\(taskId)-\(daysBefore)d", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        }
        
        scheduleDueDateNotification(for: task)
    }

    private func scheduleDueDateNotification(for task: Tarefa) {
        let taskName = task.nome
        let taskId = task.id.uuidString
        
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: task.data_entrega)
        dateComponents.hour = 9
        dateComponents.minute = 0
        
        guard let notificationDate = Calendar.current.date(from: dateComponents), notificationDate > Date() else { return }

        let content = UNMutableNotificationContent()
        content.title = "Prazo Final!"
        content.body = "URGENTE: A tarefa '\(taskName)' vence hoje! Não se esqueça."
        content.sound = .defaultCritical
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "\(taskId)-duedate", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }

    func cancelNotifications(for task: Tarefa) {
        let taskId = task.id.uuidString
        let identifiers = [
            "\(taskId)-7d",
            "\(taskId)-3d",
            "\(taskId)-1d",
            "\(taskId)-duedate"
        ]
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        print("Notificações para a tarefa '\(task.nome)' foram canceladas.")
    }
}
