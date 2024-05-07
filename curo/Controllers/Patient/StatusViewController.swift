//
//  StatusViewController.swift
//  curo
//
//  Created by SAIL on 07/05/24.
//

import UIKit

class StatusViewController: BasicViewController {

    @IBOutlet weak var statusLabel: UILabel!
    var patientId = UserDefaultsManager.shared.getPatientId() ?? ""

    override func viewDidLoad() {
        super.viewDidLoad()
        postApi()
    }

    func postApi() {
        startIndicator()

        let formData: [String: Any] = ["patient_id": patientId]

        APIHandler().postAPIValues(type: statusModel.self, apiUrl: ApiList.appoinmentStatusURL, method: "POST", formData: formData) { result in
            DispatchQueue.main.async {
                self.stopIndicator()
            }

            switch result {
            case .success(let data):
                print("Response Data:", data)
                DispatchQueue.main.async {
                    self.statusLabel.text = data.data.first?.status ?? ""
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.showAlert(title: "Failure", message: "Something Went Wrong", okActionHandler: {})
                }
            }
        }
    }

    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    func showAlert(title: String, message: String, okActionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            okActionHandler()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
