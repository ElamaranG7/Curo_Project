//
//  PatientDetailsModel.swift
//  RemainderApp
//
//  Created by SAIL on 13/03/24.
//

import Foundation

// MARK: - Welcome
struct PatientDetailsModel: Codable {
    let status: String
    let patients: [PatientDetailsData]
}

// MARK: - Patient
struct PatientDetailsData: Codable {
    let hospitalID, name, age, gender: String
    let mobileNumber, diagnosis, profileImage: String

    enum CodingKeys: String, CodingKey {
        case hospitalID = "hospital_id"
        case name, age, gender
        case mobileNumber = "mobile_number"
        case diagnosis
        case profileImage = "profile_image"
    }
}
