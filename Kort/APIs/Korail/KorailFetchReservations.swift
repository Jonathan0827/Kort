//
//  KorailFetchReservations.swift
//  Kort
//
//  Created by 임준협 on 12/9/24.
//

import Foundation
import Alamofire

func getTickets() {
    SD.session.request(apiPath("myTicket.MyTicketList"), method: .get, parameters: ["Device": "AD", "Version": "231231001", "Key": UD.key])
        .response {
            debugPrint($0)
        }
       
}
