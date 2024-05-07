import UIKit

class AddpatientVC: BasicViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var mobileNoTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var diagnosisTextField: UITextField!
    @IBOutlet weak var procedureTextField: UITextField!
    var selectedImage = [UIImage]()
    var imagePicker = UIImagePickerController()
    var imageData = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGenderTextField()
        setupProcedureTextField()
        setupImagePicker()
        setupProfileImageTap()
    }

    @IBAction func DoneButton(_ sender: Any) {
        addImageToBackend()
    }

    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func setupGenderTextField() {
        let genderTapGesture = UITapGestureRecognizer(target: self, action: #selector(showGenderActionSheet))
        genderTextField.addGestureRecognizer(genderTapGesture)
        genderTextField.isUserInteractionEnabled = true
        genderTextField.placeholder = "Select Gender"
    }

    @objc func showGenderActionSheet() {
        let alert = UIAlertController(title: "Select Gender", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Male", style: .default, handler: { _ in
            self.genderTextField.text = "Male"
        }))
        alert.addAction(UIAlertAction(title: "Female", style: .default, handler: { _ in
            self.genderTextField.text = "Female"
        }))
        alert.addAction(UIAlertAction(title: "Other", style: .default, handler: { _ in
            self.genderTextField.text = "Other"
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func setupProcedureTextField() {
        let procedureTapGesture = UITapGestureRecognizer(target: self, action: #selector(showProcedureActionSheet))
        procedureTextField.addGestureRecognizer(procedureTapGesture)
        procedureTextField.isUserInteractionEnabled = true
        procedureTextField.placeholder = "Select Procedure"
    }

    @objc func showProcedureActionSheet() {
        let alert = UIAlertController(title: "Select Procedure", message: nil, preferredStyle: .actionSheet)
        let procedures = [
            "Laparoscopic appendicectomy",
            "Open appendicectomy",
            "Incision and Drainage",
            "Resection anastamosis",
            "Omental Patch Repair",
            "Conservative management",
            "Laparoscopic mesh repair",
            "Open Mesh repair",
            "Excision and biopsy"
        ]
        for procedure in procedures {
            alert.addAction(UIAlertAction(title: procedure, style: .default, handler: { _ in
                self.procedureTextField.text = procedure
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
    }

    func setupProfileImageTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectProfileImage))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGesture)
    }

    @objc func selectProfileImage() {
        let alert = UIAlertController(title: "Select Image Source", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = profileImage
            popoverController.sourceRect = profileImage.bounds
        }
        present(alert, animated: true, completion: nil)
    }

    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera not available")
        }
    }

    func openGallery() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    // MARK: - UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("Image selected successfully")
            profileImage.contentMode = .scaleAspectFit
            profileImage.image = pickedImage
            selectedImage.append(pickedImage)
            imageData = "data:image/jpeg:base64," + convertImageToBase64(image: pickedImage)!
        } else {
            print("Failed to get the image")
        }

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

   

    func convertImageToBase64(image: UIImage) -> String? {
        // Convert image to data
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            print("Failed to convert image to data.")
            return nil
        }
        let base64String = imageData.base64EncodedString()
        
        return base64String
    }

    // Example usage
    func addImageTobackEnd() {
       
       let apiURL = ApiList.AddPatientURL
       print("API URL:", apiURL)

       let boundary = UUID().uuidString
       var request = URLRequest(url: URL(string: apiURL)!)
       request.httpMethod = "POST"
       request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
       var body = Data()
        let formData: [String: Any] = [
            "patient_name": nameTextField.text ?? "",
            "age": ageTextField.text ?? "",
            "gender": genderTextField.text ?? "",
            "mobileno": mobileNoTextField.text ?? "",
            "email": emailTextField.text ?? "",
            "diagnosis": diagnosisTextField.text ?? "",
            "disease": procedureTextField.text ?? "",
        
        ]

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
                                   if let status = json["status"] as? String, let message = json["message"] as? String {
                                       
                                       DispatchQueue.main.async {
                                           if self.navigationController != nil {
                                               self.showToast(message)
                                           }
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
    
    func addImageToBackend(){
        guard let apiURL = URL(string: ApiList.AddPatientURL) else {
            print("Invalid API URL")
            return
        }

        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let formData: [String: Any] = [
            "patient_name": nameTextField.text ?? "",
            "age": ageTextField.text ?? "",
            "gender": genderTextField.text ?? "",
            "mobileno": mobileNoTextField.text ?? "",
            "email": emailTextField.text ?? "",
            "diagnosis": diagnosisTextField.text ?? "",
            "disease": procedureTextField.text ?? "",
            "profile_image": imageData
        ]
        print("formData : \(formData)")
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: formData, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error serializing JSON:", error)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Status code: \(httpResponse.statusCode)")

                if let data = data {
                    print("Response Data:", String(data: data, encoding: .utf8) ?? "")
                    // Handle response data as needed
                }
            }
        }

        task.resume()
    }

    func convertImageToBase64() -> String? {
        guard let image = selectedImage.first, let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Error converting image to base64: Image data not available")
            return nil
        }
        print("imageData --- >",imageData.base64EncodedString())
        return imageData.base64EncodedString()
    }

//    func registerUser() {
//        guard let image = selectedImage else {
//            showAlert(title: "Error", message: "Please select an image")
//            return
//        }
//
//        startIndicator()
//
//        let apiURL = ApiList.AddPatientURL
//        print(apiURL)
//
//        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
//            showAlert(title: "Error", message: "Failed to convert image to data")
//            return
//        }
//        let base64Image = imageData.base64EncodedString()
//
//        let formData: [String: Any] = [
//            "patient_name": nameTextField.text ?? "",
//            "age": ageTextField.text ?? "",
//            "gender": genderTextField.text ?? "",
//            "mobileno": mobileNoTextField.text ?? "",
//            "email": emailTextField.text ?? "",
//            "diagnosis": diagnosisTextField.text ?? "",
//            "disease": procedureTextField.text ?? "",
//            "profile_image": base64Image
//        ]
//
//        APIHandler().postAPIValues(type: AddPatientModel.self, apiUrl: apiURL, method: "POST", formData: formData) { result in
//            switch result {
//            case .success(let data):
//                print("Status: \(data.status)")
//                print("Patient ID: \(data.patient_id)")
//                DispatchQueue.main.async { [self] in
//                    if data.status == "success" {
//                        showAlert(title: "Success", message: "Patient added successfully", okActionHandler: {
//                            self.navigationController?.popViewController(animated: true)
//                        })
//                    } else {
//                        showAlert(title: "Failure", message: "Failed to add patient")
//                    }
//                    stopIndicator()
//                }
//            case .failure(let error):
//                print(error)
//                DispatchQueue.main.async { [self] in
//                    stopIndicator()
//                    showAlert(title: "Failure", message: error.localizedDescription)
//                }
//            }
//        }
//    }
}
