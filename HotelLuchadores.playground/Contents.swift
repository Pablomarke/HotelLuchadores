import UIKit
import Foundation

// Clientes
struct Client: Equatable {
    var name: String
    var Age: Int
    var height: Double
}

// Reserva
struct Reservation: Equatable {
    
    var clientList: [Client]
    var duration: Int
    var breakfast: Bool
    
    var price: Double = 20
    var id: String = ""
    var hotelName : String = ""
    
    static func == (lhs: Reservation, rhs: Reservation) -> Bool {
        lhs.id == rhs.id
       
    }
}

// Errores en la reserva

enum reservationError {
    case id
    case repeatClient
    case noReservation
}

// Gestion de reservas del hotel

class HotelReservationManager {
    
    var reservationList: [Reservation] = []
    
    /// Función de agregar reserva con ID único, precio actualizado y nombre del hotel
    func makeReservation(reservation: Reservation) {
        var reservationUsed = Reservation(clientList: reservation.clientList,
                                          duration: reservation.duration,
                                          breakfast: reservation.breakfast)
        reservationUsed.id = "GHIP\(reservationUsed.clientList.count)\(reservationUsed.clientList[0].name)\(reservationUsed.duration)"
        reservationUsed.hotelName = "Gran Hotel Isla Papaya"
        reservationUsed.price = priceReservation(reservation: reservation)
        
        if idReservation(reservation: reservationUsed) == true{
            
            reservationList.append(reservationUsed)
            print("Reserva: \(reservationUsed.id) realizada con exito. \nDeberá abonar: \(reservationUsed.price) € a su llegada")
        } else {
            print("Error, no se pudo crear")
        }
    }
    
    /// Función de borrar reserva
    func cancelReservation(Reservationid: String) {
        for i in reservationList{
            if i.id == Reservationid{
                reservationList.remove(at: reservationList.lastIndex(of: i)!)
            }
        }
        //var position = reservationList.lastIndex(of: Reservationid)
        //reservationList.remove(at: position!)
        
    }
    
    /// Función de caluclar precio de la reserva
    func priceReservation(reservation: Reservation) -> Double {
        var price = Double(reservation.price)
        let clients = Double(reservation.clientList.count)
        let duration = Double(reservation.duration)
        let breakfast = reservation.breakfast
        if breakfast == true {
            price = price * 1.25
        }
        let total = price * clients * duration
        return total
    }
        
    /// Función Comprobar id repetido
    func idReservation(reservation: Reservation) -> Bool {
        for i in reservationList {
            if reservation.id == i.id {
                return false
            }
        }
        return true
    }
    

    
}
///creación de clientes
var goku = Client(name: "Goku", Age: 40, height: 1.75)
var vegetta = Client(name: "Vegeta", Age: 46, height: 1.64)
var bulma = Client(name: "Bulma", Age: 28, height: 1.65)

/// Creación de reservas

var gokuReserv = Reservation( clientList: [goku, bulma], duration: 2, breakfast: false)
var vegeReserv = Reservation( clientList: [vegetta], duration: 1, breakfast: true)
  
///creacion reserva mal (por id)
var gokuReserv2 = Reservation( clientList: [goku, vegetta], duration: 2, breakfast: false)

/// Creación pruebas HotelResevation Manager
let reception = HotelReservationManager()

reception.makeReservation(reservation: gokuReserv)
reception.makeReservation(reservation: Reservation(clientList: [bulma], duration: 3, breakfast: true))
reception.makeReservation(reservation: gokuReserv2)
print(reception.reservationList.count)
reception.makeReservation(reservation: vegeReserv)
print(reception.reservationList.count)

reception.cancelReservation(Reservationid: "GHIP1Vegeta1")
print(reception.reservationList.count)

