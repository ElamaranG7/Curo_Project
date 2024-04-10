import UIKit

protocol SideMenuTap {
    func sendVc(int: Int)
}

class SIdeMenuController: BasicViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var SideMenu: UIView!
    
    var delegate: SideMenuTap!
    var name = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(name)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
              self.view.addGestureRecognizer(tapGestureRecognizer)
              tapGestureRecognizer.delegate = self
    }
    
    @IBAction func AppoinmentsTap(_ sender: Any) {
        delegate?.sendVc(int: 0)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func MyprofileTap(_ sender: Any) {
        delegate?.sendVc(int: 1)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func LogoutTap(_ sender: Any) {
        delegate?.sendVc(int: 2)
        self.dismiss(animated: false, completion: nil)
    }
    
@objc func handleTap(_ sender: UITapGestureRecognizer) {
    self.dismiss(animated: false, completion: nil)
   }
    
}
