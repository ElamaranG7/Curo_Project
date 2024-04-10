//
//  PatientDashboardVC.swift
//  RemainderApp
//
//  Created by SAIL on 08/03/24.
//

import UIKit

class PatientDashboardVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   
    @IBAction func physioButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PhysiotherephyVC") as! PhysiotherephyVC
                    self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func positionsButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PositionsVC") as! PositionsVC
                    self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func bedSoresButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BedSoresVC") as! BedSoresVC
                    self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func feedsButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FeedsVC") as! FeedsVC
                    self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func foleysAndRylesButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FoleysPatientVC") as! FoleysPatientVC
                    self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
