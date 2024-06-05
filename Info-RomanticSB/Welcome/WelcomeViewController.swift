//
//  WelcomeViewController.swift
//  Info-RomanticSB
//
//  Created by Christopher Bray on 11/20/22.
//

import UIKit
import ProgressHUD

class WelcomeViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var backgroundImageView: UIImageView!
    
    //MARK: -ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .dark
        setupBackgroundTouch()
    }
    
    //MARK: -IBActions

    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        if emailTextField.text != "" {
            
            FUser.resetPassword(email: emailTextField.text!) { (error) in
                
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                } else {
                    ProgressHUD.showSuccess("Please check your email!")
                }
            }
              
        } else {
            ProgressHUD.showError("Please input your email address.")
        }
    }
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            ProgressHUD.show()
            
            FUser.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) {
                (error, isEmailVerified) in
                
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                } else if isEmailVerified {
                    
                    ProgressHUD.dismiss()
                    self.goToApp()
                } else {
                    ProgressHUD.showError("Email verification necessary to proceed")
                }
            }
            
        } else {
            ProgressHUD.showError("All fields are needed!")
        }
    }
        
    //MARK: -Setup
    private func setupBackgroundTouch() {
        backgroundImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        backgroundImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func backgroundTap() {
        dismissKeyboard()
    }
    
    //MARK: - Helpers
    private func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    //MARK: - Navigation
    private func goToApp() {
        
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "MainView") as! UITabBarController
        
        mainView.modalPresentationStyle = .fullScreen
        self.present(mainView, animated: true, completion: nil)
        
    }
}
