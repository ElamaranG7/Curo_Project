//
//  dloginVC.swift
//  curo
//
//  Created by SAIL on 11/03/24.
//

import UIKit

class dloginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func doctorDashButton(_ sender: Any) {
      
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DoctorDashboardVC") as! DoctorDashboardVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

   
}
