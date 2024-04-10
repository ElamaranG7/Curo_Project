import UIKit

class ViewReportsVC: BasicViewController {
    
    @IBOutlet weak var viewReportsTable: UITableView! {
        didSet {
            viewReportsTable.delegate = self
            viewReportsTable.dataSource = self
            viewReportsTable.register(UINib(nibName: "ReportsTableViewCell", bundle: nil), forCellReuseIdentifier: "ReportsTableViewCell")
        }
    }
    
    var patientId: String = "20240310"
    var viewReportsModel: ViewReportsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getApi()
    }
    
    @IBAction func editButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PatientDetailsVC") as! PatientDetailsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func getApi() {
        self.startIndicator()
        var apiUrl = ApiList.ReportsURL + "patient_id=\(patientId)"
        APIHandler().getAPIValues(type: ViewReportsModel.self, apiUrl: apiUrl, method: "GET") { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.viewReportsModel = data
                    self.viewReportsTable.reloadData()
                    self.stopIndicator()
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self.stopIndicator()
                    self.showAlert(title: "Failure", message: "Failed to fetch reports. Please try again later.", okActionHandler: {})
                }
            }
        }
    }

}

extension ViewReportsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewReportsModel?.images.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportsTableViewCell", for: indexPath) as! ReportsTableViewCell
        
        if let image = viewReportsModel?.images[indexPath.row] {
            if let profileImageURL = URL(string: ApiList.baseUrl + image) {
                loadImage(from: profileImageURL, into: cell.reportImage)
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
        
    }
    
}
