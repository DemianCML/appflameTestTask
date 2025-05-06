import SwiftUI
import ComposableArchitecture

@main
struct AppflameTestTaskApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(store: Store(initialState: MainViewFeature.State(),
                                  reducer: { MainViewFeature() }))
        }
    }
}
