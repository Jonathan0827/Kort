//
//  KorailLogin.swift
//  Kort
//
//  Created by 임준협 on 12/9/24.
//

// MARK: Related to Korail Log In/Out Functions

// How to Log In
// 1. Get korail member no. and password
// 2. Get AES IV and Key from Korail server (This is what pwdEncoder() does).
// 3. Encrypt password (pwdEncoder() does this too. AES and b64 twice).
// 4. Login using the encrypted password (login() does this).

import Foundation
import Alamofire
import CryptoSwift
import AlertToast
import SwiftUI

var UD = CurrentUserData()

func pwdEncoder(_ pwdData: String, completion: @escaping (KorailPwdPrms) -> Void) {
    SD.session.request(apiPath("common.code.do"), method: .post, parameters: ["code": "app.login.cphd"])
        .responseDecodable(of: KorailEncPwdResponse.self) { response in
            switch response.result {
            case .success(let result):
                let encPwd = AES(data: pwdData, key: result.appLoginCphd.key, iv: String(result.appLoginCphd.key.prefix(16))).encrypt()
                completion(KorailPwdPrms(password: encPwd, idx: result.appLoginCphd.idx))
            case .failure(let error):
                print("Couldn't fetch AES data: \(error.localizedDescription)")
            }
        }
}
func KorailLogin(_ loginData: KorailLoginParameters = KorailLoginParameters(korailID: korailMBNo(), korailPwd: korailPwd()), completion: @escaping (KorailLoginResponse) -> Void) {
    pwdEncoder(loginData.korailPwd) { enc in
        let encPwd = enc.password
        let idx = enc.idx
        let korailID = loginData.korailID
        let postParams = [
            "Device": "AD",
            "Version": version,
            "txtInputFlg": "2",
            "txtMemberNo": korailID,
            "txtPwd": encPwd,
            "idx": idx
        ]
        SD.session.request(apiPath("login.Login"), method: .post, parameters: postParams)
            .responseDecodable(of: KorailLoginResp.self) { r in
            switch r.result{
            case .success(let value):
                print("Logged In!")
                UD.key = value.key
                completion(KorailLoginResponse(state: true, message: value.hMsgTxt, value: value))
            case .failure(let error):
                print("Error while logging in: \(error.localizedDescription)")
                debugPrint(r)
                completion(KorailLoginResponse(state: false, message: "Login Failed", value: nil))
            }
        }
        
    }
}
func KorailLogout() {
    SD.session.request(apiPath("common.logout"), method: .get)
        .response {
            debugPrint($0)
        }
}
