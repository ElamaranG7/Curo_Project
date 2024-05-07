//
//  dloginVC.swift
//  curo
//
//  Created by SAIL on 11/03/24.
//

import UIKit

class dloginVC: BasicViewController {
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
//
//    @IBAction func doctorDashButton(_ sender: Any) {
//
//        guard let usernameText = username.text, !usernameText.isEmpty else {
//            showToast("Enter the UserName")
//            return
//        }
//
//        guard let passwordText = password.text, !passwordText.isEmpty else {
//            showToast("Enter the Password")
//            return
//        }
//
//        getAPI(username: usernameText, password: passwordText)
//    }
    @IBAction func doctorDashButton(_ sender: Any) {
           // Check for empty fields
           if username.text?.isEmpty ?? false && password.text?.isEmpty ?? false {
               showToast("Enter Username and Password")
           } else if username.text?.isEmpty ?? true {
               showToast("Enter the Username")
           } else if password.text?.isEmpty ?? true {
               showToast("Enter the Password")
           } else {
               getAPI(username: username.text!, password: password.text!)
           }
           
           
         
       }

    func getAPI(username: String, password: String) {
        // Prepare URL
        guard let url = URL(string: ApiList.dloginURL) else {
            print("Invalid URL")
            return
        }

        // Prepare parameters
        let formData: [String: Any] = [
            "username": username,
            "password": password
        ]

        // Perform request
        let apiHandler = APIHandler()
        apiHandler.postAPIValues(type: loginModel.self, apiUrl: url.absoluteString, method: "POST", formData: formData) { [weak self] result in
            switch result {
            case .success(let loginModel):
                // Handle the success response here
                print(loginModel)
                DispatchQueue.main.async {
                    if loginModel.status == "success"{
                    let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DoctorDashboardVC") as! DoctorDashboardVC
                   // nextVC.PatientId = username
                    UserDefaultsManager.shared.savePatientId(username)
                    self?.navigationController?.pushViewController(nextVC, animated: true)
                }
                else{
                        self?.showToast(loginModel.message)
                     }
        }
            case .failure(let error):
                // Handle the failure here
                print("Error: \(error)")
            }
        }
    }
}
