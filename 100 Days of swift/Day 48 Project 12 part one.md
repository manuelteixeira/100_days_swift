# Day 48 - Project 12, part one

- **Reading and writing basics: UserDefaults**

    You can use **`UserDefaults`** to **store any basic data type for as long as the app is installed**. 

    You can write basic types such as Bool, Float, Double, Int, String, or URL, but you can also write more complex types such as arrays, dictionaries and Date – and even Data values.

    **When you write data to `UserDefaults`, it automatically gets loaded when your app runs so that you can read it back again.** 

    This makes using it really easy, but you need to know that **it's a bad idea to store lots of data in there because it will slow loading of your app**. 

    **If you think your saved data would take up more than say 100KB**, **`UserDefaults` is almost certainly the wrong choice.**

    To get started with **`UserDefaults`**, you **create a new instance** of the class like this:

    ```swift
    let defaults = UserDefaults.standard
    ```

    You just **need to give each one a unique key so you can reference it later.** 

    ```swift
    let defaults = UserDefaults.standard
    defaults.set(25, forKey: "Age")
    defaults.set(true, forKey: "UseTouchID")
    defaults.set(CGFloat.pi, forKey: "Pi")
    ```

    Using **`set()` for these advanced types is just the same as using the other data types**:

    ```swift
    defaults.set("Paul Hudson", forKey: "Name")
    defaults.set(Date(), forKey: "LastRun")

    let array = ["Hello", "World"]
    defaults.set(array, forKey: "SavedArray")

    let dict = ["Name": "Paul", "Country": "UK"]
    defaults.set(dict, forKey: "SavedDict")
    ```

    When you're **reading values from `UserDefaults` you need to check the return type carefully to ensure you know what you're getting**. Here's what you need to know:

    - **`integer(forKey:)`** returns an integer if the key existed, or 0 if not.
    - **`bool(forKey:)`** returns a boolean if the key existed, or false if not.
    - **`float(forKey:)`** returns a float if the key existed, or 0.0 if not.
    - **`double(forKey:)`** returns a double if the key existed, or 0.0 if not.
    - **`object(forKey:)`** returns **`Any?`** so you need to conditionally typecast it to your data type.

    It's **`object(forKey:)`** that will **cause you the most bother, because you get an optional object back**.

    - Use **`as?`** to **optionally typecast your object to the type it should be.**

        using **`as?`** is annoying because you then **have to unwrap the optional or create a default value.**

    - Use **nil coalescing operator**,  **`??`**. This does two things at once:

        **if the object on the left is optional and exists, it gets unwrapped into a non-optional value**; 

        **if it does not exist, it uses the value on the right instead.**

    This means **we can use `object(forKey:)` and `as?` to get an optional object, then use `??` to either unwrap the object or set a default value**, all in one line.

    ```swift
    let array = defaults.object(forKey:"SavedArray") as? [String] ?? [String]()
    let dict = defaults.object(forKey: "SavedDict") as? [String: String] ?? [String: String]()
    ```

    So, if **`SavedArray`** exists and is a string array, it will be placed into the array constant. If it doesn't exist (or if it does exist and isn't a string array), then array gets set to be a new string array.

- **Fixing Project 10: NSCoding**

    You use the **`archivedData()`** method of **`NSKeyedArchiver`**, which **turns an object graph into a `Data` object**, **then write that to `UserDefaults` as if it were any other object**. 

    If you were wondering, “**object graph**” **means** **“your object, plus any objects it refers to, plus any objects those objects refer to, and so on.**”

    The **rules** are very simple:

    1. **All your data types must be one of the following**: boolean, integer, float, double, string, array, dictionary, **`Date`**, or a class that fits rule 2.
    2. If your data type is a **class**, it **must conform** to the **`NSCoding`** **protocol**, which is used for archiving object graphs.
    3. If your data type is an **array** or **dictionary**, **all the keys and values must match rule 1 or rule 2.**

    ```swift
    class Person: NSObject, NSCoding { ... }
    ```

    Working with **`NSCoding`** **requires you to use objects**, **or, in the case of strings, arrays and dictionaries, structs that are interchangeable with objects.** 

    **If we made the Person class into a struct, we couldn't use it with NSCoding.**

    The reason **we inherit from `NSObject` is again because it's required to use `NSCoding`** – **although cunningly Swift won't mention that to you, your app will just crash**.

    **`NSCoding`** protocol **requires** you to implement two methods: a **new initializer and `encode()`.**

    First, you'll be using a new class called **`NSCoder`**. **This is responsible for both encoding (writing) and decoding (reading)** your data so that it can be used with UserDefaults.

    Second, **the new initializer must be declared with the `required` keyword**. 

    This means "**if anyone tries to subclass this class, they are required to implement this method**." 

    An **alternative** to using required **is to declare that your class can never be subclassed**, known as a **`final`** **class**, in which case you don't need required because subclassing isn't possible. 

    ```swift
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
    }
    ```

    The **initializer** **is used when loading objects of this class**, and **`encode()`** is **used when saving**. 

    We’re adding **`as?`** typecasting and **nil coalescing** **just in case we get invalid data back.**

    **You can write `Data` objects to `UserDefaults`, but we don't currently have a `Data` object** – we just have an array.

    The **`archivedData()`** method of **`NSKeyedArchiver`** **turns an object graph into a Data object** using those NSCoding methods we just added to our class. 

    ```swift
    func save() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        }
    }
    ```

    line 1 is what **converts our array into a `Data` object**, then **lines 2 and 3 save that data object to `UserDefaults`**. 

    We **need to load the array back from disk when the app runs**, so add this code to **`viewDidLoad()`**:

    ```swift
    let defaults = UserDefaults.standard

    if let savedPeople = defaults.object(forKey: "people") as? Data {
        if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPeople) as? [Person] {
            people = decodedPeople
        }
    }
    ```

    We use the **`object(forKey:)`** method **to pull out an optional `Data`,** **using `if let` and `as?` to unwrap it.** 

    We then give that to the **`unarchiveTopLevelObjectWithData()`** method of **`NSKeyedUnarchiver`** to **convert it back to an object graph** – i.e., our array of Person objects.