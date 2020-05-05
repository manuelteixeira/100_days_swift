import UIKit

// MARK: - Variables -
var str = "Hello, playground"
str = "Goodbye"

// MARK: - Integers -
var age = 38
var population = 8_000_000

// MARK: - Multiline Strings -
var multiLineStr = """
This line
goes to
multiple lines
"""

var multiLineStrWithoutLineBreaks = """
This line \
goes to \
multiple lines
"""

// MARK: - Doubles and Booleans -
var pi = 3.14
var awesome = true

// MARK: - String interpolation -
var score = 85
var strWithScore = "The score is \(score)"
var strWithStr = "The results are: \(strWithScore)"

// MARK: - Constants -
let taylor = "swift"
//taylor = "cant change this constant"

// MARK: - Type annotations -
let withTypeInfered = "This is a string"
let withExplicitType: String = "Reputation"
let year: Int = 1989
let height: Double = 1.78
let taylorRocks: Bool = true

// MARK: - Summary -
//You make variables using var and constants using let. It’s preferable to use constants as often as possible.

//Strings start and end with double quotes, but if you want them to run across multiple lines you should use three sets of double quotes.

//Integers hold whole numbers, doubles hold fractional numbers, and booleans hold true or false.

//String interpolation allows you to create strings from other variables and constants, placing their values inside your string.

//Swift uses type inference to assign each variable or constant a type, but you can provide explicit types if you want.
