import UIKit

class UploadDischargeFormVC: BasicViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var patientId = "132"
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var dischargeFormImageView: UIImageView!
    
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
        if let selectedImage = info[.originalImage] as? UIImage {
            dischargeFormImageView.image = selectedImage
            if let imageData = selectedImage.jpegData(compressionQuality: 1.0) {
                postApi(with: imageData)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditPatientDetailsVC") as! EditPatientDetailsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension UploadDischargeFormVC {
    func postApi(with imageData: Data) {
        self.startIndicator()
        let formData: [String: Any] = ["patient_id": patientId,
                                        "profile_image" : imageData]
        APIHandler().postAPIValues(type: DischargeFormUploadModel.self, apiUrl: ApiList.UploadingDischareFromURL, method: "POST", formData: formData) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async { [self] in
                    // Handle success response
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
