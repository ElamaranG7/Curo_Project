//
//  DischargeFormUploadModel.swift
//  curo
//
//  Created by SAIL on 01/04/24.
//

import Foundation

struct DischargeFormUploadModel: Codable {
    let success: Bool
    let profilePicPath: String

    enum CodingKeys: String, CodingKey {
        case success
        case profilePicPath = "profile_pic_path"
    }
}
