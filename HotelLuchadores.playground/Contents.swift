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
struct Reservation: Equatable {
    
    var id: String
    let hotelName : String = "Gran Hotel de Isla Papaya"
    var clientList: [Client]
    var duration: Int = 0
    var price: Double = 20.0
    var breakfast: Bool
    
    /// init que implementa id único y genera el precio de la reserva llamando a la función para calcularlo (priceReservation)
    init(clientList: [Client], duration:Int, breakfast: Bool) {
        self.id = "GHIP\(clientList.count)\(clientList[0].name)\(duration)"
        self.duration = duration
        self.breakfast = breakfast
        self.clientList = clientList
        self.price = self.priceReservation()
       
    }

    mutating func priceReservation() -> Double {
        var price = Double(self.price)
        let clients = Double(self.clientList.count)
        let duration = Double(self.duration)
        if breakfast == true {
            price = price * 1.25
        }
        let total = price * clients * duration
        return total
    }
    static func == (lhs: Reservation, rhs: Reservation) -> Bool {
        lhs.id == rhs.id
        return true
    }
}

/// Creación de reservas
var gokuReserv = Reservation( clientList: [goku, bulma], duration: 2, breakfast: false)
var vegeReserv = Reservation( clientList: [vegetta], duration: 1, breakfast: true)



// Errores en la reserva

enum reservationError {
    case id
    case repeatClient
    case noReservation
}

// Gestion de reservas del hotel

class HotelReservationManager {
    
    var reservationList: [Reservation] = []
    
    /// Función de agregar reserva
    func makeReservation(reservation: Reservation)  {
        reservationList.append(reservation)
        print("Reserva: \(reservation.id) realizada con exito. Deberá abonar: \(reservation.price) € a su llegada")
    }
    
    func cancelReservation(reservation: Reservation) {
        var position = reservationList.lastIndex(of: reservation)
        reservationList.remove(at: position!)
        print("Reserva: \(reservation.id) eliminada con exito")
    }
    
}

let reception = HotelReservationManager()
reception.makeReservation(reservation: gokuReserv)
reception.makeReservation(reservation: vegeReserv)
reception.cancelReservation(reservation: vegeReserv)

