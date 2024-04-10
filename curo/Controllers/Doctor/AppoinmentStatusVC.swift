import UIKit

class AppoinmentStatusVC: BasicViewController {
    
    @IBOutlet weak var segmentControllerOutlet: UISegmentedControl!
    @IBOutlet weak var searchBarOutlet: UISearchBar!{
        didSet{
            searchBarOutlet.delegate = self
        }
    }
    @IBOutlet weak var PendingAppoinmentsTable: UITableView!{
        didSet{
            PendingAppoinmentsTable.delegate = self
            PendingAppoinmentsTable.dataSource = self
            PendingAppoinmentsTable.register(UINib(nibName: "AppoinmentTableViewCell", bundle: nil), forCellReuseIdentifier: "AppoinmentTableViewCell")
        }
    }
    var overallData = [AppointmentsData]()
  
    var filteredOverallData: [AppointmentsData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAPI(Mode: ApiList.PendingAppoinmentsURL)
        
    }
    
    @IBAction func segmentButtonAction(_ sender: Any) {
        switch segmentControllerOutlet.selectedSegmentIndex {
        case 0:
            self.getAPI(Mode: ApiList.PendingAppoinmentsURL)
            self.PendingAppoinmentsTable.reloadData()
        case 1:
            self.getAPI(Mode: ApiList.ApprovedAppoinmentsURL)
            self.PendingAppoinmentsTable.reloadData()
        case 2:
            self.getAPI(Mode: ApiList.RejectedAppoinmentsURL)
            self.PendingAppoinmentsTable.reloadData()
        default:
            break;
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func approveButtonTapped(_ sender: UIButton) {
        let rowIndex = sender.tag
        let rowData = filteredOverallData[rowIndex]
        updateApi(PatientID: rowData.patientID, Status: "approved")
        print("Approve button tapped for appointment ID: \(rowData.patientID)")
    }

    @objc func rejectButtonTapped(_ sender: UIButton) {
        let rowIndex = sender.tag
        let rowData = filteredOverallData[rowIndex]
        updateApi(PatientID: rowData.patientID, Status: "reject")

        print("Reject button tapped for appointment ID: \(rowData.patientID)")
    }
}
extension AppoinmentStatusVC: UISearchBarDelegate {
        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchText.isEmpty {
                filteredOverallData = overallData
            } else {
                filteredOverallData = overallData.filter { $0.patientName.lowercased().contains(searchText.lowercased()) ||
                    $0.patientID.lowercased().contains(searchText.lowercased())
                }
            }
        PendingAppoinmentsTable.reloadData()
        }
    
}
extension AppoinmentStatusVC{
    func updateApi(PatientID : String,Status : String ) {
        startIndicator()
        let apiURL = ApiList.UpdateAppointmentURL
        let formData: [String: String] = [
            "patient_id": PatientID,
            "status": Status
        ]
        APIHandler().postAPIValues(type: UpdatepatientDetailsModel.self, apiUrl: apiURL, method: "POST", formData: formData) { result in
            switch result {
            case .success(let data):
                print("Status: \(data.status)")
                print("Message: \(data.message)")
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    if data.status == "success" {
                        self.showAlert(title: "Success", message: data.message, okActionHandler: {
                            self.getAPI(Mode: ApiList.PendingAppoinmentsURL)
                        })
                    } else {
                        self.showAlert(title: "Failure", message: data.message)
                    }
                    stopIndicator()
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async { [weak self] in
                    self?.stopIndicator()
                    self?.showAlert(title: "Failure", message: error.localizedDescription)
                }
            }
        }
    }
    
    func getAPI(Mode : String) {
        startIndicator()
        let apiUrl = Mode

        APIHandler().postAPIValues(type: AppointmentsModel.self, apiUrl: apiUrl, method: "POST", formData: [:]) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.searchBarOutlet.text = ""
                    self.showToast(data.message)
                    self.overallData = data.data
                    self.filteredOverallData = self.overallData
                    self.PendingAppoinmentsTable.reloadData()
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

extension AppoinmentStatusVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentControllerOutlet.selectedSegmentIndex == 0 {
            return filteredOverallData.count
        }else if segmentControllerOutlet.selectedSegmentIndex == 1{
            return filteredOverallData.count
        } else if segmentControllerOutlet.selectedSegmentIndex == 2{
            return filteredOverallData.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppoinmentTableViewCell", for: indexPath) as! AppoinmentTableViewCell
        
        cell.DateLabel.text = filteredOverallData[indexPath.row].date
        cell.PatientIdLabel.text = filteredOverallData[indexPath.row].patientID
        cell.PatientNameLabel.text = filteredOverallData[indexPath.row].patientName
        cell.StatusLabel.text = filteredOverallData[indexPath.row].status
        
        if segmentControllerOutlet.selectedSegmentIndex == 0 {
            cell.statusView.isHidden = false
            cell.StatusLabel.textColor = UIColor.blue
            cell.approveButton.addTarget(self, action: #selector(approveButtonTapped(_:)), for: .touchUpInside)
            cell.rejectButton.addTarget(self, action: #selector(rejectButtonTapped(_:)), for: .touchUpInside)
            cell.approveButton.tag = indexPath.row
            cell.rejectButton.tag = indexPath.row

        }else if segmentControllerOutlet.selectedSegmentIndex == 1 {
            cell.statusView.isHidden = true
            cell.StatusLabel.textColor = UIColor.green
        }else if segmentControllerOutlet.selectedSegmentIndex == 2 {
            cell.statusView.isHidden = true
            cell.StatusLabel.textColor = UIColor.red

        }
        return cell
    }
        
    
}

