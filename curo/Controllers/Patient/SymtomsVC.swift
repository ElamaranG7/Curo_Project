import UIKit

class SymptomsVC: BasicViewController {
    
    @IBOutlet weak var otherTextView: UITextView!
    
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var symptomsTableview: UITableView! {
        didSet {
            symptomsTableview.delegate = self
            symptomsTableview.dataSource = self
            symptomsTableview.allowsMultipleSelection = false
            symptomsTableview.showsVerticalScrollIndicator = false
            symptomsTableview.register(UINib(nibName: "SymtomsTableViewCell", bundle: nil), forCellReuseIdentifier: "SymtomsTableViewCell")
        }
    }
    var symptomsArray: [String] = []
    var Laparoscopic_appendicectomyArray = ["1. Fever / காய்ச்சல்","2. Abdominal Pain / வயிற்று வலி","3. Nausea / குமட்டல் ","4. Vomiting / வாந்தி","5. Discharge from surgical site / அறுவை சிகிச்சை தளத்தில் இருந்து வெளியேற்றம்","6. Constipation / மலச்சிக்கல் "]
    var Open_appendicectomyArray = ["1. Fever / காய்ச்சல்","2. Abdominal Pain / வயிற்று வலி","3. Nausea / குமட்டல் ","4. Vomiting / வாந்தி","5. Discharge from surgical site / அறுவை சிகிச்சை தளத்தில் இருந்து வெளியேற்றம்","6. Constipation / மலச்சிக்கல் ","7. Swelling /வீக்கம் "]
    var Incision_and_DrainageArray = ["1. Fever / காய்ச்சல்","2. Pain at surgical site / அறுவை சிகிச்சை தளத்தில் வலி ","3. Discharge / வெளியேற்றம்","4. Bleeding / இரத்தப்போக்கு","5. Swelling / வீக்கம் "]
    var Resection_anastamosisArray = ["1.Fever / காய்ச்சல்","2. Obstipation / கடும் மலச்சிக்கல்","3. Constipation / மலச்சிக்கல்","4. Abdominal Pain / வயிற்று வலி","5. Vomiting / வாந்தி","6. Jaundice / மஞ்சள் காமாலை","7. Abdominal distension / வயிறுவிரிசல்"]
    var Omental_Patch_RepairArray = ["1. Fever / காய்ச்சல்","2. Obstipation / கடும் மலச்சிக்கல்","3. Constipation / மலச்சிக்கல்","4. Abdominal Pain / வயிற்று வலி","5. Vomiting / வாந்தி","6. Jaundice / மஞ்சள் காமாலை","7. Abdominal distension / வயிறுவிரிசல்"]
    var Conservative_managementArray = ["1. Fever / காய்ச்சல்","2. Obstipation / கடும் மலச்சிக்கல்","3. Constipation / மலச்சிக்கல்","4. Abdominal Pain / வயிற்று வலி","5. Vomiting / வாந்தி","6. Jaundice / மஞ்சள் காமாலை","7. Abdominal distension / வயிறுவிரிசல்"]
    var Laparoscopic_mesh_repairArray = ["1. Fever / காய்ச்சல்","2. Vomiting / வாந்தி","3. Discharge from surgical site / அறுவை சிகிச்சை தளத்தில் இருந்து வெளியேற்றம்","4.Obstipation / கடும் மலச்சிக்கல்","5. Swelling / வீக்கம் "]
    var Open_Mesh_repairArray = ["1. Fever / காய்ச்சல்","2. Vomiting / வாந்தி","3. Discharge from surgical site / அறுவை சிகிச்சை தளத்தில் இருந்து வெளியேற்றம்","4.Obstipation / கடும் மலச்சிக்கல்","5. Swelling / வீக்கம் "]
    var Excision_and_biopsyArray = ["1. Fever / காய்ச்சல்","2. Discharge from surgical site / அறுவை சிகிச்சை தளத்தில் இருந்து வெளியேற்றம்","3. Swelling / வீக்கம் ","4. Pain at surgical site / அறுவை சிகிச்சை தளத்தில் வலி"]
    
