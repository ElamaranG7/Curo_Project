//
//  ReportsUplodeModel.swift
//  curo
//
//  Created by SAIL on 23/03/24.
//

import Foundation
struct ReportsUplodeModel: Codable {
    let status, message: String
}

typealias ReportsUplodedata = [ReportsUplodeModel]
