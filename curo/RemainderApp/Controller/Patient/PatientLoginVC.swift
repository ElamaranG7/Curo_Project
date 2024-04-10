//
//  PatientLoginVC.swift
//  RemainderApp
//
//  Created by SAIL on 08/03/24.
//

import UIKit

class PatientLoginVC: BasicViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onlogin(_ sender: Any) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PatientDashboardVC") as! PatientDashboardVC
        self.navigationController?.pushViewController(nextVC, animated: true)

//        if username.text?.isEmpty == true {
//            showToast("Enter the UserName")
//         
//        } else if password.text?.isEmpty == true {
//            showToast("Enter the Password")
//
//        } else {
//            getAPI()
//        }
    }
    
    }
    
   


extension  PatientLoginVC {

    func getAPI() {
        guard let username = username.text, let password = password.text else {
            return
        }
        
        // Prepare URL
        let urlString = "\(ApiList.ploginURL)"
        guard let url = URL(string: urlString) else {
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
        apiHandler.postAPIValues(type: Loginmodel.self, apiUrl: urlString, method: "POST", formData: formData) { [weak self] result in
            switch result {
            case .success(let loginModel):
                // Handle the success response here
                print(loginModel)
                // Assuming loginModel contains information about successful login
                // Navigate to the next page
                DispatchQueue.main.async {
                    let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PatientDashboardVC") as! PatientDashboardVC
                    self?.navigationController?.pushViewController(nextVC, animated: true)

                }
            case .failure(let error):
                // Handle the failure here
                print("Error: \(error)")
            }
        }
    }


    }

