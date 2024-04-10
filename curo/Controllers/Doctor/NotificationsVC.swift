//
//  NotificationsVC.swift
//  curo
//
//  Created by SAIL on 11/03/24.
//

import UIKit

class NotificationsVC: BasicViewController {
    
    @IBOutlet weak var searchBarOutlet: UISearchBar! {
        didSet {
            searchBarOutlet.delegate = self
        }
    }
    
    @IBOutlet weak var notifactionListTable: UITableView!{
        didSet{
            notifactionListTable.delegate = self
            notifactionListTable.dataSource = self
            notifactionListTable.register(UINib(nibName: "NotificationsTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationsTableViewCell")
        }
    }
    
    var notifactionListData : [NotifactionListData] = []
    var filteredNotifactionListData : [NotifactionListData] = []
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getApi()
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getApi(){
        self.startIndicator()
        
        APIHandler().postAPIValues(type: NotifactionListModel.self, apiUrl: ApiList.FeatchingNotifactionURL  , method: "POST", formData: [:]) { Result in
            switch Result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.notifactionListData = data.data
                    self.filteredNotifactionListData = self.notifactionListData
                    self.notifactionListTable.reloadData()
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

//MARK: TableView

extension NotificationsVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredNotifactionListData.count : notifactionListData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notifactionListTable.dequeueReusableCell(withIdentifier: "NotificationsTableViewCell", for: indexPath) as! NotificationsTableViewCell
        let notifaction = isSearching ? filteredNotifactionListData[indexPath.row] : notifactionListData[indexPath.row]
        cell.patientIdLabel.text = "\(notifaction.patientID )"
        cell.nameLabel.text = "\(notifaction.patientName)"
        cell.notificationsLabel.text = "\(notifaction.notifications)"

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PatientDetailsVC") as! PatientDetailsVC
//        vc.hospitalId = patientListData[indexPath.row].patientID
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: UISearchBarDelegate

extension NotificationsVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredNotifactionListData = notifactionListData
        } else {
            isSearching = true
            filteredNotifactionListData = notifactionListData.filter {
                ($0.patientName.lowercased().contains(searchText.lowercased())) ||
                ($0.patientID.lowercased().contains(searchText.lowercased()))
            }
        }
        notifactionListTable.reloadData()
    }
}
