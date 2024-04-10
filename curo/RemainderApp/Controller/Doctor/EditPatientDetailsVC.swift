//
//  EditPatientDetailsVC.swift
//  RemainderApp
//
//  Created by SAIL on 08/03/24.
//

import UIKit

class EditPatientDetailsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func saveButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PatientDetailsVC") as! PatientDetailsVC
                    self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
