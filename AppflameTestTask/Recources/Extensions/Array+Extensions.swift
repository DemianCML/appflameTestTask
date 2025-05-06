
extension Array {
  func downsampled(to maxPoints: Int) -> [Element] {
    guard count > maxPoints, maxPoints > 0 else { return self }
    let step = count / maxPoints
    return enumerated().compactMap { idx, el in
      idx % step == 0 ? el : nil
    }
  }
}
