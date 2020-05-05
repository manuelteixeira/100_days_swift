# Day 30 - Project 6, part one

- **Advanced Auto Layout**

    Open Main.storyboard in Interface Builder, select the bottom flag, then Ctrl-drag from the flag to the white space directly below the flag – in the view controller itself. The direction you drag is important, so please drag straight down.

    When you release your mouse button, a popup will appear that includes the option “**Bottom Space to Safe Area**” – please select that.

    This **creates a new Auto Layout constraint that the bottom of the flag must be at least X points away from the bottom of the view controller**, where **X is equal to whatever space there is in there now**.

    Although this is a valid rule, **it will screw up your layout because we now have a complete set of exact vertical rules: the top flag should be 36 points from the top, the second 30 from the first, the third 30 from the second, and the third X away from the bottom. It's 207 for me, but yours might be different.**

    Because **we've told Auto Layout exactly how big all the spaces should be**, it will add them up and divide the remaining space among the three flags however it thinks best. That is, the flags must now be stretched vertically in order to fill the space, which is almost certainly what we don't want.

    Instead, **we're going to tell Auto Layout where there is some flexibility**, and that's in the new bottom rule we just created. The bottom flag doesn't need to be precisely 207 points away from the bottom of the safe area – **it just needs to be *some* distance away, so that it doesn't touch the edge.** **If there is more space, great, Auto Layout should use it, but all we care about is the minimum.**

    Select the third flag to see its list of constraints drawn in blue, then (carefully!) select the bottom constraint we just added. In the utilities view on the right, choose the attributes inspector (Alt+Cmd+4), and you should **see Relation set to Equal and Constant set to 207** (or some other value, depending on your layout).

    What **you need to do is change Equal to be "Greater Than or Equal", then change the Constant value to be 20**. This sets the rule "make it at least 20, but you can make it more to fill up space." The layout won't change visually while you're doing this, because the end result is the same. But at least now that Auto Layout knows it has some flexibility beyond just stretching the flags!

    Our problem is still not fixed, though: **in landscape, an iPhone SE has just 320 points of space to work with, so Auto Layout is going to make our flags fit by squashing one or maybe even two of them. Squashed flags aren't good, and having uneven sizes of flags isn't good either, so we're going to add some more rules.**

    Select the second button, then Ctrl-drag to the first button. When given the list of options, choose **Equal Heights**. Now do the same from the third button to the second button. This rule ensures that at all times the three flags have the same height, so Auto Layout can no longer squash one button to make it all fit and instead has to squash all three equally.

    That fixes part of the problem, but in some respects it has made things worse. **Rather than having one squashed flag, we now have three! But with one more rule, we can stop the flags from being squashed ever.** Select the first button, then Ctrl-drag a little bit upwards – but stay within the button! When you release your mouse button, you'll see the option "**Aspect Ratio**", so please choose it.

    The **Aspect Ratio constraint solves the squashing once and for all: it means that if Auto Layout is forced to reduce the height of the flag, it will reduce its width by the same proportion, meaning that the flag will always look correct.** Add the Aspect Ratio constraint to the other two flags, and run your app again. It should work great in portrait and landscape, all thanks to Auto Layout!

- **Auto Layout in code: addConstraints() with Visual Format Language**

    ```swift
    override func viewDidLoad() {
        super.viewDidLoad()

        let label1 = UILabel()
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.backgroundColor = UIColor.red
        label1.text = "THESE"
        label1.sizeToFit()

        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.backgroundColor = UIColor.cyan
        label2.text = "ARE"
        label2.sizeToFit()

        let label3 = UILabel()
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.backgroundColor = UIColor.yellow
        label3.text = "SOME"
        label3.sizeToFit()

        let label4 = UILabel()
        label4.translatesAutoresizingMaskIntoConstraints = false
        label4.backgroundColor = UIColor.green
        label4.text = "AWESOME"
        label4.sizeToFit()

        let label5 = UILabel()
        label5.translatesAutoresizingMaskIntoConstraints = false
        label5.backgroundColor = UIColor.orange
        label5.text = "LABELS"
        label5.sizeToFit()        

        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)
    }
    ```

    We set the property **`translatesAutoresizingMaskIntoConstraints`** to be **`false`** on each label, because **by default iOS generates Auto Layout constraints for you based on a view's size and position**. **We'll be doing it by hand, so we need to disable this feature.**

    If you run the app now, you'll see seem some colorful labels at the top, overlapping so it looks like it says "LABELS ME". **That's because our labels are placed in their default position (at the top-left of the screen) and are all sized to fit their content thanks to us calling `sizeToFit()` on each of them.**

    We're going to add some constraints that say **each label should start at the left edge of its superview, and end at the right edge**. **Using** a technique called **Auto Layout Visual Format Language** (**VFL**), which is kind of **like a way of drawing the layout you want with a series of keyboard symbols.**

    ```swift
    let viewsDictionary = ["label1": label1, "label2": label2, "label3": label3, "label4": label4, "label5": label5]
    ```

    ```swift
    for label in viewsDictionary.keys {
        view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(label)]|", options: [], metrics: nil, views: viewsDictionary))
    }
    ```

    - **`view.addConstraints()`**: this **adds an array of constraints to our view controller's view.** **This array is used rather than a single constraint because VFL can generate multiple constraints at a time.**
    - **`NSLayoutConstraint.constraints(withVisualFormat:)`** **is the Auto Layout method that converts VFL into an array of constraints.** It accepts lots of parameters, but the important ones are the first and last.
    - We pass **`[]`** (an empty array) for the options parameter and **`nil`** for the metrics parameter. You can use these options to customize the meaning of the VFL, but for now we don't care.
    - look at the Visual Format Language itself: **`"H:|[label1]|"`**. As you can see it's a string, and **that string describes how we want the layout to look.** That **VFL gets converted into Auto Layout constraints, then added to the view.**
        - The **`H:`** parts **means that we're defining a horizontal layout**;
        - The pipe symbol, **`|`**, **means "the edge of the view."** We're **adding these constraints to the main view inside our view controller,** so this effectively means **"the edge of the view controller."**
        - **`[label1]`**, which is a **visual way of saying "put label1 here".** Imagine the brackets, [ and ], are the edges of the view.
        - **`"H:|[label1]|"`** means "**horizontally, I want my label1 to go edge to edge in my view.**"
        - In our **`viewsDictionary`** **we used strings for the key and `UILabels` for the value**, then set "label1" to be our label. This dictionary gets passed in along with the VFL, and gets used by iOS to look up the names from the VFL. So when it sees [label1], it looks in our dictionary for the "label1" key and uses its value to generate the Auto Layout constraints.

    ```swift
    view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1]-[label2]-[label3]-[label4]-[label5]", options: [], metrics: nil, views: viewsDictionary))
    ```

    - This time we're specifying **`V:`**, meaning t**hat these constraints are vertical.**
    - And **we have multiple views inside the VFL**, so l**ots of constraints will be generated.**
    - The **`-`** symbol, which **means "space"**. It's **10 points by default**, but you can customize it.
    - Note that **our vertical VFL doesn't have a pipe at the end,** so **we're not forcing the last label to stretch all the way to the edge of our view.** **This will leave whitespace after the last label**, which is what we want right now.