import SwiftUI
import ComposableArchitecture

struct MainView: View {
    
    @Bindable var store: StoreOf<MainViewFeature>
    
    // MARK: - Body
    var body: some View {
        
        let bottomSheetBinding = Binding(
            get: { store.state.isSheetPresented },
            set: { store.send(.setSheetPresented($0)) }
        )
        
        NavigationStack {
            VStack {
                titleView
                chartView(selectedData: store.data?.filtered(by: store.state.selectedDateType).downsampled(to: store.state.dataDownsampled) ?? [])
                selectionButtonView
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color(.mainBackGround)
                    .ignoresSafeArea()
            )
            .onAppear(perform: {
                store.send(.onAppear)
                store.send(.startChartAnimation, animation: .bouncy)
                bottomSheetBinding.wrappedValue = true
            })
            .sheet(isPresented: bottomSheetBinding) {
                bottomSheetView(selectedData: store.data?.filtered(by: store.state.selectedDateType) ?? [])
                    .presentationCornerRadius(32)
                    .interactiveDismissDisabled()
                    .presentationDetents([.fraction(0.35), .fraction(0.95)])
                    .presentationDragIndicator(.visible)
                    .presentationBackgroundInteraction(.enabled)
            }
            .navigationDestination(item: $store.scope(state: \.destination?.showAccountDetails, action: \.destination.showAccountDetails)) { store in
                AccountDetailsView(store: store)
            }
            
        }
    }
    
    
    
    // MARK: - Title View
    private var titleView: some View {
        VStack(alignment: .center) {
            Text("Statistics")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.top, 15)
                .padding(.bottom, 25)
            statisticDetailsView
                .padding(.bottom, 4)
            statisticDateView
            
        }
    }
    
    // MARK: - Statistic Details View
    private var statisticDetailsView: some View {
        VStack(alignment: .center, spacing: 4) {
            HStack(spacing: 0) {
                Text("$")
                    .font(.system(size: 48, weight: .regular))
                    .foregroundStyle(.secondaryLightGreen)
                Text("\(store.selectedData?.amount ?? 0)")
                    .font(.system(size: 48, weight: .regular))
                    .foregroundStyle(.white)
                
            }
        }
    }
    
    // MARK: - Statistic Date View
    private var statisticDateView: some View {
        Text("\(store.selectedData?.date.transformDate() ?? "")")
            .font(.system(size: 13, weight: .regular))
            .foregroundStyle(.secondaryLightGreen)
    }
    
    
    //    // MARK: - Chart View
    private func  chartView(selectedData: [DataModel]) -> some View {
        
        let selectedDataBinding = Binding(
            get: { store.state.selectedData },
            set: { store.send(.updateSelectedData($0)) }
        )
        
        let showLineBinding = Binding(
            get: { store.state.showLine },
            set: { store.send(.updateShowLine($0)) }
        )
        
        return SelectableChartView(data: selectedData,
                                   selectedData: selectedDataBinding,
                                   showLine: showLineBinding,
                                   showChartAnimation: store.state.showChartAnimation,
                                   selectedDateType: store.state.selectedDateType) { dateType in
            store.send(.selectDateType(dateType), animation: .bouncy)
        }
        
    }
    
    
    // MARK: - Selection Button View
    private var selectionButtonView: some View {
        HStack(spacing: 4) {
            ForEach(DateTypeEnum.allCases) { type in
                Button(type.rawValue) {
                    store.send(.selectDateType(type))
                    store.send(.startChartAnimation, animation: .bouncy)
                }
                .buttonStyle(
                    PillButtonStyle(isSelected: store.state.selectedDateType == type)
                )
                .disabled(store.state.selectedDateType == type)
            }
        }
        .padding(.top, 24)
    }
    
    // MARK: - Bottom Sheet
    private func bottomSheetView(selectedData: [DataModel]) -> some View {
        VStack(alignment: .leading) {
            Text("Accounts")
                .foregroundStyle(.black)
                .font(.system(size: 20, weight: .medium))
                .padding(.top, 40)
                .padding(.leading, 16)
            
            ScrollView {
                ForEach(selectedData, id: \.id) { account in
                    transactionDetailsRow(data: account)
                }
            }
            .scrollIndicators(.hidden)
        }
    }
    
    private func transactionDetailsRow(data: DataModel) -> some View {
        VStack(spacing: 0) {
            HStack {
                Image(.logo)
                    .resizable()
                    .frame(width: 48, height: 48)
                    .padding(.trailing, 16)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(data.accountName.replacingUnderscoresWithSpaces())
                        .foregroundStyle(.black)
                        .font(.system(size: 16, weight: .medium))
                    Text(data.description.replacingUnderscoresWithSpaces())
                        .foregroundStyle(.gray)
                        .font(.system(size: 13, weight: .regular))
                }
                
                Spacer()
                
                Text("$\(data.amount)")
                    .foregroundStyle(.black)
                    .font(.system(size: 16, weight: .medium))
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            
            Divider()
                .background(Color.gray.opacity(0.2))
                .padding(.leading, 64)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            store.send(.accountDetailsDestinationTapped(data: data))
        }
    }
}
