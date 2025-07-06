import SwiftUI

@main
struct lobinhosAtropeladosProjectApp: App {
    init() {
        NotificationManager.shared.requestAuthorization()
    }
    
    var body: some Scene {
        WindowGroup {
            MainAppView()
        }
    }
}
