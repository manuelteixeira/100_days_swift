# Day 57 - Project 15, part one

- **Preparing for action**

    Every time the user taps the "Tap" button, we're going to execute a different animation. This will be accomplished by cycling through a counter, and moving an image view. To make all that work, you need to add two more properties to the class:

    ```swift
    var imageView: UIImageView!
    var currentAnimation = 0
    ```

    Add in **`viewDidLoad()`**

    ```swift
    imageView = UIImageView(image: UIImage(named: "penguin"))
    imageView.center = CGPoint(x: 512, y: 384)
    view.addSubview(imageView)
    ```

    ```swift
    @IBAction func tapped(_ sender: Any) {
        currentAnimation += 1
        
        if currentAnimation > 7 {
            currentAnimation = 0
        }
    }
    ```

- **Switch, case, animate: animate(withDuration:)**

    The **`currentAnimation`** property **can have a value between 0 and 7**, **each one triggering a different animation**. 

    This switch/case statement is going to go inside a new method of the UIView class called **`animate(withDuration:)`**, which is a kind of method you haven't seen before because it actually **accepts two closures**. The **parameters** we'll be using are **how long to animate for**, **how long to pause before the animation starts**, **any options** you want to provide, **what animations to execute**, and finally a **closure that will execute when the animation finishes.**

    ```swift
    @IBAction func tapped(_ sender: UIButton) {
        sender.isHidden = true

        UIView.animate(withDuration: 1, delay: 0, options: [],
           animations: {
            switch self.currentAnimation {
            case 0:
                break

            default:
                break
            }
        }) { finished in
            sender.isHidden = false
        }

        currentAnimation += 1

        if currentAnimation > 7 {
            currentAnimation = 0
        }
    }
    ```

    **Note**: Because we want to show and hide the “Tap” button, we need to make the sender parameter to that method be a **`UIButton`** rather than Any.

    Here's a breakdown of the code:

    - When the method begins, **we hide the `sender` button so that our animations don't collide**; **it gets unhidden in the completion closure of the animation.**
    - We call **`animate(withDuration:)`** with a duration of 1 second, no delay, and no interesting options.
    - For the **`animations`** closure **we *don’t* need to use `[weak self]` because there’s no risk of strong reference cycles here** – the closures passed to **`animate(withDuration:)`** method will be used once then thrown away.
    - We switch using the value of **`self.currentAnimation`**. **We need to use `self` to make the closure capture clear**, remember. This **`switch/case`** does nothing yet, because both possible cases just call **`break`**.
    - We **use trailing closure syntax to provide our completion closure**. This will be called when the animation completes, and its **`finished`** **value will be true if the animations completed fully.**
    - As I said, the completion closure unhides the **`sender`** button so it can be tapped again.
    - After the **`animate(withDuration:)`** call, we have the old code to modify and wrap **`currentAnimation`**.

- **Transform: CGAffineTransform**

    **`CGAffineTransform`** This is a structure that **represents a specific kind of transform that we can apply to any `UIView` object or subclass.**

    **As we'll be doing this inside an animation block**, **the transform will automatically be animated**. This illustrates one of the many powerful things of Core Animation: you tell it what you want to happen, and it calculates all the intermediary states automatically.

    ```swift
    switch self.currentAnimation {
    case 0:
        self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
    default:
        break
    }
    ```

    That uses an initializer for **`CGAffineTransform`** **that takes an X and Y scale value as its two parameters**. A value of 1 means "the default size," so 2, 2 will make the view twice its normal width and height. **By default, UIKit animations have an "ease in, ease out" curve, which means the movement starts slow, accelerates, then slows down again before reaching the end.**

    The next case is going to be 1, and we're going to use a special existing transform called **`CGAffineTransform.identity`**, or just **`.identity`**. This effectively **clears our view of any pre-defined transform, resetting any changes that have been applied by modifying its transform property.**

    ```swift
    case 1:
        self.imageView.transform = .identity
    ```

    ```swift
    case 2:
        self.imageView.transform = CGAffineTransform(translationX: -256, y: -256)

    case 3:
        self.imageView.transform = .identity
    ```

    That uses another new initializer for **`CGAffineTransform`** that **takes X and Y values for its parameters**. **These values are deltas**, **or differences from the current value**, meaning that the above code **subtracts 256 from both the current X and Y position.**

    We can also use **`CGAffineTransform`** **to rotate views**, using its **`rotationAngle`** initializer. This **accepts one parameter**, which is the **amount in radians you want to rotate**. **There are three catches to using this function:**

    1. You need to **provide the value in radians** specified as a **`CGFloat`**. This usually isn't a problem – if you type 1.0 in there, Swift is smart enough to make that a **`CGFloat`** automatically. If you want to use a value like pi, use **`CGFloat.pi`**.
    2. Core Animation **will always take the shortest route to make the rotation work**. So, if your object is straight and you rotate to 90 degrees (radians: half of pi), it will rotate clockwise. If your object is straight and you rotate to 270 degrees (radians: pi + half of pi) it will rotate counter-clockwise because it's the smallest possible animation.
    3. A consequence of the second catch is that if you try to rotate 360 degrees (radians: pi times 2), Core Animation will calculate the shortest rotation to be "just don't move, because we're already there." The same goes for values over 360, for example if you try to rotate 540 degrees (one and a half full rotations), you'll end up with just a 180-degree rotation.

    ```swift
    case 4:
        self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    case 5:
        self.imageView.transform = .identity
    ```

    As well as animating transforms, **Core Animation can animate many of the properties of your views**. For example, **it can animate the background color of the image view**, **or the level of transparency.** You can even change multiple things at once if you want something more complicated to happen.

    ```swift
    case 6:
        self.imageView.alpha = 0.1
        self.imageView.backgroundColor = UIColor.green

    case 7:
        self.imageView.alpha = 1
        self.imageView.backgroundColor = UIColor.clear
    ```

    This changes the **animate(withDuration:) so that it uses spring animations rather than the default, ease-in-ease-out animation.**

    **Final code**

    ```swift
    //        UIView.animateKeyframes(withDuration: 1, delay: 0, options: [], animations: {
      UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
          switch self.currentAnimation {
          case 0:
              self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
          case 1:
              self.imageView.transform = .identity
          case 2:
              self.imageView.transform = CGAffineTransform(translationX: -256, y: -256)
          case 3:
              self.imageView.transform = .identity
          case 4:
              self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
          case 5:
              self.imageView.transform = .identity
          case 6:
              self.imageView.alpha = 0.1
              self.imageView.backgroundColor = .green
          case 7:
              self.imageView.alpha = 1
              self.imageView.backgroundColor = .clear
          default:
              break
          }
      }) { finished in
          sender.isHidden = false
      }
    ```