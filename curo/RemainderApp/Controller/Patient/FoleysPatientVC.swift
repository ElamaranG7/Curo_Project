//
//  FoleysPatientVC.swift
//  RemainderApp
//
//  Created by SAIL on 08/03/24.
//

import UIKit

class FoleysPatientVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func foleysHistoryButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewPatientFoleysVC") as! ViewPatientFoleysVC
                    self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
