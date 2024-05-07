//
//  HomeVC.swift
//  curo
//
//  Created by SAIL on 11/03/24.
//

import UIKit

class HomeVC: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func dLoginButton(_ sender: Any) {
      
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "dloginVC") as! dloginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func patientLoginButton(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PatientLoginVC") as! PatientLoginVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

  

}
