//
//  PhysiotherephyVC.swift
//  RemainderApp
//
//  Created by SAIL on 08/03/24.
//

import UIKit

class PhysiotherephyVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func physioHistoryButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewPatientPhysioVC") as! ViewPatientPhysioVC
                    self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
