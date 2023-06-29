import UIKit
import Foundation

// Clientes
struct Client {
    let name: String
    var Age: Int
    var height: Float
}
///creación de clientes
var goku = Client(name: "Goku", Age: 40, height: 1.75)
var vegetta = Client(name: "Vegeta", Age: 46, height: 1.64)
var bulma = Client(name: "Bulma", Age: 28, height: 1.65)


// Reserva
struct Reservation {
    
    //let id: String = "pagoku"
    let hotelName : String = "Gran Hotel de Isla Papaya"
    var clientList: [Client]
    var duration: Int
    var price: Int = 50
    var breakfast: Bool
    
    func priceReservation() -> Int {
        var price = self.price
        var clients = self.clientList.count
        if breakfast == true {
            price += 15
        }
        var total = price * clients * duration
        return total
        
    }
}

var r2d2 = Reservation(clientList: [goku, bulma], duration: 2, breakfast: false)
r2d2.priceReservation()

