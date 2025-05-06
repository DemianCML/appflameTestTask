import SwiftUI
import ComposableArchitecture
import Charts

struct MainView: View {
    @Bindable var store: StoreOf<MainViewFeature>
    
    // MARK: - Body
    var body: some View {
        VStack {
            titleView
            chartView
//            dateBarViews
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color(.mainBackGround)
                .ignoresSafeArea()
        )
        .onAppear(perform: {
            store.send(.onAppear)
        })
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
//            statisticDateView
            
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
    


    
    private var chartView: some View {
        
        let selectedDate = store.data?.prefix(7) ?? []
                
        return Chart(selectedDate) {
                LineMark(x: .value("Date", $0.dateValue ?? Date()),
                         y: .value("Amount", $0.amount))
                .interpolationMethod(.catmullRom)
                .foregroundStyle(.chartLine)
                .lineStyle(StrokeStyle(lineWidth: 2.5))
                
                AreaMark(
                    x: .value("Date", $0.dateValue ?? Date()),
                    yStart: .value("Min Amount", selectedDate.map{ $0.amount }.min()! ),
                    yEnd: .value("Max Amount", $0.amount)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color.green.opacity(0.6), location: 0),
                            .init(color: Color.green.opacity(0.0), location: 1)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        }
        .padding(.top, 21)
        .chartLegend(.hidden)
        .chartYAxis(.hidden)
        .frame(maxWidth: .infinity,
               minHeight: 375,
               maxHeight: 375
        )
    }
    
    private var dateBarViews: some View {
        let selectedDate = store.data?.prefix(7) ?? []
        
        return HStack() {
            ForEach(selectedDate, id: \.id) { date in
                Spacer()
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 2, height: 8)
                    .foregroundStyle(Color.gray)
                Spacer()
            }
        }
        .padding(.horizontal, 24)
    }
}


