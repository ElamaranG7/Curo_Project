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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
