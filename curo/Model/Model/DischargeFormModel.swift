//
//  DischargeFormModel.swift
//  curo
//
//  Created by SAIL on 19/03/24.
//

import Foundation
struct DischargeFormModel: Codable {
    let status: String
    let message : String
    let profilePicPath: [String]

    enum CodingKeys: String, CodingKey {
        case status,message
        case profilePicPath = "profile_pic_path"
    }
}
