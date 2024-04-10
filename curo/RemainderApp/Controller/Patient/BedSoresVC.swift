//
//  BedSoresVC.swift
//  RemainderApp
//
//  Created by SAIL on 08/03/24.
//

import UIKit

class BedSoresVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func soresHistoryButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewPatientBedSoresVC") as! ViewPatientBedSoresVC
                    self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
