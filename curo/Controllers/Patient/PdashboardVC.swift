//
//  PdashboardVC.swift
//  curo
//
//  Created by SAIL on 11/03/24.
//

import UIKit

class PdashboardVC: BasicViewController {
    
    
    var PatientId = UserDefaultsManager.shared.getPatientId() ?? ""
    var symptomsName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        postApi()
    }
    @IBAction func profileButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileVC
        vc.patientId = PatientId // Assuming PatientId is a variable accessible in this scope
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func symtomsButton(_ sender: Any) {
      
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SymtomsVC") as! SymptomsVC
        vc.patientId = PatientId
        vc.symptomsName = symptomsName
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func reportsButton(_ sender: Any) {
      
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReportsVC") as! ReportsVC
        vc.patientId = PatientId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func dischargeButton(_ sender: Any) {
      
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DischargeFormVC") as! DischargeFormVC
        vc.patientId = PatientId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func appoinmentButton(_ sender: Any) {
      
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AppoinmentsVC") as! AppoinmentsVC
        vc.patientId = PatientId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func postApi(){
        self.startIndicator()
        let formData : [String : Any]  = ["patient_id": PatientId ?? ""]
        APIHandler().postAPIValues(type: DocPatientDetailsModel.self, apiUrl: ApiList.PatientDetailsURL, method: "POST", formData: formData ){ Result in
            switch Result {
            case .success(let data):
                DispatchQueue.main.async { [self] in
                    
                    symptomsName = data.patientData.diagnosis
                    
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
