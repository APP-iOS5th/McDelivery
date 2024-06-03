//
//  CurrencyModel.swift
//  McCurrency
//
//  Created by 임재현 on 6/3/24.
//

import Foundation

struct ExchangeRate: Codable {
    let result: Int
    let cur_unit: String
    let ttb: String
    let tts: String
    let deal_bas_r: String
    let bkpr: String
    let yy_efee_r: String
    let ten_dd_efee_r: String
    let kftc_bkpr: String
    let kftc_deal_bas_r: String
    let cur_nm: String
}
