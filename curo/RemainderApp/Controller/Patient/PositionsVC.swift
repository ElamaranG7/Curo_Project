//
//  PositionsVC.swift
//  RemainderApp
//
//  Created by SAIL on 08/03/24.
//

import UIKit

class PositionsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func positionsButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewPatientBedPositionsVC") as! ViewPatientBedPositionsVC
                    self.navigationController?.pushViewController(vc, animated: true)
    }
}
