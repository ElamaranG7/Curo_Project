//
//  DischargeFormUploadModel.swift
//  curo
//
//  Created by SAIL on 01/04/24.
//

import Foundation
struct DischargeFormUploadModel: Codable {
    let status, message: String
    let profilePicPath: [String]

    enum CodingKeys: String, CodingKey {
        case status, message
        case profilePicPath = "profile_pic_path"
    }
}

