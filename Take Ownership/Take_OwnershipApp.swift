import SwiftUI

@main
struct Take_OwnershipApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().fixedSize()
        }
        .windowResizability(.contentSize)
    }
}
