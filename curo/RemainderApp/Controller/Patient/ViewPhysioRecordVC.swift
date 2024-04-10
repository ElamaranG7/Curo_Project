//
//  ViewPhysioRecordVC.swift
//  RemainderApp
//
//  Created by SAIL on 08/03/24.
//

import UIKit

class ViewPhysioRecordVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
