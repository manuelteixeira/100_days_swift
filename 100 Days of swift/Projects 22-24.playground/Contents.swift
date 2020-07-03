import UIKit

extension UIView {
    func bounceOut(duration: Double) {
        UIView.animate(withDuration: duration) {
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
}

let view = UIView(frame: CGRect(x: 0, y: 0, width: 128, height: 128))
view.backgroundColor = .red
view.bounceOut(duration: 5)

extension Int {
    func times(execute: () -> Void) {
        guard self > 0 else { return }
        for _ in 0..<self {
            execute()
        }
    }
}

let test = 5
test.times {
    print("Hello")
}

extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        guard let index = self.firstIndex(of: item) else { return }
        self.remove(at: index)
    }
}

var array = [1, 2, 3, 4, 2, 3]
array.remove(item: 2)
