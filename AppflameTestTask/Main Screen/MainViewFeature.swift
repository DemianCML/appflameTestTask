import Foundation
import ComposableArchitecture

enum DateTypeEnum: String, CaseIterable, Identifiable {
    case week  = "Week"
    case month = "Month"
    case year  = "Year"

    var id: Self { self }
}

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
        
        @Presents var destination: Destination.State?
        let dataManager: DataManager
        var data: [DataModel]?
        var selectedData: DataModel?
        var dataUsage = 7
        var dataDownsampled = 7
        var selectedDateType: DateTypeEnum = .week
        var showChartAnimation = false
        var isSheetPresented = true
        var showLine = false
    }
    
    // MARK: - Actions
    enum Action {
        case onAppear
        case dataResponse(Result<[DataModel], DataError>)
        case selectDateType(DateTypeEnum)
        case startChartAnimation
        case setSheetPresented(Bool)
        case updateShowLine(Bool)
        case updateSelectedData(DataModel?)
        
        case destination(PresentationAction<Destination.Action>)
        case accountDetailsDestinationTapped(data: DataModel)
    }
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        Reduce { state, action in
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
                state.data = items
                if let data = state.data?.last {
                    state.selectedData = data
                }
                return .send(.startChartAnimation)
                
            case let .dataResponse(.failure(error)):
                print("Fetch error:", error)
                return .none
                
            case let .selectDateType(dateType):
                state.selectedDateType = dateType
                state.showChartAnimation = false
                switch state.selectedDateType {
                case .week:
                    state.dataUsage = 7
                    state.dataDownsampled = 7
                case .month:
                    state.dataUsage = 14
                    state.dataDownsampled = 15
                case .year:
                    state.dataUsage = 365
                    state.dataDownsampled = 30
                }
                return .none
            case let .setSheetPresented(isPresented):
                state.isSheetPresented = isPresented
                return .none
            case .startChartAnimation:
                state.showChartAnimation = true
                return .none
            case let .updateShowLine(showLine):
                state.showLine = showLine
                return .none
            case let .updateSelectedData(data):
                state.selectedData = data
                return .none
                
            case .destination:
                return .none
                
            case let .accountDetailsDestinationTapped(data: data):
                state.isSheetPresented = false
                state.destination = .showAccountDetails(AccountDetailsFeature.State(data: data))
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}



extension MainViewFeature {
    @Reducer(state: .equatable)
    enum Destination {
        case showAccountDetails(AccountDetailsFeature)
    }
}
