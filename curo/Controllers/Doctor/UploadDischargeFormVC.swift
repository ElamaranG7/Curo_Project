import UIKit

class UploadDischargeFormVC: BasicViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var dischargeFormImageView: UIImageView!
    
    var selectedImage = [UIImage]()
    var imagePicker = UIImagePickerController()
    var imageData = ""
    var patientId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Add tap gesture recognizer to dischargeFormImageView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dischargeFormImageViewTapped))
        dischargeFormImageView.addGestureRecognizer(tapGesture)
        dischargeFormImageView.isUserInteractionEnabled = true // Enable user interaction
    }
    
    // Handle tap on dischargeFormImageView
    @objc func dischargeFormImageViewTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImages = info[.originalImage] as? UIImage {
            dischargeFormImageView.image = selectedImages
                selectedImage.append(selectedImages)
        }
        picker.dismiss(animated: true, completion: nil)
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    @IBAction func saveButton(_ sender: Any) {
        
        uploadFormApi()
    }
}

extension UploadDischargeFormVC {
    func uploadFormApi() {
        
        let apiURL = ApiList.UploadingDischareFromURL
        print("API URL:", apiURL)
        
        let boundary = UUID().uuidString
        var request = URLRequest(url: URL(string: apiURL)!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var body = Data()
        let formData: [String: Any] = ["patient_id": patientId]
        for (key, value) in formData {
            body.append(contentsOf: "--\(boundary)\r\n".utf8)
            body.append(contentsOf: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8)
            body.append(contentsOf: "\(value)\r\n".utf8)
        }
        let fieldNames = ["profile_image"]
        for (index, image) in selectedImage.enumerated() {
            let fieldName = fieldNames[index]
            let imageData = image.jpegData(compressionQuality: 0.8)!
            body.append(contentsOf: "--\(boundary)\r\n".utf8)
            body.append(contentsOf: "Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(UUID().uuidString).jpg\"\r\n".utf8)
            body.append(contentsOf: "Content-Type: image/jpeg\r\n\r\n".utf8)
            body.append(contentsOf: imageData)
            body.append(contentsOf: "\r\n".utf8)
        }
        body.append(contentsOf: "--\(boundary)--\r\n".utf8) // Close the request body
        request.httpBody = body
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("Status code: \(httpResponse.statusCode)")
                if let data = data {
                    print("Response Data:", String(data: data, encoding: .utf8) ?? "")
                    if let responseData = String(data: data, encoding: .utf8) {
                        if let jsonData = responseData.data(using: .utf8) {
                            do {
                                if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                                        DispatchQueue.main.async { [self] in
                                            if self.navigationController != nil {
                                                self.showAlert(title: "Success", message: "Image Uploaded", okActionHandler: {
                                                    self.navigationController?.popViewController(animated: true)
                                                })
                                            }
                                    }
                                }
                            } catch {
                                print("Error parsing JSON: \(error)")
                            }
                        }
                    }
                }
            }
        }
        task.resume()
    }
//    func postApi(with imageData: Data) {
//        self.startIndicator()
//        let formData: [String: Any] = ["patient_id": patientId,
//                                        "profile_image" : imageData]
//        APIHandler().postAPIValues(type: DischargeFormUploadModel.self, apiUrl: ApiList.UploadingDischareFromURL, method: "POST", formData: formData) { result in
//            switch result {
//            case .success(_):
//                DispatchQueue.main.async { [self] in
//                    // Handle success response
//                    self.stopIndicator()
//                }
//            case .failure(let error):
//                print(error)
//                DispatchQueue.main.async {
//                    self.stopIndicator()
//                    self.showAlert(title: "Failure", message: "Something Went Wrong", okActionHandler: {})
//                }
//            }
//        }
//    }
}
