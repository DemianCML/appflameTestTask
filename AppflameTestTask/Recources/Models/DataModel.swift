import Foundation

struct DataModel: Identifiable, Codable, Equatable {
    let id: Int
    let date: String
    let accountName: String
    let description: String
    let amount: Int
    
    
    enum CodingKeys: String, CodingKey {
          case id, date
          case accountName = "account_name"
          case description, amount
      }
}

extension DataModel {
    private static let isoFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }()
    
    var dateValue: Date? {
        Self.isoFormatter.date(from: date)
    }
}

extension DataModel: Hashable {
    static func == (lhs: DataModel, rhs: DataModel) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
