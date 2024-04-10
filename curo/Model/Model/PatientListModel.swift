//
//  PatientListModel.swift
//  curo
//
//  Created by SAIL on 14/03/24.
//

import Foundation

struct PatientListModel: Codable {
    let status: String
    let data: [PatientListData]
}

// MARK: - Datum
struct PatientListData: Codable {
    let patientID: String?
    let patientName: String
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case patientID = "patient_id"
        case patientName = "patient_name"
        case profileImage = "profile_image"
    }
}
