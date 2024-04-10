//
//  PatientDetailsVC.swift
//  RemainderApp
//
//  Created by SAIL on 08/03/24.
//

import UIKit

class PatientDetailsVC: BasicViewController {

    @IBOutlet weak var profileImage: UIImageView!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hospitalIdLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var mobileNoLabel: UILabel!
    @IBOutlet weak var diagnosisLabel: UILabel!
    
    var hospitalId = ""
    var patientDetailsData : [PatientDetailsData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postApi()

    }
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func editPatientButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditPatientDetailsVC") as! EditPatientDetailsVC
                    self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension PatientDetailsVC{
    func postApi(){
        self.startIndicator()
        var formData  = ["hospital_id": hospitalId]
        APIHandler().postAPIValues(type: PatientDetailsModel.self, apiUrl: ApiList.PatientDetailsURL, method: "POST", formData: formData) { Result in
            switch Result {
            case .success(let data):
                DispatchQueue.main.async { [self] in
                    self.patientDetailsData = data.patients
                    nameLabel.text = patientDetailsData.first?.name
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    self.stopIndicator()
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self.stopIndicator()
                    self.showAlert(title: "Failure", message: "Something Went Wrong", okActionHandler: {})
                }
            }
        }
    }

}
