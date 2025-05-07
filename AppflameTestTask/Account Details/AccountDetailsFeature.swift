import ComposableArchitecture


@Reducer
struct AccountDetailsFeature {
    
    @ObservableState
    struct State: Equatable, Hashable {
        let data: DataModel
    }
    
    enum Action {
        case onBackButtonTapped
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onBackButtonTapped:
                return .run { send in
                    await self.dismiss()
                }
            }
        }
    }
}
