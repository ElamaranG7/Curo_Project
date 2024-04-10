//
//  NotifactionListModel.swift
//  curo
//
//  Created by SAIL on 15/03/24.
//

import Foundation
struct NotifactionListModel: Codable {
    let status: String
    let data: [NotifactionListData]
}

// MARK: - Datum
struct NotifactionListData: Codable {
    let patientID, patientName, notifications: String

    enum CodingKeys: String, CodingKey {
        case patientID = "patient_id"
        case patientName = "patient_name"
        case notifications="notifications"
    }
}

