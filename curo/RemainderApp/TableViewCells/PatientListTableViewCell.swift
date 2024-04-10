//
//  PatientListTableViewCell.swift
//  RemainderApp
//
//  Created by SAIL on 29/02/24.
//

import UIKit

class PatientListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var patientImage: UIImageView!
    @IBOutlet weak var hosptialIdLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
