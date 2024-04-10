//
//  ViewController.swift
//  RemainderApp
//
//  Created by SAIL on 27/02/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func doctorlogin(_ sender: Any) {
       
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DoctorLoginVC") as! DoctorLoginVC
                    self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func patientlogin(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PatientLoginVC") as! PatientLoginVC
                    self.navigationController?.pushViewController(vc, animated: true)
    }
}

