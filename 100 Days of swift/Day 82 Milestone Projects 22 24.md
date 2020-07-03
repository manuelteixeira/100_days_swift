# Day 82 - Milestone: Projects 22-24

- Challenge
    1. Extend **`UIView`** so that it has a **`bounceOut(duration:)`** method that uses animation to scale its size down to 0.0001 over a specified number of seconds.

        ```swift
        extension UIView {
            func bounceOut(duration: Double) {
                UIView.animate(withDuration: duration) {
                    self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
                }
            }
        }
        ```

    2. Extend **`Int`** with a **`times()`** method that runs a closure as many times as the number is high. For example, **`5.times { print("Hello!") }`** will print “Hello” five times.

        ```swift
        extension Int {
            func times(execute: () -> Void) {
                guard self > 0 else { return }
                for _ in 0..<self {
                    execute()
                }
            }
        }
        ```

    3. Extend **`Array`** so that it has a mutating **`remove(item:)`** method. If the item exists more than once, it should remove only the first instance it finds. Tip: you will need to add the **`Comparable`** constraint to make this work!

        ```swift
        extension Array where Element: Comparable {
            mutating func remove(item: Element) {
                guard let index = self.firstIndex(of: item) else { return }
                self.remove(at: index)
            }
        }
        ```