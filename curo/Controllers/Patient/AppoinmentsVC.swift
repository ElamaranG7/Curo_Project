//
//  AppoinmentsVC.swift
//  curo
//
//  Created by SAIL on 11/03/24.
//

import UIKit

class AppoinmentsVC: BasicViewController {
    
    var patientId = ""
    
    @IBOutlet weak var patientIdLabel: UILabel!
    @IBOutlet weak var calendarDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        patientIdLabel.text = patientId
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendDataToAPI(_ sender: Any) {
        let selectedDate = calendarDatePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: selectedDate)
        
        var formData: [String: Any] = ["patient_id": patientId]
        formData["date"] = formattedDate
        
        getApi(with: formData)
    }

    func getApi(with formData: [String: Any]) {
        self.startIndicator()
        APIHandler().postAPIValues(type: loginModel.self, apiUrl: ApiList.appoinmentsBookingURL, method: "POST", formData: formData) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.showToast(data.message)
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
 
