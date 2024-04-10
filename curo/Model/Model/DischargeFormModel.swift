//
//  DischargeFormModel.swift
//  curo
//
//  Created by SAIL on 19/03/24.
//

import Foundation
struct DischargeFormModel: Codable {
    let status: String
    let profilePicPath: [String]

    enum CodingKeys: String, CodingKey {
        case status
        case profilePicPath = "profile_pic_path"
    }
}
