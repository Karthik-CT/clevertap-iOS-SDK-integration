//
//  ViewController.swift
//  push
//
//  Created by Karthik Iyer on 13/12/22.
//

import UIKit
import CleverTapSDK

class ViewController: UIViewController {
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtIdentity: UITextField!
    
    @IBOutlet weak var txtMobileNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CleverTap.autoIntegrate()
        CleverTap.setDebugLevel(3)
        
        txtName.delegate = self
        txtEmail.delegate = self
        txtIdentity.delegate = self
        txtMobileNumber.delegate = self
    }
    

    @IBAction func btnLoginClicked(_ sender: UIButton) {
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
        CleverTap.sharedInstance()?.onUserLogin(profile)
        
        self.showToast(message: "Logged In!", font: .systemFont(ofSize: 12.0))
        
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
