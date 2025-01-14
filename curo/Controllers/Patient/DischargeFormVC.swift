//
//  DischargeFormVC.swift
//  curo
//
//  Created by SAIL on 11/03/24.
//

import UIKit

class DischargeFormVC: BasicViewController {
    
    
    @IBOutlet weak var dischargeFormImageView: UIImageView!
    
    var patientId = "20240310"
    var dischargeFormModel: DischargeFormModel?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        postApi()

        // Do any additional setup after loading the view.
    }
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension DischargeFormVC {
    func postApi() {
        self.startIndicator()
        let formData: [String: Any] = ["patient_id": patientId]
        APIHandler().postAPIValues(type: DischargeFormModel.self, apiUrl: ApiList.DischargeFormURL, method: "POST", formData: formData) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async { [self] in
                    for path in data.profilePicPath {
                        if let imageURL = URL(string: ApiList.baseUrl + path) {
                            self.loadImage(from: imageURL) { image in
                                // Assuming you want to display all images in the image view
                                // You might need to modify this logic based on your requirements
                                DispatchQueue.main.async {
                                    if let image = image {
                                        // Append each image to a collection or display the last one
                                        self.dischargeFormImageView.image = image
                                    }
                                }
                            }
                        }
                    }
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

    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
}
