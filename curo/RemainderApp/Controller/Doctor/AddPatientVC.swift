//
//  AddPatientVC.swift
//  RemainderApp
//
//  Created by SAIL on 08/03/24.
//

import UIKit

class AddPatientVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPatientStatusVC") as! AddPatientStatusVC
                    self.navigationController?.pushViewController(vc, animated: true)
    }
}
