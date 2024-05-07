import UIKit
import PhotosUI

class UploadReportsVC: BasicViewController, PHPickerViewControllerDelegate {
    
    @IBOutlet weak var SelectButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    
    var selectedImages: [UIImage] = []
    var patientID = "20240312"
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        SelectButton.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
    }
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        guard !selectedImages.isEmpty else {
            showToast("No images selected.")
            return
        }
        uploadImages()
    }
    
    @objc func selectButtonTapped() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 15
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
        
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)
        startIndicator()
        selectedImages.removeAll()
        
        for result in results {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let self = self, let image = image as? UIImage else { return }
                    
                    DispatchQueue.main.async {
                        self.startIndicator()
                        self.selectedImages.append(image)
                        self.updateStackView()
                        
                    }
                }
            }
        }
        self.stopIndicator()

    }


    func updateStackView() {
        // Remove all arranged subviews from the stack view
        for arrangedSubview in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(arrangedSubview)
            arrangedSubview.removeFromSuperview()
        }
        
        // Add UIImageViews for each selected image to the stack view
        for image in selectedImages {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true // Set fixed height
            stackView.addArrangedSubview(imageView)
        }
        self.stopIndicator()

    }
}
extension UploadReportsVC{
    func uploadImages() {
        self.startIndicator()
        let apiURL = ApiList.UploadingReportsURL
        let boundary = UUID().uuidString
        
        var request = URLRequest(url: URL(string: apiURL)!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"patient_id\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(patientID)\r\n".data(using: .utf8)!)
        
        let uploadGroup = DispatchGroup() // For concurrent uploads
        
        // Use concurrent queue for faster processing
        let concurrentQueue = DispatchQueue(label: "imageUploadQueue", attributes: .concurrent)
        
        // Append images as multipart/form-data
        for image in selectedImages {
            uploadGroup.enter() // Enter group for each upload
            
            concurrentQueue.async {
                guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                    print("Failed to convert image to data.")
                    uploadGroup.leave() // Leave group on failure
                    return
                }
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"images[]\"; filename=\"\(UUID().uuidString).jpg\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                body.append(imageData)
                body.append("\r\n".data(using: .utf8)!)
                
                uploadGroup.leave() // Leave group on successful upload
            }
        }
        
        uploadGroup.notify(queue: DispatchQueue.global()) {
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)
            request.httpBody = body
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                    DispatchQueue.main.async {
                        self.stopIndicator()
                        self.showToast("Error uploading images")
                    }
                    return
                }
                
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                        if let jsonArray = json, let firstObject = jsonArray.first {
                            if let message = firstObject["message"] as? String {
                                print("Message:", message)
                                DispatchQueue.main.async {
                                    self.stopIndicator()
                                    self.showToast(message)
                                }
                            }
                        }
                    } catch {
                        print("Error parsing JSON:", error.localizedDescription)
                        DispatchQueue.main.async {
                            self.stopIndicator()
                            self.showToast("Error parsing response")
                        }
                    }
                }
            }
            
            task.resume()
        }
    }






}

