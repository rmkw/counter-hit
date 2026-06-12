import SwiftUI

@main
struct CounterHitApp: App {
    @StateObject private var hitModel = HitModel()
    @State private var showAddHitConfirmation = false

    var body: some Scene {
        WindowGroup {
            ContentView(showAddHitConfirmation: $showAddHitConfirmation)
                .environmentObject(hitModel)
                .onOpenURL { url in
                    guard url.scheme == "counterhit", url.host == "add-hit" else {
                        return
                    }

                    showAddHitConfirmation = true
                }
                .confirmationDialog("Agregar hit de hoy?", isPresented: $showAddHitConfirmation, titleVisibility: .visible) {
                    Button("Si, agregar hit") {
                        hitModel.addHitToday()
                    }

                    Button("No, cancelar", role: .cancel) {}
                } message: {
                    Text("Si confirmas, se suma un hit al dia actual.")
                }
        }
    }
}
