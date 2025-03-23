//
//  FileManager.swift
//  Kort
//
//  Created by 임준협 on 3/15/25.
//

import Foundation

let fm = FileManager()
let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
func genURL(_ fName: String) -> URL {
    return URL(fileURLWithPath: fName, relativeTo: doc)
}

func readFile(_ url: URL) -> String {
    var res = ""
    do {
        let d = try Data(contentsOf: url)
        if let str = String(data: d, encoding: .utf8) {
            res = str
        }
    } catch {
        res = ""
    }
    return res
}

func writeFile(_ url: URL, _ data: String) {
    guard let d = data.data(using: .utf8) else {
        print("fail to gen data")
        return
    }
    do {
        try d.write(to: url)
        print("suc: \(url), \(data)")
    } catch {
     print(error.localizedDescription)
    }
}
