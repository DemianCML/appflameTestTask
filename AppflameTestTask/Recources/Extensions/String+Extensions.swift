import Foundation

extension String {
    func transformDate() -> String? {
        let inputFormatter: DateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "yyyy-MM-dd"
            f.locale = Locale(identifier: "en_US_POSIX")
            return f
        }()
        
        let outputFormatter: DateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "EEEE, MMM d, yyyy"
            f.locale = Locale(identifier: "en_US_POSIX")
            return f
        }()
        
        guard let date = inputFormatter.date(from: self) else {
            return nil
        }
        
        return outputFormatter.string(from: date)
    }
    
    func replacingUnderscoresWithSpaces() -> String {
         self.replacingOccurrences(of: "_", with: " ")
     }
}
