//
//  ViewController.swift
//  push
//
//  Created by Karthik Iyer on 13/12/22.
//

import UIKit
import CleverTapSDK
import CTTemplates

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtIdentity: UITextField!
    
    @IBOutlet weak var txtMobileNumber: UITextField!
    
    @IBOutlet weak var txtBottomEditText: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    let center  = UNUserNotificationCenter.current()
    
    var coachmarksData: [(targetView: UIView, title: String, message: String)] = []
    var currentCoachmarkIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CleverTap.autoIntegrate()
        CleverTap.setDebugLevel(3)
        
        txtName.delegate = self
        txtEmail.delegate = self
        txtIdentity.delegate = self
        txtMobileNumber.delegate = self
        
        txtName.accessibilityIdentifier = "txtName"
        txtEmail.accessibilityIdentifier = "txtEmail"
        txtMobileNumber.accessibilityIdentifier = "txtMobileNumber"
        btnLogin.accessibilityIdentifier = "btnLogin"
        txtBottomEditText.accessibilityIdentifier = "txtBottomEditText"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showCoachmarks()
        }
    }
    
    func showCoachmarks() {
        let coachmarksJson: [[String: Any]] = [
            ["targetViewId": "txtName", "title": "Name?", "message": "Use this to enter your name"],
            ["targetViewId": "txtEmail", "title": "Email?", "message": "Use this to enter your email"],
            ["targetViewId": "txtMobileNumber", "title": "Mobile Number?", "message": "Use this to enter your mobile number"],
            ["targetViewId": "btnLogin", "title": "Submit?", "message": "Tap this to submit your details"],
            ["targetViewId": "txtBottomEditText", "title": "Bottom text?", "message": "Use this to enter your bottom text"]
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: coachmarksJson, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            CoachmarkManager.shared.showCoachmarks(fromJson: jsonString, in: self.view)
        } catch {
            print("Error serializing JSON: \(error)")
        }
        
    }
    
    @IBAction func btnClickLogin(_ sender: UIButton) {
        let profile: Dictionary<String, Any> = [
            "Name": txtName.text!,
            "Identity": txtIdentity.text!,
            "Email": txtEmail.text!,
            "Phone": "+91"+txtMobileNumber.text!,
            "MSG-email": true,
            "MSG-push": true,
            "MSG-sms": true,
            "MSG-whatsapp": true
        ]
        CleverTap.sharedInstance()?.onUserLogin(profile)
        
        let defaults = UserDefaults(suiteName: "group.clevertapTest")
        defaults!.set(txtEmail.text!, forKey: "userEmailID")
        defaults!.set(txtIdentity.text!, forKey: "userIdentity")
        defaults!.set(txtMobileNumber.text!, forKey: "userMobileNumber")
        
        self.showToast(message: "Logged In!", font: .systemFont(ofSize: 12.0))
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeScreenViewController") as? HomeScreenViewController {
            // Push the HomeScreenViewController
            self.navigationController?.pushViewController(homeVC, animated: true)
        }
        
    }
    
    @IBAction func btnLoginClicked(_ sender: UIButton) {
        let profile: Dictionary<String, Any> = [
            "Name": txtName.text!,
            "Identity": txtIdentity.text!,
            "Email": txtEmail.text!,
            "Phone": "+91"+txtMobileNumber.text!,
            "MSG-email": true,
            "MSG-push": true,
            "MSG-sms": true,
            "MSG-whatsapp": true
        ]
        CleverTap.sharedInstance()?.onUserLogin(profile)
        
        let defaults = UserDefaults(suiteName: "group.clevertapTest")
        defaults!.set(txtEmail.text!, forKey: "userEmailID")
        defaults!.set(txtIdentity.text!, forKey: "userIdentity")
        defaults!.set(txtMobileNumber.text!, forKey: "userMobileNumber")
        
        self.showToast(message: "Logged In!", font: .systemFont(ofSize: 12.0))
        
        let namestoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = namestoryboard.instantiateViewController(withIdentifier: "HomeScreenViewController") as! HomeScreenViewController
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func pushProfileBtn(_ sender: UIButton) {
        let profile: Dictionary<String, Any> = [
            "Name": txtName.text!,
            "Identity": txtIdentity.text!,
            "Email": txtEmail.text!,
            "Phone": txtMobileNumber.text!,
            "MSG-email": true,
            "MSG-push": true,
            "MSG-sms": true,
            "MSG-whatsapp": true
        ]
        CleverTap.sharedInstance()?.profilePush(profile)
        
        self.showToast(message: "Push Profile Clicked!", font: .systemFont(ofSize: 12.0))
        
        let namestoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = namestoryboard.instantiateViewController(withIdentifier: "HomeScreenViewController") as! HomeScreenViewController
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func showToast(message : String, font: UIFont) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}

extension ViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
