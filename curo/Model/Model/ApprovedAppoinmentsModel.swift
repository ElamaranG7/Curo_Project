//
//  ApprovedAppoinmentsModel.swift
//  curo
//
//  Created by SAIL on 21/03/24.
//

import Foundation
struct ApprovedAppoinmentsModel: Codable {
    let patientID, patientName, date, status: String

    enum CodingKeys: String, CodingKey {
        case patientID = "patient_id"
        case patientName = "patient_name"
        case date, status
    }
}

typealias ApprovedAppoinmentsData = [ApprovedAppoinmentsModel]