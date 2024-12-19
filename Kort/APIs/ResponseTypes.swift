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
struct KorailLoginResp: Codable {
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
struct KorailLoginResponse {
    let state: Bool
    let message: String
    let value: KorailLoginResp?
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

// MARK: certification.TicketReservation: Ticket Reservation
struct KorailReservationResponse: Codable {
    let hAcntApvNo, hNtisuLmtDt, hPsgCnt, hMsgTxt: String
    let psgDiscAddInfos: PsgDiscAddInfos
    let hPayCnt, hPnrNo, hWctNo, hSeatAttDiscFlg: String
    let hPreStlTgtFlg, hDlayApvFlg, hTmpJobSqno1, hPayLimitMsg: String
    let hTmpJobSqno2, hNtisuLmtTm: String
    let jrnyInfos: JrnyInfos
    let hJrnyCnt, hLunchboxChgFlg, hMsgCD: String
    let psgInfos: PsgInfos
    let hMsgMndry, hGuide, hAddSrvFlg, strResult: String
    let hTableFlg, hDiscCnt, hDiscCrdReisuFlg, hFmlyInfoCfmFlg: String
    let hMsgTxt2, hMsgTxt3, hDlayApvTxt, hMsgTxt4: String
    let hMsgTxt5, hTotRcvdAmt, hNtisuLmt: String

    enum CodingKeys: String, CodingKey {
        case hAcntApvNo = "h_acnt_apv_no"
        case hNtisuLmtDt = "h_ntisu_lmt_dt"
        case hPsgCnt = "h_psg_cnt"
        case hMsgTxt = "h_msg_txt"
        case psgDiscAddInfos = "psgDiscAdd_infos"
        case hPayCnt = "h_pay_cnt"
        case hPnrNo = "h_pnr_no"
        case hWctNo = "h_wct_no"
        case hSeatAttDiscFlg = "h_seat_att_disc_flg"
        case hPreStlTgtFlg = "h_pre_stl_tgt_flg"
        case hDlayApvFlg = "h_dlay_apv_flg"
        case hTmpJobSqno1 = "h_tmp_job_sqno1"
        case hPayLimitMsg = "h_pay_limit_msg"
        case hTmpJobSqno2 = "h_tmp_job_sqno2"
        case hNtisuLmtTm = "h_ntisu_lmt_tm"
        case jrnyInfos = "jrny_infos"
        case hJrnyCnt = "h_jrny_cnt"
        case hLunchboxChgFlg = "h_lunchbox_chg_flg"
        case hMsgCD = "h_msg_cd"
        case psgInfos = "psg_infos"
        case hMsgMndry = "h_msg_mndry"
        case hGuide = "h_guide"
        case hAddSrvFlg = "h_add_srv_flg"
        case strResult
        case hTableFlg = "h_table_flg"
        case hDiscCnt = "h_disc_cnt"
        case hDiscCrdReisuFlg = "h_disc_crd_reisu_flg"
        case hFmlyInfoCfmFlg = "h_fmly_info_cfm_flg"
        case hMsgTxt2 = "h_msg_txt2"
        case hMsgTxt3 = "h_msg_txt3"
        case hDlayApvTxt = "h_dlay_apv_txt"
        case hMsgTxt4 = "h_msg_txt4"
        case hMsgTxt5 = "h_msg_txt5"
        case hTotRcvdAmt = "h_tot_rcvd_amt"
        case hNtisuLmt = "h_ntisu_lmt"
    }
}

// MARK: - JrnyInfos
struct JrnyInfos: Codable {
    let jrnyInfo: [JrnyInfo]

    enum CodingKeys: String, CodingKey {
        case jrnyInfo = "jrny_info"
    }
}

// MARK: - JrnyInfo
struct JrnyInfo: Codable {
    let hJrnyTpCD, hDptDt, lumpStlTgtNo, hArvTm: String
    let hTotSeatCnt: String
    let seatInfos: SeatInfos
    let hTrnClsfCD, hTrnNo, hArvRsStnNm, hDptRsStnCD: String
    let hDptTm, hFresCnt, hSeatCnt, hObFlg: String
    let hTrnGpCD, hDptRsStnNm, hTrnClsfNm, hArvRsStnCD: String
    let hTotStndCnt: String

