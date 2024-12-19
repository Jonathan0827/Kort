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

struct CurrentUserData {
    var key = ""
    var idx = ""
}
var UD = CurrentUserData()

func pwdEncoder(_ pwdData: String, completion: @escaping (KorailPwdPrms) -> Void) {
    SD.session.request(apiPath("common.code.do"), method: .post, parameters: ["code": "app.login.cphd"])
        .responseDecodable(of: KorailEncPwdResponse.self) { response in
                switch response.result {
                case .success(let result):
                    do {
                        let exPwd = Array(pwdData.utf8)
                        let idx = result.appLoginCphd.idx
                        let key = Array(result.appLoginCphd.key.utf8)
                        let iv = Array(String(result.appLoginCphd.key.prefix(16)).utf8)
                        let aes = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7)
                        let encPwd = try aes.encrypt(exPwd).toBase64().data(using: .utf8)?.base64EncodedString()
                        completion(KorailPwdPrms(password: encPwd ?? "", idx: idx))
                    } catch {
                        print("Couldn't encrypt password: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    print("Couldn't fetch AES data: \(error.localizedDescription)")
                }
            }
    }
func login(_ loginData: KorailLoginParameters, completion: @escaping (KorailLoginResponse) -> Void) {
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
func logout() {
    SD.session.request(apiPath("common.logout"), method: .get)
        .response {
            debugPrint($0)
        }
}
struct KorailPwdPrms {
    let password: String
    let idx: String
}
struct KorailLoginParameters {
    let korailID: String
    let korailPwd: String
}
