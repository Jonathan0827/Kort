//
//  ApiResponses.swift
//  Kort
//
//  MARK: Thx to https://app.quicktype.io
//

import Foundation
// MARK: common.code.do: Password Encryptions
struct KorailEncPwdResponse: Codable {
    let loginFlg: String
    let appLoginCphd: AppLoginCphd
    let strResult, hMsgCD, hMsgTxt: String

    enum CodingKeys: String, CodingKey {
        case loginFlg
        case appLoginCphd = "app.login.cphd"
        case strResult
        case hMsgCD = "h_msg_cd"
        case hMsgTxt = "h_msg_txt"
    }
}
struct AppLoginCphd: Codable {
    let pwdAESCphd, idx, key: String
}
// MARK: login.Login: Login
struct KorailLoginResponse: Codable {
    let strDiscCrdReisuFlg, strGoffStnCD, strAthnFlg2, key: String
    let strAbrdStnNm, strYouthAgrFlg, strAthnFlg5, strCustClCD: String
    let hMsgTxt, strAbrdStnCD, coupClsFlg, strPrsCnqeMsgCD: String
    let strAthnFlg, strDiscCouponFlg, strEvtTgtFlg, strMBCrdNo: String
    let strCustMgSrtCD, dlayDscpInfo, strGoffStnNm, strCpNo: String
    let strCustLeadFlgNm, strCustDvCD, notiTpCD, strLognTpCd1: String
    let strCustNo, strSexDvCD, encryptHMBCrdNo, strLognTpCd3: String
    let strHdcpTpCD, strLognTpCd2, hMsgCD, strLognTpCd5: String
    let strLognTpCd4, strCustNm, strLognTpCd6, strResult: String
    let strHdcpTpCDNm, strCustID, strEmailAdr, strHdcpFlg: String
    let strCustSrtCD, strSubtDCSClCD, encryptMBCrdNo, strAthnFlg7: String
    let encryptCustNo, strBtdt, strCustLeadFlg: String

    enum CodingKeys: String, CodingKey {
        case strDiscCrdReisuFlg
        case strGoffStnCD = "strGoffStnCd"
        case strAthnFlg2
        case key = "Key"
        case strAbrdStnNm, strYouthAgrFlg, strAthnFlg5
        case strCustClCD = "strCustClCd"
        case hMsgTxt = "h_msg_txt"
        case strAbrdStnCD = "strAbrdStnCd"
        case coupClsFlg
        case strPrsCnqeMsgCD = "strPrsCnqeMsgCd"
        case strAthnFlg, strDiscCouponFlg, strEvtTgtFlg
        case strMBCrdNo = "strMbCrdNo"
        case strCustMgSrtCD = "strCustMgSrtCd"
        case dlayDscpInfo, strGoffStnNm, strCpNo, strCustLeadFlgNm
        case strCustDvCD = "strCustDvCd"
        case notiTpCD = "notiTpCd"
        case strLognTpCd1, strCustNo
        case strSexDvCD = "strSexDvCd"
        case encryptHMBCrdNo = "encryptHMbCrdNo"
        case strLognTpCd3
        case strHdcpTpCD = "strHdcpTpCd"
        case strLognTpCd2
        case hMsgCD = "h_msg_cd"
        case strLognTpCd5, strLognTpCd4, strCustNm, strLognTpCd6, strResult
        case strHdcpTpCDNm = "strHdcpTpCdNm"
        case strCustID = "strCustId"
        case strEmailAdr, strHdcpFlg
        case strCustSrtCD = "strCustSrtCd"
        case strSubtDCSClCD = "strSubtDcsClCd"
        case encryptMBCrdNo = "encryptMbCrdNo"
        case strAthnFlg7, encryptCustNo, strBtdt, strCustLeadFlg
    }
}

struct SearchKorailTrainResponse: Codable {
    let hMsgCD, hMsgTxt, hMenuID, hSeatCntFirst: String
    let hSeatCntSecond, hRsltCnt, hNextPGFlg: String
    let hQryStNoNext, hTrnNoNext: JSONNull?
    let strJobID, hAgreeTxt, hGdNo, txtGoHourFirst: String
    let trnInfos: TrnInfos
    let hNoticeMsg, strResult: String

    enum CodingKeys: String, CodingKey {
        case hMsgCD = "h_msg_cd"
        case hMsgTxt = "h_msg_txt"
        case hMenuID = "h_menu_id"
        case hSeatCntFirst = "h_seat_cnt_first"
        case hSeatCntSecond = "h_seat_cnt_second"
        case hRsltCnt = "h_rslt_cnt"
        case hNextPGFlg = "h_next_pg_flg"
        case hQryStNoNext = "h_qry_st_no_next"
        case hTrnNoNext = "h_trn_no_next"
        case strJobID = "strJobId"
        case hAgreeTxt = "h_agree_txt"
        case hGdNo = "h_gd_no"
        case txtGoHourFirst = "txtGoHour_first"
        case trnInfos = "trn_infos"
        case hNoticeMsg = "h_notice_msg"
        case strResult
    }
}

// MARK: - TrnInfos
struct TrnInfos: Codable {
    let trnInfo: [[String: String?]]

    enum CodingKeys: String, CodingKey {
        case trnInfo = "trn_info"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
    }

    public var hashValue: Int {
            return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}
