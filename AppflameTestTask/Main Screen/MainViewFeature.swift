import Foundation
import ComposableArchitecture

@Reducer
struct MainViewFeature {
    // MARK: - State
    @ObservableState
    struct State: Equatable {
        
        static func == (lhs: MainViewFeature.State, rhs: MainViewFeature.State) -> Bool {
            return true
        }
        
        init(dataManager: DataManager = DataManager()) {
            self.dataManager = dataManager
        }
        
        let dataManager: DataManager
        var data: [DataModel]?
        var selectedData: DataModel?
    }
    
    // MARK: - Actions
    enum Action {
        case onAppear
        case dataResponse(Result<[DataModel], DataError>)
    }
    
    // MARK: - Reducer
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        
        case .onAppear:
            let manager = state.dataManager
            return .run { send in
                do {
                    let items = try await manager.fetchData()
                    await send(.dataResponse(.success(items)))
                } catch {
                    let dataError = (error as? DataError) ?? .dataLoadingFailed
                    await send(.dataResponse(.failure(dataError)))
                }
            }
        
        case let .dataResponse(.success(items)):
            state.data = items.reversed()
            if let data = state.data?.first {
                state.selectedData = data
            }
            return .none
        
        case let .dataResponse(.failure(error)):
            print("Fetch error:", error)
            return .none
        }
    }
}


