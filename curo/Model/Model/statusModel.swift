//
//  statusModel.swift
//  curo
//
//  Created by SAIL on 07/05/24.
//

import Foundation
struct statusModel: Codable {
    let status, message: String
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let patientID, patientName, date, status: String

    enum CodingKeys: String, CodingKey {
        case patientID = "patient_id"
        case patientName = "patient_name"
        case date, status
    }
}



