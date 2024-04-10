//
//  AddPatientModel.swift
//  curo
//
//  Created by SAIL on 26/03/24.
//

import Foundation

struct AddPatientModel: Codable {
    let status, patientID: String

    enum AddPatientData: String, CodingKey {
        case status
        case patientID = "patient_id"
    }
}
