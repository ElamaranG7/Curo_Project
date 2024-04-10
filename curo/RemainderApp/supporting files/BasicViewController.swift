//
//  BasicViewController.swift
//  Garden Management
//
//  Created by SAIL on 11/10/23.
//

import UIKit
import Charts

class BasicViewController: UIViewController {

    static let DELAY_SHORT = 1.5
    static let DELAY_LONG = 3.0
    let overlayView = UIView(frame: UIScreen.main.bounds)
    let activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()

    }
   
    
    
    //MARK: Active Indicator
    
    func startIndicator(){
        //MARK: UIView
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(overlayView)
        //MARK: Indicator
        
        activityIndicator.center = overlayView.center
        overlayView.addSubview(activityIndicator)
        activityIndicator.color = UIColor(hex: 0x006EE6)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    //MARK: removeIndicator
    func stopIndicator(){
        
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
    
    func loadImage(from url: URL, into imageView: UIImageView) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error loading image: \(error)")
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }.resume()
    }

    func showToast(_ text: String, delay: TimeInterval = DELAY_LONG) {
        let label = ToastLabel()
        label.backgroundColor = UIColor(white: 0, alpha: 1)
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        label.alpha = 0
        label.text = text
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        label.numberOfLines = 0
        label.textInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        let saveArea = view.safeAreaLayoutGuide
        label.centerXAnchor.constraint(equalTo: saveArea.centerXAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(greaterThanOrEqualTo: saveArea.leadingAnchor, constant: 15).isActive = true
        label.trailingAnchor.constraint(lessThanOrEqualTo: saveArea.trailingAnchor, constant: -15).isActive = true
        label.bottomAnchor.constraint(equalTo: saveArea.bottomAnchor, constant: -30).isActive = true

        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            label.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, delay: delay, options: .curveEaseOut, animations: {
                label.alpha = 0
            }, completion: {_ in
                label.removeFromSuperview()
            })
        })
    }
}
extension BasicViewController {
    func showAlert(title: String, message: String, okActionHandler: (() -> Void)? = nil, cancelActionHandler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // OK Action
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            okActionHandler?()
        }
        alertController.addAction(okAction)
        
        // Cancel Action (if provided)
        if let cancelActionHandler = cancelActionHandler {
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                cancelActionHandler()
            }
            alertController.addAction(cancelAction)
        }
        
        present(alertController, animated: true, completion: nil)
    }
}

class ToastLabel: UILabel {
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top, left: -textInsets.left, bottom: -textInsets.bottom, right: -textInsets.right)

        return textRect.inset(by: invertedInsets)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
}
extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

//MARK: cornerRadius
@IBDesignable class ShadowView: UIView {
    //Shadow
    @IBInspectable var shadowColor: UIColor = UIColor.gray {
        didSet {
            self.updateView()
        }
    }
    @IBInspectable var shadowOpacity: Float = 0.7 {
        didSet {
            self.updateView()
        }
    }
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 1, height: 1) {
        didSet {
            self.updateView()
        }
    }
    @IBInspectable var shadowRadius: CGFloat = 2.0 {
        didSet {
            self.updateView()
        }
    }

    //Apply params
    func updateView() {
        self.layer.shadowColor = self.shadowColor.cgColor
        self.layer.shadowOpacity = self.shadowOpacity
        self.layer.shadowOffset = self.shadowOffset
        self.layer.shadowRadius = self.shadowRadius
    }
}
extension UIView {
    func addShadow(radius: CGFloat = 0) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.shadowRadius = 2
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.cornerRadius = radius
    }
}
@IBDesignable extension UIButton {
        @IBInspectable var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue }
        get { return layer.cornerRadius }
    }
}
@IBDesignable extension UIView {
    
   
    
    @IBInspectable var cornerRadiusView: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    @IBInspectable var shadowRadiusnew :CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }
    
    
    @IBInspectable var borderWidth: CGFloat {
           set {
               layer.borderWidth = newValue
           }
           get {
               return layer.borderWidth
           }
       }
    @IBInspectable var shadowOpacitynew :CGFloat {
        set {
            layer.shadowOpacity = Float(newValue)
        }
        get {
            return CGFloat(layer.shadowOpacity)
        }
    }
    @IBInspectable var shadowOffsetnew : CGSize{
        
        get{
            return layer.shadowOffset
        }set{

            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
            set {
                guard let uiColor = newValue else { return }
                layer.borderColor = uiColor.cgColor
            }
            get {
                guard let color = layer.borderColor else { return nil }
                return UIColor(cgColor: color)
            }
        }
    @IBInspectable var shadowColornew : UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.shadowColor = uiColor.cgColor
        }
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        
    }
}

class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()

    private let userDefaults = UserDefaults.standard

    private init() {}

    // MARK: - Define Keys for Your Data
    private let userNameKey = "UserName"
    private let userIdKey = "userId"
    private let nameKey = "name"
    // MARK: - Save Data
    func saveUserName(_ name: String) {
        userDefaults.set(name, forKey: userNameKey)
    }

    func saveUserId(_ userId: String) {
        userDefaults.set(userId, forKey: userIdKey)
    }
    func savenameKey(_ userId: String) {
        userDefaults.set(userId, forKey: nameKey)
    }
    // MARK: - Retrieve Data
    func getUserName() -> String? {
        return userDefaults.string(forKey: userNameKey)
    }
    func getnamekey() -> String? {
        return userDefaults.string(forKey: nameKey)
    }
    func getUserId() -> String? {
        return userDefaults.string(forKey: userIdKey)
    }

    // MARK: - Remove Data (if needed)
    func removeUserData() {
        userDefaults.removeObject(forKey: userNameKey)
        userDefaults.removeObject(forKey: userIdKey)
    }
}
