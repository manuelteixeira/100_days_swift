# Day 42 - Project 10, part one

- **Designing UICollectionView cells**

    **Collection views** are **extremely similar to table views**, with the exception that **they display as grids rather than as simple rows**. But while the display is different, **the underlying method calls are so similar.**

    Create, and Xcode will create a new class called **`PersonCell`** that inherits from **`UICollectionViewCell`**.

    This new class **needs to be able to represent the collection view layout we just defined in Interface Builder**, so **it just needs two outlets.**

    ```swift
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var name: UILabel!
    ```

- **UICollectionView data sources**

    When we call **`dequeueReusableCell(withReuseIdentifier:for:)`** **we’ll be sent back a regular `UICollectionViewCell`** **rather than our custom `PersonCell` type.**

    **We can fix that we’ll add a conditional typecast**, but that adds a second problem: **what do we do if our typecast fails?** That is, what if we expected to get a PersonCell but actually got back a regular UICollectionViewCell instead? **If this happens it means something is fundamentally broken in our app** – we screwed up in the storyboard, probably. **As a result, we need to get out immediately**; **there’s no point trying to make our app limp onwards when something is really broken.**

    So, **we’re going to be using** a new function called **`fatalError()`**. **When called this will unconditionally make your app crash** – it will die immediately, and print out any message you provide to it.

    1. **You should only call this when things really are bad and you don’t want to continue** – it’s really only a sense check to make sure everything is as we expect.
    2. Swift knows that **`fatalError()`** **always causes a crash, so we can use it to escape from a method that has a return value *without sending anything back*.** This makes it really convenient to use in places like our current scenario.

    ```swift
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            // we failed to get a PersonCell – bail out!
            fatalError("Unable to dequeue PersonCell.")
        }

        // if we're still here it means we got a PersonCell, so we can return it
        return cell
    }
    ```

    - **`collectionView(_:numberOfItemsInSection:)`** This must return an integer, and **tells the collection view how many items you want to show in its grid.** I've returned 10 from this method, but soon we'll switch to using an array.
    - **`collectionView(_:cellForItemAt:)`** This must return an object of type **`UICollectionViewCell`**. We already designed a prototype in Interface Builder, and configured the **`PersonCell`** class for it, so we need to create and return one of these.
    - **`dequeueReusableCell(withReuseIdentifier:for:)`** **This creates a collection view cell using the reuse identified we specified**, in this case "Person" because that was what we typed into Interface Builder earlier. But just like table views, this method will automatically try to reuse collection view cells, so as soon as a cell scrolls out of view it can be recycled so that we don't have to keep creating new ones.