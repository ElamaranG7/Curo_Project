//
//  PatientDetailsVC.swift
//  curo
//
//  Created by SAIL on 11/03/24.
//

import UIKit

class PatientDetailsVC: BasicViewController {

    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var patientIdLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var mobilenoLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var daginosisLabel: UILabel!
    @IBOutlet weak var ProfileImage: UIImageView!
    
    @IBOutlet weak var sideView: UIView! // Use IBOutlet directly
    
    var patientId = ""
    var patientDetailsData: PatientDetailsData?
    var sideviewBool = true // Variable to keep track of side view state
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("patientId : \(patientId)")

        postApi()
        
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
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        if sideviewBool {
            showSideView()
        } else {
            hideSideView()
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditPatientDetailsVC") as! EditPatientDetailsVC
        vc.patientId = patientId
        vc.patientDetailsData = patientDetailsData
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DoctorDashboardVC") as! DoctorDashboardVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func viewReportsButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewReportsVC") as! ViewReportsVC
        vc.patientId = patientId // Assuming patientId is a variable accessible in this scope
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func viewDischargeFormButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewDischargeFormVC") as! ViewDischargeFormVC
        vc.patientId = patientId // Assuming patientId is a variable accessible in this scope
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension PatientDetailsVC {
    func postApi() {
        self.startIndicator()
        let formData = ["patient_id": patientId]
        APIHandler().postAPIValues(type: DocPatientDetailsModel.self, apiUrl: ApiList.PatientDetailsURL, method: "POST", formData: formData) { Result in
            switch Result {
            case .success(let data):
                DispatchQueue.main.async { [self] in
                    self.patientDetailsData = data.patientData
                    patientNameLabel.text = patientDetailsData?.patientName
                    patientIdLabel.text = patientDetailsData?.patientID
                    genderLabel.text = patientDetailsData?.gender
                    mobilenoLabel.text = patientDetailsData?.mobileno
                    ageLabel.text = patientDetailsData?.age
                    daginosisLabel.text = patientDetailsData?.diagnosis
                    if let profileImageURL = URL(string: ApiList.baseUrl + (patientDetailsData?.profileImage ?? "")) {
                        loadImage(from: profileImageURL, into: ProfileImage)
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
}

extension PatientDetailsVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view != sideView
    }
    
    func showSideView() {
        sideView.isHidden = false
        // Adjust side view frame
        let sideViewWidth: CGFloat = 200
        sideView.frame = CGRect(x: view.bounds.width - sideViewWidth, y: 0, width: sideViewWidth, height: view.bounds.height)
        sideviewBool = false
    }
    
    func hideSideView() {
        sideView.isHidden = true
        sideviewBool = true
    }
}
