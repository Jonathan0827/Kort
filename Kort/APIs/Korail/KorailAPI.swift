//
//  KorailApi.swift
//  Kort
//
//  Created by 임준협 on 12/9/24.
//

// MARK: Other Korail API Functions

import Foundation
import Alamofire

func apiPath(_ subClass: String) -> String {
    return "https://smart.letskorail.com:443/classes/com.korail.mobile.\(subClass)"
}

struct SessionData {
    let configuration: URLSessionConfiguration
    let session: Session
    init (configuration: URLSessionConfiguration = URLSessionConfiguration.af.default) {
        self.configuration = configuration
        configuration.headers = ["User-Agent": "Dalvik/2.1.0 (Linux; U; Android 5.1.1; Nexus 4 Build/LMY48T)"]
        self.session = Session(configuration: configuration)
    }
}
var SD = SessionData()

