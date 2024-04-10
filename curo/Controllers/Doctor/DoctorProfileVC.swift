//
//  DoctorProfileVC.swift
//  curo
//
//  Created by SAIL on 11/03/24.
//

import UIKit

class DoctorProfileVC: BasicViewController {
    
    @IBOutlet weak var designationLabel: UILabel!
    @IBOutlet weak var contactNoLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    
    var userId = "123"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postApi()
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func postApi() {
        startIndicator()
        let formData = ["user_id": userId]
        APIHandler().postAPIValues(type: DoctorDetailsModel.self, apiUrl: ApiList.DoctorDetailsURL, method: "POST", formData: formData) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.nameLabel.text = data.name
                    self.userIdLabel.text = data.userID
                    self.genderLabel.text = data.gender
                    self.contactNoLabel.text = data.contactNo
                    self.designationLabel.text = data.specialization
                    self.stopIndicator()
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async { [weak self] in
                    self?.stopIndicator()
                    self?.showAlert(title: "Failure", message: "Something Went Wrong", okActionHandler: {})
                }
            }
        }
    }
}
