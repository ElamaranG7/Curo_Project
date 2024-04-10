//
//  DoctorDasboardVC.swift
//  RemainderApp
//
//  Created by SAIL on 08/03/24.
//

import UIKit

class DoctorDasboardVC: BasicViewController {

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

    var SendData: [PatientListData] = []
    var patientListData : [PatientListData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getApi()
        
    }
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func addPatientButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPatientVC") as! AddPatientVC
                    self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension DoctorDasboardVC{
    func getApi(){
        self.startIndicator()
        APIHandler().getAPIValues(type: PatientListModel.self, apiUrl: ApiList.PatientListURL  , method: "GET") { Result in
            switch Result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.patientListData = data.data
                    self.SendData = data.data
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
extension DoctorDasboardVC: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            SendData = patientListData
        } else {
            SendData = patientListData.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        patientListTable.reloadData()
    }
}
extension DoctorDasboardVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return SendData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = patientListTable.dequeueReusableCell(withIdentifier: "PatientListTableViewCell", for: indexPath) as! PatientListTableViewCell
        cell.hosptialIdLabel.text = "Hospital ID : \(SendData[indexPath.row].hospitalID)"
        cell.nameLabel.text = "Name : \(SendData[indexPath.row].name)"
        if let profileImageURL = URL(string: ApiList.baseUrl + SendData[indexPath.row].profileImage) {
            loadImage(from: profileImageURL, into: cell.patientImage)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PatientDetailsVC") as! PatientDetailsVC
        vc.hospitalId = SendData[indexPath.row].hospitalID
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}
