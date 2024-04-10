//
//  RylesPatientVC.swift
//  RemainderApp
//
//  Created by SAIL on 08/03/24.
//

import UIKit

class RylesPatientVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func rylesHistoryButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewPatientRylesVC") as! ViewPatientRylesVC
                    self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
