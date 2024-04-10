//
//  NotifactionsModel.swift
//  curo
//
//  Created by SAIL on 15/03/24.
//

import Foundation

struct NotifactionsListModel: Codable {
    let status: String
    let data: [NotifactionsListData]
}

// MARK: - Datum
struct Datum: Codable {
    let patientID, patientName, notifications: String

    enum CodingKeys: String, CodingKey {
        case patientID = "patient_id"
        case patientName = "patient_name"
        case notifications
    }
}
