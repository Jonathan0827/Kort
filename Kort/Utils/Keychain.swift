//
//  Keychain.swift
//  Kort
//
//  Created by 임준협 on 3/22/25.
//

import Foundation

struct kcdStructure: Codable {
    let vName: String
    let v: String
}

func saveKeychain(_ name: String, _ value: String) {
    let credentials = kcdStructure(vName: name, v: value)
    let a = credentials.vName
    let p = credentials.v.data(using: String.Encoding.utf8)!
    let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                            kSecAttrAccount: a,
                              kSecValueData: p]
    let status = SecItemAdd(query as CFDictionary, nil)
    if status == errSecSuccess {
        print("Saved to Keychain")
    } else if status == errSecDuplicateItem {
        print("Value already exists, using 'updateKeychain' instead")
        updateKeychain(a, p)
    } else {
        print("Failed to save to Keychain: \(status)")
    }
}
func updateKeychain(_ name: String, _ value: Any) {
    let previousQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                    kSecAttrAccount: name]
    let updateQuery: [CFString: Any] = [kSecValueData: value]
    let status = SecItemUpdate(previousQuery as CFDictionary, updateQuery as CFDictionary)
    if status == errSecSuccess {
        print("Keychain value updated")
    } else {
        print("Failed to update Keychain value: \(status)")
    }
}
func readKeychain(_ name: String) -> String{
    let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                            kSecAttrAccount: name,
                       kSecReturnAttributes: true,
                             kSecReturnData: true]
    var item: CFTypeRef?
    if SecItemCopyMatching(query as CFDictionary, &item) != errSecSuccess {
        return ""
    }
    guard let existingItem = item as? [String: Any] else { return "" }
    guard let data = existingItem[kSecValueData as String] as? Data else { return "" }
    guard let toReturn = String(data: data, encoding: .utf8) else { return "" }
    return toReturn
}
func deleteKeychain(_ name: String) {
    let deleteQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                        kSecAttrAccount: name]
    let status = SecItemDelete(deleteQuery as CFDictionary)
    if status == errSecSuccess {
        print("Deleted Keychain value for \(name)")
    } else {
        print("Failed to delete Keychain value for \(name)")
    }
}

func resetKeychain() {
    let secItemClasses = [kSecClassGenericPassword,
        kSecClassInternetPassword,
        kSecClassCertificate,
        kSecClassKey,
        kSecClassIdentity]
    for secItemClass in secItemClasses {
        let dictionary = [kSecClass as String:secItemClass]
        SecItemDelete(dictionary as CFDictionary)
    }
}
