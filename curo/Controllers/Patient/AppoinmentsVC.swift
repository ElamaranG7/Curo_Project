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
        Task { [weak self] in
            guard let self = self else { return }
            
            let selectedDate = calendarDatePicker.date

            // Check if selectedDate is not nil
            guard selectedDate != nil else {
                print("Error: calendarDatePicker is nil")
                return
            }

            // Now you can safely access selectedDate's properties
            let formattedDate = DateFormatter.localizedString(from: selectedDate, dateStyle: .medium, timeStyle: .none)

            
            guard let apiUrl = URL(string: ApiList.appoinmentsBookingURL) else {
                print("Error: Invalid API URL")
                return
            }
            
            let postData: [String: Any] = [
                "patientId": self.patientId,
                "selectedDate": formattedDate
                // Add more data keys and values as needed
            ]
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: postData)
                
                var request = URLRequest(url: apiUrl)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonData
                
                let (data, response) = try await URLSession.shared.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                if (200...299).contains(httpResponse.statusCode) {
                    print("Data sent successfully!")
                    // Handle success response from the API
                } else {
                    throw APIError.httpError(statusCode: httpResponse.statusCode)
                }
            } catch let error as APIError {
                switch error {
                case .invalidResponse:
                    print("API Error: Invalid response received.")
                case .httpError(let statusCode):
                    print("API Error: HTTP error with status code \(statusCode).")
                }
            } catch {
                print("Error: \(error.localizedDescription)")
                // Handle other errors
            }
        }
    }
}
extension AppoinmentsVC{
    func postApi(){
        self.startIndicator()
        let formData : [String : Any]  = ["patient_id": patientId ]
        APIHandler().postAPIValues(type: loginModel.self, apiUrl: ApiList.PatientDetailsURL, method: "POST", formData: formData ){ Result in
            switch Result {
            case .success(let data):
                DispatchQueue.main.async { [self] in
                    
//                    symptomsName = data.patientData.diagnosis
                    showToast(data.message)
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

enum APIError: Error {
    case invalidResponse
    case httpError(statusCode: Int)
}
