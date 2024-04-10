//
//  PatientListModel.swift
//  RemainderApp
//
//  Created by SAIL on 13/03/24.
//

import Foundation

struct PatientListModel: Codable {
    let status: String
    let data: [PatientListData]
}

// MARK: - Datum
struct PatientListData: Codable {
    let hospitalID, name, profileImage: String

    enum CodingKeys: String, CodingKey {
        case hospitalID = "hospital_id"
        case name
        case profileImage = "profile_image"
    }
}
