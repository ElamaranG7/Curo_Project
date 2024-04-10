//
//  PatientListTableViewCell.swift
//  curo
//
//  Created by SAIL on 13/03/24.
//

import UIKit

class PatientListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var patientImage: UIImageView!
    @IBOutlet weak var patientIdLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
