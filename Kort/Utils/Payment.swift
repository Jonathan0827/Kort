import Foundation

struct Card: Equatable {
//    var id = UUID()
    let number: String
    let pwd: String
    let exp: String
    let birth: String
    let name: String
    let available: Bool
    init(number: String = "", pwd: String = "", exp: String = "", birth: String = "", name: String = "", available: Bool = true) {
        self.number = number
        self.pwd = pwd
        self.exp = exp
        self.birth = birth
        self.name = name
        self.available = available
    }
}

// Card management functions
func getCard(_ no: Int) -> Card {
    let number = readKeychain("crdNo\(no)")
    let pwd = readKeychain("crdPwd\(no)")
    let exp = readKeychain("crdExp\(no)")
    let birth = readKeychain("crdBirth\(no)")
    let name = readKeychain("crdNm\(no)")

    if number.isEmpty || pwd.isEmpty || exp.isEmpty || birth.isEmpty || name.isEmpty {
        return Card(available: false)
    }
    return Card(number: number, pwd: pwd, exp: exp, birth: birth, name: name)
}

func getCardAmount() -> Int {
    return Int(readKeychain("crd")) ?? 0
}

func getAllCards(completion: @escaping ([Card]) -> Void) {
    let totalCards = getCardAmount()
    var cards: [Card] = []
    let dispatchGroup = DispatchGroup()
//    if totalCards == 0 {
//        completion(cards)
//        return
//    }
    for i in 0...totalCards {
        dispatchGroup.enter()
        let crd = getCard(i)
        if crd.available {
            cards.append(crd)
        }
        dispatchGroup.leave()
    }

    dispatchGroup.notify(queue: .main) {
        completion(cards)
    }
}

func addCard(_ number: String, _ pwd: String, _ exp: String, _ birth: String, _ name: String) {
    let totalCards = getCardAmount()
    var availableNo: Int? = nil

    for i in 0...totalCards {
        if readKeychain("crdNo\(i)").isEmpty {
            availableNo = i
            break
        }
    }

    let crdNo = availableNo ?? (totalCards + 1)

    if availableNo == nil {
        saveKeychain("crd", "\(crdNo)")
    }

    var success = true

    saveKeychain("crdNo\(crdNo)", number)
    saveKeychain("crdPwd\(crdNo)", pwd)
    saveKeychain("crdExp\(crdNo)", exp)
    saveKeychain("crdBirth\(crdNo)", birth)
    saveKeychain("crdNm\(crdNo)", name)

//    completion(success ? crdNo : nil)
}

func removeCard(_ no: Int) {
    deleteKeychain("crdNo\(no)")
    deleteKeychain("crdPwd\(no)")
    deleteKeychain("crdExp\(no)")
    deleteKeychain("crdBirth\(no)")
    deleteKeychain("crdNm\(no)")

    let totalCards = getCardAmount()
    if totalCards == no {
        saveKeychain("crd", "\(totalCards - 1)")
    }
}

func editCard(_ crdNo: Int, _ number: String, _ pwd: String, _ exp: String, _ birth: String, _ name: String) {
    saveKeychain("crdNo\(crdNo)", number)
    saveKeychain("crdPwd\(crdNo)", pwd)
    saveKeychain("crdExp\(crdNo)", exp)
    saveKeychain("crdBirth\(crdNo)", birth)
    saveKeychain("crdNm\(crdNo)", name)
}
