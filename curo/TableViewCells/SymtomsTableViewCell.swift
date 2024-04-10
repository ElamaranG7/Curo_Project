//
//  SymtomsTableViewCell.swift
//  curo
//
//  Created by SAIL on 27/03/24.
//

import UIKit

class SymtomsTableViewCell: UITableViewCell {

    @IBOutlet weak var checkBoxButton : UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
}
