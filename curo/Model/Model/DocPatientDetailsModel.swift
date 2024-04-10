//
//  DocPatientDetailsModel.swift
//  curo
//
//  Created by SAIL on 18/03/24.
//

import Foundation

struct DocPatientDetailsModel: Codable {
    let success: Bool
    let message: String
    let patientData: PatientDetailsData

    enum CodingKeys: String, CodingKey {
        case success, message
        case patientData = "patient_data"
    }
}

// MARK: - PatientData
struct PatientDetailsData: Codable {
    let patientID, patientName, age, gender: String
    let mobileno, diagnosis, profileImage: String

    enum CodingKeys: String, CodingKey {
        case patientID = "patient_id"
        case patientName = "patient_name"
        case age, gender, mobileno, diagnosis
        case profileImage = "profile_image"
    }
}

