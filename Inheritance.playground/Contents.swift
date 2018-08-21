import UIKit

class Example {
    var a = 0
    var b: String
    
    init(a: Int) { // Constructor
        self.a = a
        b = "name"                  // An error if a declared property isn't initialized
    }
}

let eg = Example(a: 1)
print(eg.a) 
