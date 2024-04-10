import UIKit

class DoctorDashboardVC: BasicViewController, SideMenuTap {
    
    @IBOutlet weak var patientListTable: UITableView! {
        didSet {
            patientListTable.delegate = self
            patientListTable.dataSource = self
            patientListTable.register(UINib(nibName: "PatientListTableViewCell", bundle: nil), forCellReuseIdentifier: "PatientListTableViewCell")
        }
    }
    
    @IBOutlet weak var notificationListTable: UITableView! {
        didSet {
            notificationListTable.delegate = self
            notificationListTable.dataSource = self
            notificationListTable.register(UINib(nibName: "NotificationsTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationsTableViewCell")
        }
    }
    
    var notificationListData: [NotifactionListData] = []
    var patientListData: [PatientListData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getApi()
    }
    
    @IBAction func sidemenuBar(_ sender: Any) {
        guard let sideMenuController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SIdeMenuController") as? SIdeMenuController else {
            return
        }
        sideMenuController.delegate = self
        sideMenuController.modalPresentationStyle = .overFullScreen
        self.present(sideMenuController, animated: false, completion: nil)
    }
    
    @IBAction func addPatientButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddpatientVC") as! AddpatientVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func notificationButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func myPatientListButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MyPatientsVC") as! MyPatientsVC
        navigationController?.pushViewController(vc, animated: true)
    }
   
    
    // MARK: - SideMenuTap
    
    func sendVc(int: Int) {
        // Handle the selection of menu items from the side menu
        switch int {
        case 0:
            navigateToAppointments()
        case 1:
            navigateToMyProfile()
        case 2:
            navigateToLogout()
        default:
            break
        }
    }

    private func navigateToAppointments() {
        let appointmentsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppoinmentStatusVC") as! AppoinmentStatusVC
        navigationController?.pushViewController(appointmentsVC, animated: true)
    }

    private func navigateToMyProfile() {
        let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DoctorProfileVC") as! DoctorProfileVC
        navigationController?.pushViewController(profileVC, animated: true)
    }
    private func navigateToLogout() {
        let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        navigationController?.pushViewController(profileVC, animated: true)
    }

}

// MARK: API Call

extension DoctorDashboardVC {
    func getApi() {
        startIndicator()
        
        APIHandler().postAPIValues(type: PatientListModel.self, apiUrl: ApiList.FeatchingPatientURL, method: "POST", formData: [:]) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.patientListData = data.data
                    self.patientListTable.reloadData()
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
        
        APIHandler().postAPIValues(type: NotifactionListModel.self, apiUrl: ApiList.FeatchingNotifactionURL, method: "POST", formData: [:]) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.notificationListData = data.data
                    self.notificationListTable.reloadData()
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

// MARK: TableView

extension DoctorDashboardVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == patientListTable {
            return patientListData.count
        } else {
            return notificationListData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == patientListTable {
            let cell = patientListTable.dequeueReusableCell(withIdentifier: "PatientListTableViewCell", for: indexPath) as! PatientListTableViewCell
            cell.nameLabel.text = patientListData[indexPath.row].patientName
            cell.patientIdLabel.text = patientListData[indexPath.row].patientID
            if let profileImageURL = URL(string: ApiList.baseUrl + (patientListData[indexPath.row].profileImage ?? "")) {
                loadImage(from: profileImageURL, into: cell.patientImage)
            }
            return cell
        } else {
            let cell = notificationListTable.dequeueReusableCell(withIdentifier: "NotificationsTableViewCell", for: indexPath) as! NotificationsTableViewCell
            cell.nameLabel.text = notificationListData[indexPath.row].patientName
            cell.patientIdLabel.text = notificationListData[indexPath.row].patientID
            cell.notificationsLabel.text = notificationListData[indexPath.row].notifications
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == patientListTable {
            let vc = storyboard?.instantiateViewController(withIdentifier: "PatientDetailsVC") as! PatientDetailsVC
            vc.patientId = patientListData[indexPath.row].patientID ?? ""
            navigationController?.pushViewController(vc, animated: true)
        } else {
            // Handle notification cell selection
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == patientListTable {
            return 80.0
        } else {
            return 140.0
        }
    }
}
