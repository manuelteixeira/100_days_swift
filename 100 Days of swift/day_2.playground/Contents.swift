import UIKit

// Arrays
let john = "John Lennon"
let paul = "Paul McCartney"
let george = "George Harrison"
let ringo = "Ringo Starr"

let beatles = [john, paul, george, ringo]
beatles[1]


// Sets
let colors = Set(["red", "green", "blue"])
let colores2 = Set(["red", "green", "blue", "red"])


// Tuples
var name = (first: "Taylor", last: "Swift")
name.0
name.first
//name = (first: "Justin", age: 25)

// Arrays vs Sets vs Tuples
let address = (house: 555, street: "Taylor Swift Avenue", city: "Nashville")
let set = Set(["aardvark", "astonaut", "azalea"])
let pythons = ["Eric", "Graham", "John"]

// Dictionaries
let heights = [
    "Taylor swift": 1.78,
    "Ed Sheeran": 1.73
]

heights["Taylor swift"]

// Dictionary default values
let favoriteIceCream = [
    "Paul": "Chocolate",
    "Sophie": "Vanilla"
]

favoriteIceCream["Paul"]
favoriteIceCream["Charlotte"]
favoriteIceCream["Charlotte", default: "Unknown"]

// Creating empty collections

var teams = [String: String]()
teams["Paul"] = "Red"

var results = [Int]()

var words = Set<String>()
var numbers = Set<Int>()

var scores = Dictionary<String, Int>()
var resultsArray = Array<Int>()

// Enumeration
let result = "failure"
let result2 = "failed"
let result3 = "fail"

enum Result {
    case success
    case failure
}

let result4 = Result.failure

// Enum associated values

enum Activity {
    case bored
    case running(destination: String)
    case talking(topic: String)
    case singing(volume: Int)
}

let talking = Activity.talking(topic: "football")

// Enum raw values

enum Planet: Int {
    case mercury = 1
    case venus
    case earth
    case mars
}

let venus = Planet(rawValue: 2)
