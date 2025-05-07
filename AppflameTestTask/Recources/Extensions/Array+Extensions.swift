import Foundation

extension Array {
    
  func downsampled(to maxPoints: Int) -> [Element] {
    guard count > maxPoints, maxPoints > 0 else { return self }
    let step = count / maxPoints
    return enumerated().compactMap { idx, el in
      idx % step == 0 ? el : nil
    }
  }
}

extension Array where Element == DataModel {
    func filtered(by dateType: DateTypeEnum, calendar: Calendar = .current) -> [DataModel] {
        let valid = self.compactMap { model -> (model: DataModel, date: Date)? in
            guard let d = model.dateValue else { return nil }
            return (model: model, date: d)
        }
        
        let sorted = valid.sorted { $0.date < $1.date }
        guard let latest = sorted.last?.date else { return [] }
                
        let start: Date = {
            switch dateType {
            case .week:
                return calendar.date(byAdding: .day,   value: -7,  to: latest) ?? Date()
            case .month:
                let comps = calendar.dateComponents([.year, .month], from: latest)
                return calendar.date(from: comps) ?? Date()
            case .year:
                return calendar.date(byAdding: .day,   value: -364, to: latest) ?? Date()
            }
        }()
                                
        return sorted
            .filter { $0.date >= start }
            .map { $0.model }
    }
}

