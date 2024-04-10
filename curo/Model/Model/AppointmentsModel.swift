//
//  AppointmentsModel.swift
//  curo
//
//  Created by SAIL on 22/03/24.
//

import Foundation
struct AppointmentsModel: Codable {
    let status: Bool
    let message: String
    let data: [AppointmentsData]
}

// MARK: - Datum
struct AppointmentsData: Codable {
    let patientID, patientName,status, date: String
    

    enum CodingKeys: String, CodingKey {
        case patientID = "patient_id"
        case patientName = "patient_name"
        case date, status
    }
}
