import UIKit
import Foundation

// Clientes
struct Client {
    let name: String
    var Age: Int
    var height: Double
}
///creación de clientes
var goku = Client(name: "Goku", Age: 40, height: 1.75)
var vegetta = Client(name: "Vegeta", Age: 46, height: 1.64)
var bulma = Client(name: "Bulma", Age: 28, height: 1.65)


// Reserva
struct Reservation {
    
    var id: String = "GHIP"
    let hotelName : String = "Gran Hotel de Isla Papaya"
    var clientList: [Client]
    var duration: Int = 0
    var price: Int = 50
    var breakfast: Bool
    
    init( clientList: [Client], duration:Int, breakfast: Bool) {
        //self.id = id
        //self.hotelName = hotelName
        self.duration = duration
        //self.price = price
        self.breakfast = breakfast
        self.clientList = clientList
    }
    
    func priceReservation() -> Int {
        var price = self.price
        let clients = self.clientList.count
        if breakfast == true {
            price += 15
        }
        let total = price * clients * duration
        return total
    }
}

/// Creación de reservas
var gokuReserv = Reservation(clientList: [goku, bulma], duration: 2, breakfast: false)
var vegeReserv = Reservation(clientList: [vegetta], duration: 1, breakfast: true)



// Errores en la reserva

enum reservationError {
    case id
    case repeatClient
    case noReservation
}

// Gestion de reservas del hotel

class HotelReservationManager {
    
    var reservationList: [Reservation] = []
    
    func makeReservation(reservation: Reservation)  {
        reservationList.append(reservation)
    }
    
}

let reception = HotelReservationManager()
reception.makeReservation(reservation: gokuReserv)
reception.makeReservation(reservation: vegeReserv)

print(reception.reservationList)
