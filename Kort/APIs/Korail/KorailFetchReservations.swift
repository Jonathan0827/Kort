//
//  KorailFetchReservations.swift
//  Kort
//
//  Created by 임준협 on 12/9/24.
//

import Foundation
import Alamofire

func getTickets() {
    SD.session.request(apiPath("myTicket.MyTicketList"), method: .get, parameters: ["Device": "AD", "Version": version, "Key": UD.key])
        .response {
            debugPrint($0)
        }
       
}
func getReservations() {
    SD.session.request(apiPath("reservation.ReservationView"), method: .get, parameters: ["Device": "AD", "Version": version, "Key": UD.key])
        .response {
            debugPrint($0)
        }
       
}
