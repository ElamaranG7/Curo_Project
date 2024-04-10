import UIKit

class PatientLoginVC: BasicViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onlogin(_ sender: Any) {
        guard let usernameText = username.text, !usernameText.isEmpty else {
            showToast("Enter the UserName")
            return
        }

        guard let passwordText = password.text, !passwordText.isEmpty else {
            showToast("Enter the Password")
            return
        }

        getAPI(username: usernameText, password: passwordText)
        
      
    }

    func getAPI(username: String, password: String) {
        // Prepare URL
        guard let url = URL(string: ApiList.ploginURL) else {
            print("Invalid URL")
            return
        }

        // Prepare parameters
        let formData: [String: Any] = [
            "username": username,
            "password": password
        ]

        // Perform request
        let apiHandler = APIHandler()
        apiHandler.postAPIValues(type: loginModel.self, apiUrl: url.absoluteString, method: "POST", formData: formData) { [weak self] result in
            switch result {
            case .success(let loginModel):
                // Handle the success response here
                print(loginModel)
                DispatchQueue.main.async {
                    let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PdashboardVC") as! PdashboardVC
                    nextVC.PatientId = username
                    UserDefaultsManager.shared.savePatientId(username)
                    self?.navigationController?.pushViewController(nextVC, animated: true)
                }
            case .failure(let error):
                // Handle the failure here
                print("Error: \(error)")
            }
        }
    }
}
