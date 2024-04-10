import UIKit

class AddpatientVC: BasicViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var mobileNoTextField: UITextField!
    @IBOutlet weak var diagnosisTextField: UITextField!
    @IBOutlet weak var procedureTextField: UITextField!
    var selectedImage: UIImage? = nil
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGenderTextField()
        setupProcedureTextField()
        setupImagePicker()
        setupProfileImageTap()
    }

    @IBAction func DoneButton(_ sender: Any) {
        registerUser()
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
            profileImage.contentMode = .scaleAspectFit
            profileImage.image = pickedImage
            selectedImage = pickedImage
        }

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func registerUser() {
        guard let image = selectedImage else {
            showAlert(title: "Error", message: "Please select an image")
            return
        }

        startIndicator()

        let apiURL = ApiList.AddPatientURL // Assuming AddPatientURL is a constant in your ApiUrl class
        print(apiURL)

        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            showAlert(title: "Error", message: "Failed to convert image to data")
            return
        }
        let base64Image = imageData.base64EncodedString()

        let formData: [String: Any] = [
            "name": nameTextField.text ?? "",
            "age": ageTextField.text ?? "",
            "gender": genderTextField.text ?? "",
            "mobile_number": mobileNoTextField.text ?? "",
            "diagnosis": diagnosisTextField.text ?? "",
            "procedure": procedureTextField.text ?? "",
            "profile_image": base64Image
        ]

        APIHandler().postAPIValues(type: AddPatientModel.self, apiUrl: apiURL, method: "POST", formData: formData) { result in
            switch result {
            case .success(let data):
                print("Status: \(data.status)")
                print("Patient ID: \(data.patientID)")
                DispatchQueue.main.async { [self] in
                    if data.status == "success" {
                        showAlert(title: "Success", message: "Patient added successfully", okActionHandler: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    } else {
                        showAlert(title: "Failure", message: "Failed to add patient")
                    }
                    stopIndicator()
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async { [self] in
                    stopIndicator()
                    showAlert(title: "Failure", message: error.localizedDescription)
                }
            }
        }
    }
}
