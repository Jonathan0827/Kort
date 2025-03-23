//
//  KorailPayInApp.swift
//  Kort
//
//  Created by 임준협 on 3/22/25.
//

import Foundation
import Alamofire

func KorailPayInApp(_ train: KorailReservationResponse, payment: Card, completion: @escaping (KorailPaymentResult) -> Void) {
    let param = [
        "Device": "AD",
        "Version": version,
        "Key": UD.key,
        "hidPnrNo": train.hPnrNo,
        "hidWctNo": train.hWctNo,
        "hidTmpJobSqno1": "000000",
        "hidTmpJobSqno2": "000000",
        "hidRsvChgNo": "000",
        "hidInrecmnsGridcnt": "1",
        "hidStlMnsSqno1": "1",
        "hidStlMnsCd1": "02",
        "hidMnsStlAmt1": train.hTotRcvdAmt,
        "hidCrdInpWayCd1": "@",
        "hidStlCrCrdNo1": payment.number,
        "hidVanPwd1": payment.pwd,
        "hidCrdVlidTrm1": payment.exp,
        "hidIsmtMnthNum1": 0,
        "hidAthnDvCd1": payment.birth.count == 6 ? "J" : "S",
        "hidAthnVal1": payment.birth,
        "hiduserYn": "Y"
    ] as [String : Any]
    SD.session.request(apiPath("payment.ReservationPayment"), method: .post, parameters: param)
        .responseDecodable(of: KorailPaymentResponse.self) {r in
            switch r.result{
            case .success(let value):
                print(value)
                completion(KorailPaymentResult(result: value.strResult == "SUCC", msg: value.hMsgTxt, res: value))
            case .failure(let error):
                print("Error while payment: \(error.localizedDescription)")
                debugPrint(r)
                completion(KorailPaymentResult(result: false, msg: "결제에 실패했습니다", res: nil))
            }
        }
}