    enum CodingKeys: String, CodingKey {
        case hJrnyTpCD = "h_jrny_tp_cd"
        case hDptDt = "h_dpt_dt"
        case lumpStlTgtNo
        case hArvTm = "h_arv_tm"
        case hTotSeatCnt = "h_tot_seat_cnt"
        case seatInfos = "seat_infos"
        case hTrnClsfCD = "h_trn_clsf_cd"
        case hTrnNo = "h_trn_no"
        case hArvRsStnNm = "h_arv_rs_stn_nm"
        case hDptRsStnCD = "h_dpt_rs_stn_cd"
        case hDptTm = "h_dpt_tm"
        case hFresCnt = "h_fres_cnt"
        case hSeatCnt = "h_seat_cnt"
        case hObFlg = "h_ob_flg"
        case hTrnGpCD = "h_trn_gp_cd"
        case hDptRsStnNm = "h_dpt_rs_stn_nm"
        case hTrnClsfNm = "h_trn_clsf_nm"
        case hArvRsStnCD = "h_arv_rs_stn_cd"
        case hTotStndCnt = "h_tot_stnd_cnt"
    }
}

// MARK: - SeatInfos
struct SeatInfos: Codable {
    let seatInfo: [SeatInfo]

    enum CodingKeys: String, CodingKey {
        case seatInfo = "seat_info"
    }
}

// MARK: - SeatInfo
struct SeatInfo: Codable {
    let hDcntKndCd1, hFrbsCD, hSeatAttCD2, hEtcSeatAttCD: String
    let hCERTNo, hCERTDvCD, hSeatFare, hTotDiscAmt: String
    let hDcntKndCDNm1, hDcntKndCd1Nm, hDcntKndCDNm2, hDiscCardUseCnt: String
    let hDirSeatAttCD, hDiscCardReCnt, hSmkSeatAttCD, hPsrmClNm: String
    let hDcntKndCd2Nm, hSeatPrc, hDcntKndCd2, hBkclsCD: String
    let hPsrmClCD, hSeatNo, hDcntReldNo, hMoviePsrmFlg: String
    let hContSeatCnt, hLOCSeatAttCD, hRqSeatAttCD, hSGRNm: String
    let hDiscCardKnd, hRcvdAmt, hPsgTpCD, hSrcarNo: String

    enum CodingKeys: String, CodingKey {
        case hDcntKndCd1 = "h_dcnt_knd_cd1"
        case hFrbsCD = "h_frbs_cd"
        case hSeatAttCD2 = "h_seat_att_cd_2"
        case hEtcSeatAttCD = "h_etc_seat_att_cd"
        case hCERTNo = "h_cert_no"
        case hCERTDvCD = "h_cert_dv_cd"
        case hSeatFare = "h_seat_fare"
        case hTotDiscAmt = "h_tot_disc_amt"
        case hDcntKndCDNm1 = "h_dcnt_knd_cd_nm1"
        case hDcntKndCd1Nm = "h_dcnt_knd_cd1_nm"
        case hDcntKndCDNm2 = "h_dcnt_knd_cd_nm2"
        case hDiscCardUseCnt = "h_disc_card_use_cnt"
        case hDirSeatAttCD = "h_dir_seat_att_cd"
        case hDiscCardReCnt = "h_disc_card_re_cnt"
        case hSmkSeatAttCD = "h_smk_seat_att_cd"
        case hPsrmClNm = "h_psrm_cl_nm"
        case hDcntKndCd2Nm = "h_dcnt_knd_cd2_nm"
        case hSeatPrc = "h_seat_prc"
        case hDcntKndCd2 = "h_dcnt_knd_cd2"
        case hBkclsCD = "h_bkcls_cd"
        case hPsrmClCD = "h_psrm_cl_cd"
        case hSeatNo = "h_seat_no"
        case hDcntReldNo = "h_dcnt_reld_no"
        case hMoviePsrmFlg = "h_movie_psrm_flg"
        case hContSeatCnt = "h_cont_seat_cnt"
        case hLOCSeatAttCD = "h_loc_seat_att_cd"
        case hRqSeatAttCD = "h_rq_seat_att_cd"
        case hSGRNm = "h_sgr_nm"
        case hDiscCardKnd = "h_disc_card_knd"
        case hRcvdAmt = "h_rcvd_amt"
        case hPsgTpCD = "h_psg_tp_cd"
        case hSrcarNo = "h_srcar_no"
    }
}

// MARK: - PsgDiscAddInfos
struct PsgDiscAddInfos: Codable {
    let psgDiscAddInfo: [JSONAny]

    enum CodingKeys: String, CodingKey {
        case psgDiscAddInfo = "psgDiscAdd_info"
    }
}

// MARK: - PsgInfos
struct PsgInfos: Codable {
    let psgInfo: [PsgInfo]

    enum CodingKeys: String, CodingKey {
        case psgInfo = "psg_info"
    }
}

// MARK: - PsgInfo
struct PsgInfo: Codable {
    let hDcspNo2, hDcspNo, hDcntKndCD, hPsgInfoPerPrnb: String
    let hPsgTpCD, hDcntKndCd2: String

    enum CodingKeys: String, CodingKey {
        case hDcspNo2 = "h_dcsp_no2"
        case hDcspNo = "h_dcsp_no"
        case hDcntKndCD = "h_dcnt_knd_cd"
        case hPsgInfoPerPrnb = "h_psg_info_per_prnb"
        case hPsgTpCD = "h_psg_tp_cd"
        case hDcntKndCd2 = "h_dcnt_knd_cd2"
    }
}

// MARK: - Encode/decode helpers


class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
            return nil
    }

