import UIKit

class EditPatientDetailsVC: BasicViewController {

    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var patientIdLabel: UILabel!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var mobilenoTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var diagnosisTextField: UITextField!
    
    @IBOutlet weak var sideView: UIView! // Add IBOutlet for the side view

    var patientId = ""
    var patientName = ""
    var patientDetailsData: PatientDetailsData?

    var sideviewBool = true // Variable to keep track of side view state

    override func viewDidLoad() {
        super.viewDidLoad()
        patientIdLabel.text = patientId
        patientNameLabel.text = patientDetailsData?.patientName
        ageTextField.text = patientDetailsData?.age
        mobilenoTextField.text = patientDetailsData?.mobileno
        diagnosisTextField.text = patientDetailsData?.diagnosis
        genderTextField.text = patientDetailsData?.gender

        // Add menu button to navigation bar
        let menuButton = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(menuButtonTapped(_:)))
        navigationItem.rightBarButtonItem = menuButton
        
        // Hide side view initially
        sideView.isHidden = true

        // Add tap gesture recognizer to handle side view hiding
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.delegate = self
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if !sideView.isHidden {
            hideSideView()
        }
    }
    
    func showSideView() {
        sideView.isHidden = false
        // Adjust side view frame as needed
        sideView.frame = CGRect(x: view.frame.width - 200, y: 0, width: 200, height: view.frame.height)
        sideviewBool = false
    }
    
    func hideSideView() {
        sideView.isHidden = true
        sideviewBool = true
    }

    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func saveButton(_ sender: Any) {
        view.endEditing(true)
        registerUserEdit()
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        if sideviewBool {
            showSideView()
        } else {
            hideSideView()
        }
    }

    @objc func showMenu() {
        // Your menu implementation here
    }

    func registerUserEdit() {
        // Your user edit registration logic here
    }
    @IBAction func uploadReportsButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UploadReportsVC") as! UploadReportsVC
        vc.patientID = patientId // Assuming patientId is a variable accessible in this scope
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func uploadDischargeFormButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UploadDischargeFormVC") as! UploadDischargeFormVC
        vc.patientId = patientId // Assuming patientId is a variable accessible in this scope
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension EditPatientDetailsVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view != sideView
    }
}
