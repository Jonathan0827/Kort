//
//  Password.swift
//  Kort
//
//  Created by 임준협 on 3/22/25.
//

import Foundation

func saveKorailLogin(_ p: [String]) {
    saveKeychain("KorailMBNo", p[0])
    saveKeychain("KorailPwd", p[1])
}
func korailPwd() -> String {
    return readKeychain("KorailPwd")
}
func korailMBNo() -> String {
    return readKeychain("KorailMBNo")
}
func isKorailLoginEmpty() -> Bool {
    return korailMBNo().isEmpty || korailPwd().isEmpty
}
