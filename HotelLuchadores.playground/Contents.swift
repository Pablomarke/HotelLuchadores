import Foundation

// MARK: Clientes
struct Client: Equatable {
    var name: String
    var Age: Int
    var height: Double
    
    static func == (lhs: Client, rhs: Client) -> Bool {
        lhs.name == rhs.name && lhs.Age == rhs.Age && lhs.height == rhs.height
    }
}

// MARK: Reserva
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

// MARK: Control de errores en la reserva
enum reservationError: Error {
    case id
    case repeatClient
    case noReservation
}

// MARK: Gestión de reservas del hotel
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
        
        do {
            try validateId(id: reservationUsed.id)
            try validateClients(clients: reservationUsed.clientList)
            reservationList.append(reservationUsed)
            print("Reserva: \(reservationUsed.id) realizada con exito. \nDeberá abonar: \(reservationUsed.price) € a su llegada")
            
        } catch {
            print("Error:", error)
        }
    }
    
    /// Función para cancelar reserva
    func cancelReservation(reservationid: String) {
        do{
            try noExistId(id: reservationid)
            for i in reservationList{
                if i.id == reservationid{
                    reservationList.remove(at: reservationList.lastIndex(of: i)!)
                    print("Reserva \(reservationid) eliminada con exito")
                }
            }
        } catch {
            print("Error :", error)
        }
    }
    
    /// Función de calcular precio de la reserva
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
    
    
    // ERROR:
    
    /// Función Comprobar id repetido
    func validateId(id: String) throws {
        for i in reservationList {
            if id == i.id {
                throw reservationError.id
            }
        }
    }
    
    /// Función comprobar si el cliente existe
    func validateClients(clients: [Client]) throws {
        for c in clients{
            for i in reservationList{
                if i.clientList.contains(c){
                    throw reservationError.repeatClient
                }
            }
        }
    }
    
    ///Función comprobar id existe
    func noExistId(id:String) throws {
        var count = 0
        for i in reservationList{
            if i.id.contains(id){
                count += 1
            }
        }
        if count >= 1 {
            return
        } else {
            throw reservationError.noReservation
        }
    }
}

// MARK: Tests y creación de objetos de ejemplo
/// Creación de clientes
var goku = Client(name: "Goku", Age: 40, height: 1.75)
var vegetta = Client(name: "Vegeta", Age: 46, height: 1.64)
var bulma = Client(name: "Bulma", Age: 28, height: 1.65)

/// Creación de reservas
var gokuReserv = Reservation( clientList: [goku, bulma], duration: 2, breakfast: false)
var vegeReserv = Reservation( clientList: [vegetta], duration: 1, breakfast: true)

/// Creación de reservas mal realizadas
var gokuReserv2 = Reservation( clientList: [goku, vegetta], duration: 2, breakfast: false) // repetición de id y clientes
var gokuReserv3 = Reservation( clientList: [goku, vegetta], duration: 3, breakfast: false) // por cliente

// Tests
class HotelTests {
    
    func testAddReservation(){
        let receptionTest1 = HotelReservationManager()

        receptionTest1.makeReservation(reservation: gokuReserv) //reserva bien
        receptionTest1.makeReservation(reservation: gokuReserv2) //reserva duplicados Id y clientes
        assert(receptionTest1.reservationList.count == 1) //1
        receptionTest1.makeReservation(reservation: gokuReserv3) //reserva duplicados Id y clientes
        assert(receptionTest1.reservationList.count == 1) //1
        receptionTest1.makeReservation(reservation: vegeReserv) //reserva bien
        assert(receptionTest1.reservationList.count == 2)//2
    }
    
    func testCancelReservation(){
        let receptionTest2 = HotelReservationManager()
        receptionTest2.makeReservation(reservation: vegeReserv) //reserva bien
        assert(receptionTest2.reservationList.count == 1)//1
        receptionTest2.cancelReservation(reservationid: "GHIVegeta") // no id
        assert(receptionTest2.reservationList.count == 1)
        receptionTest2.cancelReservation(reservationid: "GHIP1Vegeta1")//borrado
        assert(receptionTest2.reservationList.count == 0) //0
        
    }
    
    func testReservationPrice(){
        let receptionTest3 = HotelReservationManager()
        assert(receptionTest3.priceReservation(reservation: gokuReserv) == 80.0)
    }
}

let goodExercise = HotelTests()
goodExercise.testAddReservation()
goodExercise.testCancelReservation()
goodExercise.testReservationPrice()


