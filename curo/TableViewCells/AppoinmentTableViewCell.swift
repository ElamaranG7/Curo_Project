//
//  AppoinmentTableViewCell.swift
//  curo
//
//  Created by SAIL on 19/03/24.
//

import UIKit

class AppoinmentTableViewCell: UITableViewCell {

    @IBOutlet weak var PatientNameLabel: UILabel!
    @IBOutlet weak var PatientIdLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var StatusLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var approveButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
