//
//  RejectedAppoinmentsModel.swift
//  curo
//
//  Created by SAIL on 21/03/24.
//

import Foundation
struct RejectedAppoinmentsModel: Codable {
    let patientID, patientName, date: String
    let status: Status

    enum CodingKeys: String, CodingKey {
        case patientID = "patient_id"
        case patientName = "patient_name"
        case date, status
    }
}

enum Status: String, Codable {
    case rejected = "rejected"
}

typealias RejectedAppoinmentsData = [RejectedAppoinmentsModel]

