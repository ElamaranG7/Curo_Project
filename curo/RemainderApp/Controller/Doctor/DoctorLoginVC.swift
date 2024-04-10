//
//  DoctorLoginVC.swift
//  RemainderApp
//
//  Created by SAIL on 08/03/24.
//

import UIKit

class DoctorLoginVC: BasicViewController {
    var logInDetails : Loginmodel!
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBOutlet weak var useernameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func onLogInbutton(_ sender: Any) {
        
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DoctorDasboardVC") as! DoctorDasboardVC
        self.navigationController?.pushViewController(nextVC, animated: true)

//                if useernameField.text?.isEmpty == true {
//                    showToast("Enter the UserName")
//                 
//                } else if passwordField.text?.isEmpty == true {
//                    showToast("Enter the Password")
//
//                } else {
//                    getAPI()
//                }
            }
    
    

}
extension  DoctorLoginVC {

    func getAPI() {
        guard let username = useernameField.text, let password = passwordField.text else {
            return
        }
        
        // Prepare URL
        let urlString = "\(ApiList.loginURL)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        let formData: [String: Any] = [
            "username": username,
            "password": password
        ]
        APIHandler().postAPIValues(type: Loginmodel.self, apiUrl: urlString, method: "POST", formData: formData) { [weak self] result in
            switch result {
            case .success(let data):
                print(data)
                DispatchQueue.main.async {
                    let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DoctorDasboardVC") as! DoctorDasboardVC
                    self?.navigationController?.pushViewController(nextVC, animated: true)

                }
            case .failure(let error):
                // Handle the failure here
                print("Error: \(error)")
            }
        }
    }


    }
