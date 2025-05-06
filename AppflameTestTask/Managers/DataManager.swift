import Foundation

enum DataError: Error {
    case fileNotFound
    case dataLoadingFailed
    case parsingFailed
}

final class DataManager {
    private let fileName: String
    private let bundle: Bundle

    init(fileName: String = "data", bundle: Bundle = .main) {
        self.fileName = fileName
        self.bundle = bundle
    }

    func fetchData() async throws -> [DataModel] {
        guard let url = bundle.url(forResource: fileName, withExtension: "csv") else {
            throw DataError.fileNotFound
        }

        let csv: String
        do {
            csv = try String(contentsOf: url, encoding: .utf8)
        } catch {
            throw DataError.dataLoadingFailed
        }

        let lines = csv
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines)
        let rows = lines.dropFirst()

        var models: [DataModel] = []
        for row in rows {
            let cols = row.components(separatedBy: ",")
            guard cols.count == 5,
                  let id = Int(cols[0]),
                  let amount = Int(cols[4])
            else { continue }

            let model = DataModel(
                id: id,
                date: cols[1],
                accountName: cols[2],
                description: cols[3],
                amount: amount
            )
            models.append(model)
        }

        return models
    }
}
