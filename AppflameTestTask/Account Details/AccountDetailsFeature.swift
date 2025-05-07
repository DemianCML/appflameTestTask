import ComposableArchitecture


@Reducer
struct AccountDetailsFeature {
    
    @ObservableState
    struct State: Equatable, Hashable {
        let data: DataModel
        var id: DataModel.ID { data.id }
    }
    
    enum Action {
    }
    var body: some ReducerOf<Self> {
      Reduce { state, action in
        switch action {
        }
      }
    }
}
