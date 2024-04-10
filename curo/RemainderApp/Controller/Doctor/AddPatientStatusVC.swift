//
//  AddPatientStatusVC.swift
//  RemainderApp
//
//  Created by SAIL on 08/03/24.
//

import UIKit

class AddPatientStatusVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func saveButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DoctorDasboardVC") as! DoctorDasboardVC
                    self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