    required init?(stringValue: String) {
            key = stringValue
    }

    var intValue: Int? {
            return nil
    }

    var stringValue: String {
            return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
            return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
            let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
            return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                    return value
            }
            if let value = try? container.decode(Int64.self) {
                    return value
            }
            if let value = try? container.decode(Double.self) {
                    return value
            }
            if let value = try? container.decode(String.self) {
                    return value
            }
            if container.decodeNil() {
                    return JSONNull()
            }
            throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                    return value
            }
            if let value = try? container.decode(Int64.self) {
                    return value
            }
            if let value = try? container.decode(Double.self) {
                    return value
            }
            if let value = try? container.decode(String.self) {
                    return value
            }
            if let value = try? container.decodeNil() {
                    if value {
                            return JSONNull()
                    }
            }
            if var container = try? container.nestedUnkeyedContainer() {
                    return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
                    return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
            if let value = try? container.decode(Bool.self, forKey: key) {
                    return value
            }
            if let value = try? container.decode(Int64.self, forKey: key) {
                    return value
            }
            if let value = try? container.decode(Double.self, forKey: key) {
                    return value
            }
            if let value = try? container.decode(String.self, forKey: key) {
                    return value
            }
            if let value = try? container.decodeNil(forKey: key) {
                    if value {
                            return JSONNull()
                    }
            }
            if var container = try? container.nestedUnkeyedContainer(forKey: key) {
                    return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
                    return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
            var arr: [Any] = []
            while !container.isAtEnd {
                    let value = try decode(from: &container)
                    arr.append(value)
            }
            return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
            var dict = [String: Any]()
            for key in container.allKeys {
                    let value = try decode(from: &container, forKey: key)
                    dict[key.stringValue] = value
            }
            return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
            for value in array {
                    if let value = value as? Bool {
                            try container.encode(value)
                    } else if let value = value as? Int64 {
                            try container.encode(value)
                    } else if let value = value as? Double {
                            try container.encode(value)
                    } else if let value = value as? String {
                            try container.encode(value)
                    } else if value is JSONNull {
                            try container.encodeNil()
                    } else if let value = value as? [Any] {
                            var container = container.nestedUnkeyedContainer()
                            try encode(to: &container, array: value)
                    } else if let value = value as? [String: Any] {
                            var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                            try encode(to: &container, dictionary: value)
                    } else {
                            throw encodingError(forValue: value, codingPath: container.codingPath)
                    }
            }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
            for (key, value) in dictionary {
                    let key = JSONCodingKey(stringValue: key)!
                    if let value = value as? Bool {
                            try container.encode(value, forKey: key)
                    } else if let value = value as? Int64 {
                            try container.encode(value, forKey: key)
                    } else if let value = value as? Double {
                            try container.encode(value, forKey: key)
                    } else if let value = value as? String {
                            try container.encode(value, forKey: key)
                    } else if value is JSONNull {
                            try container.encodeNil(forKey: key)
                    } else if let value = value as? [Any] {
                            var container = container.nestedUnkeyedContainer(forKey: key)
                            try encode(to: &container, array: value)
                    } else if let value = value as? [String: Any] {
                            var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                            try encode(to: &container, dictionary: value)
                    } else {
                            throw encodingError(forValue: value, codingPath: container.codingPath)
                    }
            }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
            if let value = value as? Bool {
                    try container.encode(value)
            } else if let value = value as? Int64 {
                    try container.encode(value)
            } else if let value = value as? Double {
                    try container.encode(value)
            } else if let value = value as? String {
                    try container.encode(value)
            } else if value is JSONNull {
                    try container.encodeNil()
            } else {
                    throw encodingError(forValue: value, codingPath: container.codingPath)
            }
    }

    public required init(from decoder: Decoder) throws {
            if var arrayContainer = try? decoder.unkeyedContainer() {
                    self.value = try JSONAny.decodeArray(from: &arrayContainer)
            } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
                    self.value = try JSONAny.decodeDictionary(from: &container)
            } else {
                    let container = try decoder.singleValueContainer()
                    self.value = try JSONAny.decode(from: container)
            }
    }

    public func encode(to encoder: Encoder) throws {
            if let arr = self.value as? [Any] {
                    var container = encoder.unkeyedContainer()
                    try JSONAny.encode(to: &container, array: arr)
            } else if let dict = self.value as? [String: Any] {
                    var container = encoder.container(keyedBy: JSONCodingKey.self)
                    try JSONAny.encode(to: &container, dictionary: dict)
            } else {
                    var container = encoder.singleValueContainer()
                    try JSONAny.encode(to: &container, value: self.value)
            }
    }
}
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
