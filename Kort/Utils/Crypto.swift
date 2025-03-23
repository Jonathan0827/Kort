//
//  Crypto.swift
//  Kort
//
//  Created by 임준협 on 3/22/25.
//

import Foundation
import CryptoKit
import LocalAuthentication
import CryptoSwift
class AES {
    var dataB: [UInt8]
    var keyB: [UInt8]
    var ivB: [UInt8]
    var aes: CryptoSwift.AES
    init(data: String, key: String, iv: String) {
        self.dataB = Data(data.utf8).bytes
        self.keyB = Data(key.utf8).bytes
        self.ivB = Data(iv.utf8).bytes
        self.aes = try! CryptoSwift.AES(key: keyB, blockMode: CBC(iv: ivB), padding: .pkcs7)
    }
    func encrypt() -> String {
        do {
            let encrypted = try self.aes.encrypt(dataB).toBase64()
            let encryptedData = encrypted.data(using: .utf8)!
            let base64String = encryptedData.base64EncodedString()
            return base64String
        } catch {
            return ""
        }
    }
    func decrypt() throws -> String {
        let decrypted = try self.aes.decrypt(dataB)
        let decryptedData = Data(bytes: decrypted, count: decrypted.count)
        guard let decryptedString = String(data: decryptedData, encoding: .utf8) else {
            return ""
        }
        
        return decryptedString
    }
}