    var formData : [String: Any] = [:]
    var patientId = UserDefaultsManager.shared.getPatientId() ?? ""
    var symptomsName = ""
    var selectedTag: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if symptomsName == "Laparoscopic appendicectomy"{
            symptomsArray = Laparoscopic_appendicectomyArray
           
        }else if symptomsName == "Open appendicectomy"{
            symptomsArray = Open_appendicectomyArray
            
        }else if symptomsName == "Incision and Drainage"{
            symptomsArray = Incision_and_DrainageArray
            
        }else if symptomsName == "Resection anastamosis"{
            symptomsArray = Resection_anastamosisArray
            
        }else if symptomsName == "Omental Patch Repair"{
            symptomsArray = Omental_Patch_RepairArray
            
        }else if symptomsName == "Conservative management"{
            symptomsArray = Conservative_managementArray
            
        }else if symptomsName == "Laparoscopic mesh repair"{
            symptomsArray = Laparoscopic_mesh_repairArray
            
        }else if symptomsName == "Open Mesh repair"{
            symptomsArray = Open_Mesh_repairArray
            
        }else if symptomsName == "Excision and biopsy"{
            symptomsArray = Excision_and_biopsyArray
            
        }else{
            showAlert(title: "Error", message: "Log out and log in again", okActionHandler: {
                self.navigationController?.popViewController(animated: true)
            })
        }
        
    }
   
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
            postApi()
        }
    
}
extension SymptomsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return symptomsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = symptomsTableview.dequeueReusableCell(withIdentifier: "SymtomsTableViewCell", for: indexPath) as! SymtomsTableViewCell
        cell.nameLabel.text = symptomsArray[indexPath.row]
        cell.checkBoxButton.tag = indexPath.row
        cell.checkBoxButton.addTarget(self, action: #selector(checkboxButtonTapped(_:)), for: .touchUpInside)
        
        // Set the image based on the button's tag
        if let selectedTag = selectedTag, selectedTag == indexPath.row {
            cell.checkBoxButton.setImage(UIImage(named: "checked"), for: .normal)
        } else {
            cell.checkBoxButton.setImage(UIImage(named: "unchecked"), for: .normal)
        }
        
        return cell
    }
    @objc func checkboxButtonTapped(_ sender: UIButton) {
        let symptom = symptomsArray[sender.tag]
        let processedSymptom = processSymptomName(symptom)

        if sender.currentImage == UIImage(named: "checked") {
            sender.setImage(UIImage(named: "unchecked"), for: .normal)
            formData.removeValue(forKey: processedSymptom) 
        } else {
            sender.setImage(UIImage(named: "checked"), for: .normal)
            formData[processedSymptom] = 1 
        }
        print(formData)
    }

    private func processSymptomName(_ name: String) -> String {
        // Remove numbers, special characters, and non-ASCII characters, convert to lowercase, and replace spaces with underscores
        let cleanedName = name.replacingOccurrences(of: "[^a-zA-Z ]", with: "", options: .regularExpression)
        let processedName = cleanedName.lowercased().trimmingCharacters(in: .whitespaces)
        return processedName.replacingOccurrences(of: " ", with: "_")
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
extension SymptomsVC {
    func postApi() {
        startIndicator()
        var combineFormData = formData.merging(["patient_id": patientId, "other_text": otherTextView.text ?? ""]) { (current, _) in current }

        
        let apiHandler = APIHandler()
        apiHandler.postAPIValues(type: loginModel.self, apiUrl: ApiList.symptomsURL, method: "POST", formData: combineFormData) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async { [self] in
                    self.stopIndicator()
                    showAlert(title: "Success", message: data.message, okActionHandler: {
                        self.navigationController?.popViewController(animated: true)
                })
                  
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async { [weak self] in
                    self?.stopIndicator()
                    self?.showAlert(title: "Failure", message: "Something Went Wrong", okActionHandler: {})
                }
            }
        }
    }
}
