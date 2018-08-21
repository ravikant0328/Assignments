//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

var str = "Hello, playground"
var string1 = "String attributed Swift"
var attributes = [ NSAttributedStringKey.strikethroughStyle:NSUnderlineStyle.styleThick.rawValue,NSAttributedStringKey.foregroundColor:UIColor.green , NSAttributedStringKey.backgroundColor: UIColor.yellow , NSAttributedStringKey.font: UIFont(name: "Chalkduster", size: 18.0)! , NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue  ] as [NSAttributedStringKey : Any]
var atrributedString = NSMutableAttributedString(string: string1 , attributes: attributes)
print(atrributedString)


let arrayOfInt = [2,3,4,5,4,7,2]
var newArr: [Int] = []
for value in arrayOfInt { newArr.append(value*10) }
print(newArr)

let newArrUsingMap = arrayOfInt.map { $0 * 10 }

let numbers = [1,2,3,4]
let numbersum = numbers.reduce(0, {x , y in
    x + y
})

let reducedNumberSum = numbers.reduce(0) { $0 + $1 }
print(reducedNumberSum)



var stringDictionary: Dictionary = [String: String]()
stringDictionary["swift"] = "Swift is a great language"
stringDictionary["python"] = "Python is a great tool"
stringDictionary["cpp"] = "C++ is the best language"
print(stringDictionary["python"] ?? "No subscript found: 🙁")

var integerDictionaryLiteral: Dictionary = [
    45: "Swift Article",
    56: "Python Article",
    71: "C++ Article"
]
print(integerDictionaryLiteral[71] ?? "No subscript found: 🙁")

let dupKeys = [("one", 1), ("one", 2), ("two", 2), ("three", 3), ("four", 4), ("five", 5)]
let nonDupDict = Dictionary(dupKeys, uniquingKeysWith: { (first, _) in first })
print(nonDupDict)

let evenKeys = ["two", "four", "six", "eight", "ten"]
var sequence = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
sequence = sequence.filter { $0 % 2 == 0 }
let evenDict = Dictionary(uniqueKeysWithValues: zip(evenKeys, sequence))
print(evenDict)


integerDictionaryLiteral[56] = "Python 3.6 Article"
print(integerDictionaryLiteral[56] ?? "No subscript found: 🙁")


if let updatedValue = integerDictionaryLiteral.updateValue("Python 3.7 is not out yet", forKey: 56) {
    print(updatedValue)
    print(integerDictionaryLiteral[56] ?? "No subscript found: 🙁")
}


if let removedPythonValue = stringDictionary.removeValue(forKey: "python") {
    print(removedPythonValue)
    print(stringDictionary["python"] ?? "No subscript found: 🙁")
}

var existing = ["one": 2, "two": 2, "three": 6]
let newData = [("one", 3), ("two", 1), ("three", 3), ("four", 4), ("five", 5)]
existing.merge(newData) { (current, _) in current }
print(existing)


let people = ["Matt", "Rich", "Mary", "Mike", "Karin", "Phil", "Edward", "Ken"]
let groupedNameDictionary = Dictionary(grouping: people, by: { $0.first! })
print(groupedNameDictionary)

let groupedLengthDictionary = Dictionary(grouping: people) { $0.utf16.count }
print(groupedLengthDictionary)


let array1 = [5,6,7]
let array1map = array1.map{ $0 * 20 }
print ( array1map )

let array1reduce = array1.reduce(1, { x , y in x * y } )
print(array1reduce)

var set1 : Set =  [1,4,2,3]
var set2 : Set =  [2,3,4]
print ( set1.union(set2) )
print ( set1.intersection(set2))
print ( set1.symmetricDifference(set2))

atrributedString.removeAttribute(NSAttributedStringKey.strikethroughStyle, range: NSMakeRange(0, atrributedString.length/2))
var string2 = NSAttributedString(string:"4")
atrributedString.insert(string2, at: 5)

