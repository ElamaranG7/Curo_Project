//
//  MyPatientsVC.swift
//  curo
//
//  Created by SAIL on 11/03/24.
//

import UIKit

class MyPatientsVC: BasicViewController {
    
    @IBOutlet weak var searchBarOutlet: UISearchBar! {
        didSet {
            searchBarOutlet.delegate = self
        }
    }
    
    @IBOutlet weak var patientListTable: UITableView!{
        didSet{
            patientListTable.delegate = self
            patientListTable.dataSource = self
            patientListTable.register(UINib(nibName: "PatientListTableViewCell", bundle: nil), forCellReuseIdentifier: "PatientListTableViewCell")
        }
    }
    
    var patientListData: [PatientListData] = []
    var filteredPatientListData: [PatientListData] = []
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getApi()
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getApi() {
        self.startIndicator()
        
        APIHandler().postAPIValues(type: PatientListModel.self, apiUrl: ApiList.FeatchingPatientURL  , method: "POST", formData: [:]) { Result in
            switch Result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.patientListData = data.data
                    self.filteredPatientListData = self.patientListData
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
    }
}

// MARK: TableView

extension MyPatientsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredPatientListData.count : patientListData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = patientListTable.dequeueReusableCell(withIdentifier: "PatientListTableViewCell", for: indexPath) as! PatientListTableViewCell
        let patient = isSearching ? filteredPatientListData[indexPath.row] : patientListData[indexPath.row]
        cell.patientIdLabel.text = "Patient ID : \(patient.patientID ?? "")"
        cell.nameLabel.text = "Name : \(patient.patientName)"
        if let profileImageURL = URL(string: ApiList.baseUrl + (patient.profileImage ?? "")) {
            loadImage(from: profileImageURL, into: cell.patientImage)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PatientDetailsVC") as! PatientDetailsVC
        let patient = isSearching ? filteredPatientListData[indexPath.row] : patientListData[indexPath.row]
        vc.patientId = patient.patientID!
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}

// MARK: UISearchBarDelegate

extension MyPatientsVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredPatientListData = patientListData
        } else {
            isSearching = true
            filteredPatientListData = patientListData.filter {
                ($0.patientName.lowercased().contains(searchText.lowercased())) ||
                ($0.patientID?.lowercased().contains(searchText.lowercased()) ?? false)
            }
        }
        patientListTable.reloadData()
    }
}
