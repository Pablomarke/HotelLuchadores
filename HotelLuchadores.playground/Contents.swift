import UIKit


struct Client {
    let name: String
    var Age: Int
    var height: Float
}

var goku = Client(name: "Goku", Age: 40, height: 1.75)
var vegetta = Client(name: "Vegeta", Age: 46, height: 1.64)

print(goku.Age)
