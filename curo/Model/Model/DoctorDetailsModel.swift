//
//  DoctorDetailsModel.swift
//  curo
//
//  Created by SAIL on 19/03/24.
//

import Foundation
struct DoctorDetailsModel: Codable {
    let userID, name, gender, specialization: String
    let contactNo: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case name, gender, specialization
        case contactNo = "contact_no"
    }
}
