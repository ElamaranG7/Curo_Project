//
//  MyProfileVC.swift
//  curo
//
//  Created by SAIL on 11/03/24.
//

import UIKit

class MyProfileVC: BasicViewController {
    
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var patientIdLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var mobilenoLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var daginosisLabel: UILabel!
    @IBOutlet weak var ProfileImage: UIImageView!
    
    
    var patientId = ""
    var patientDetailsData : PatientDetailsData?

    override func viewDidLoad() {
        super.viewDidLoad()
        postApi()

    }
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneButton(_ sender: Any) {
      
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func logoutButton(_ sender: Any) {
      
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MyProfileVC{
    func postApi(){
        self.startIndicator()
        let formData  = ["patient_id": patientId]
        APIHandler().postAPIValues(type: DocPatientDetailsModel.self, apiUrl: ApiList.PatientDetailsURL, method: "POST", formData: formData) { Result in
            switch Result {
            case .success(let data):
                DispatchQueue.main.async { [self] in
                
                    self.patientDetailsData = data.patientData
                    patientNameLabel.text = patientDetailsData?.patientName
                    patientIdLabel.text = patientDetailsData?.patientID
                    genderLabel.text = patientDetailsData?.gender
                    mobilenoLabel.text = patientDetailsData?.mobileno
                    ageLabel.text = patientDetailsData?.age
                    daginosisLabel.text = patientDetailsData?.diagnosis
                    if let profileImageURL = URL(string: ApiList.baseUrl + (patientDetailsData?.profileImage ?? "")) {
                        loadImage(from: profileImageURL, into:ProfileImage)
                    }


                  
                    
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
