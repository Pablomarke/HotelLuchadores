import Foundation

// MARK: Clientes
struct Client: Equatable {
    let name: String
    let Age: Int
    let height: Int
    
    static func == (lhs: Client, rhs: Client) -> Bool {
        lhs.name == rhs.name && lhs.Age == rhs.Age && lhs.height == rhs.height
    }
}

// MARK: Reserva
struct Reservation: Equatable {
    
    let clientList: [Client]
    let duration: Int
    let breakfast: Bool
    
    var price: Double = 20
    var id: String = ""
    var hotelName : String = ""
    
    static func == (lhs: Reservation, rhs: Reservation) -> Bool {
        lhs.id == rhs.id
        
    }
}

// MARK: Control de errores en la reserva
enum ReservationError: Error {
    case sameIdReservation
    case repeatClient
    case noReservation
}

// MARK: Gestión de reservas del hotel
class HotelReservationManager {
    
    var reservationList: [Reservation] = []
    
    /// Función de agregar reserva con ID único, precio actualizado y nombre del hotel
    func makeReservation(reservation: Reservation) {
        var reservationUsed = reservation
        
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
            for position in reservationList{
                if position.id == reservationid{
                    reservationList.remove(at: reservationList.lastIndex(of: position)!)
                    print("Reserva \(reservationid) eliminada con exito")
                }
            }
        } catch {
            print("Error :", error)
        }
    }
    
    /// Función de calcular precio de la reserva
    func priceReservation(reservation: Reservation) -> Double {
        var price = reservation.price
        let clients = Double(reservation.clientList.count)
        let duration = Double(reservation.duration)
        let breakfast = reservation.breakfast
        if breakfast {
            price = price * 1.25
        }
        let total = price * clients * duration
        return total
    }
    
    
    // ERRORES:
    
    /// Función Comprobar id repetido
    func validateId(id: String) throws {
        for i in reservationList {
            if id == i.id {
                throw ReservationError.sameIdReservation
            }
        }
    }
    
    /// Función comprobar si el cliente existe
    func validateClients(clients: [Client]) throws {
        for client in clients{
            for reservation in reservationList{
                if reservation.clientList.contains(client){
                    throw ReservationError.repeatClient
                }
            }
        }
    }
    
    ///Función comprobar id existe
    func noExistId(id:String) throws {
        var count:[String] = []
        for ids in reservationList{
            if ids.id.contains(id){
                count.append(ids.id)
            }
        }
        if count.isEmpty {
            throw ReservationError.noReservation
        }
        return
    }
}

// MARK: Tests y creación de objetos de ejemplo
/// Creación de clientes
let goku = Client(name: "Goku", Age: 40, height: 175)
let vegetta = Client(name: "Vegeta", Age: 46, height: 164)
let bulma = Client(name: "Bulma", Age: 28, height: 165)

/// Creación de reservas
let gokuReserv = Reservation( clientList: [goku, bulma], duration: 2, breakfast: false)
let vegeReserv = Reservation( clientList: [vegetta], duration: 1, breakfast: true)

/// Creación de reservas mal realizadas
let gokuReserv2 = Reservation( clientList: [goku, vegetta], duration: 2, breakfast: false) // repetición de id y clientes
let gokuReserv3 = Reservation( clientList: [goku, vegetta], duration: 3, breakfast: false) // por cliente

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


