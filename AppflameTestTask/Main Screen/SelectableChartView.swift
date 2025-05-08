import SwiftUI
import Charts

struct SelectableChartView: View {
    let data: [DataModel]
    @Binding var selectedData: DataModel?
    @Binding var showLine: Bool
    let showChartAnimation: Bool
    let selectedDateType: DateTypeEnum
    let onSelectDateType: (DateTypeEnum) -> Void

    var body: some View {
        ZStack {
            Chart(data) { point in
                LineMark(
                    x: .value("Date", point.dateValue ?? Date()),
                    y: .value("Amount", point.amount)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(.chartLine)
                .lineStyle(StrokeStyle(lineWidth: 2.5))
                .opacity(showChartAnimation ? 1 : 0)
                .offset(y: showChartAnimation ? 0 : 20)

                AreaMark(
                    x: .value("Date", point.dateValue ?? Date()),
                    yStart: .value("Min Amount", data.map(\.amount).min() ?? 0),
                    yEnd: .value("Max Amount", point.amount)
                )
                .opacity(showChartAnimation ? 0.4 : 0)
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

                if let sel = selectedData, sel.id == point.id, showLine {
                    RuleMark(
                        x: .value("Date", point.dateValue ?? Date()),
                        yStart: .value("Max Amount", point.amount),
                        yEnd:   .value("Min Amount", data.map(\.amount).min() ?? 0)
                    )
                    .foregroundStyle(.white)
                    .annotation(position: .top) {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(.chartLine)
                            .padding(.bottom, -8)
                    }

                    RuleMark(x: .value("Date", point.dateValue ?? Date()))
                        .foregroundStyle(.clear)
                        .annotation(position: .bottom) {
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: 2, height: 8)
                                .foregroundStyle(.white)
                                .padding(.bottom, -15)
                        }
                } else {
                    RuleMark(x: .value("Date", point.dateValue ?? Date()))
                        .foregroundStyle(.clear)
                        .annotation(position: .bottom) {
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: 2, height: 8)
                                .foregroundStyle(.secondaryLightGreen)
                        }
                }
            }
            .chartOverlay { proxy in
                GeometryReader { geo in
                    Rectangle()
                        .fill(.clear).contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    if selectedDateType == .week {
                                        guard let rawDate: Date = proxy.value(atX: value.location.x) else { return }
                                        let day = Calendar.current.startOfDay(for: rawDate)
                                        if let item = data.first(where: {
                                            Calendar.current.startOfDay(for: $0.dateValue ?? .distantPast) == day
                                        }) {
                                            selectedData = item
                                            showLine = true
                                        }
                                    }
                                }
                                .onEnded { _ in
                                    if selectedDateType == .week {
                                        selectedData = data.last
                                        showLine = false
                                    }
                                }
                        )
                }
            }
            .animation(.spring(.bouncy), value: showChartAnimation)
            .onAppear {
                onSelectDateType(.week)
            }
            .padding(.top, 21)
            .chartLegend(.hidden)
            .chartYAxis(.hidden)
            .chartXAxis(.hidden)
            .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 200)
        }
    }
}
