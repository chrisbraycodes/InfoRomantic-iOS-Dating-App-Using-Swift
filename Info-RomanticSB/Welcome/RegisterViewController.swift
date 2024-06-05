//
//  RegisterViewController.swift
//  Info-RomanticSB
//
//  Created by Christopher Bray on 11/20/22.
//

import UIKit
import ProgressHUD

class RegisterViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var genderSegmentOutlet: UISegmentedControl!
    @IBOutlet var backgroundImageView: UIImageView!
    
    //MARK: -Variables
    var gender = "Female"
    
    //MARK: -ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .dark
        setupBackgroundTouch()
        
    }
    
    //MARK: IBActions
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        
        if isTextDataInput() {
            
            if passwordTextField.text! == confirmPasswordTextField.text! {
                registerUser()
            } else {
                ProgressHUD.showError("Passwords do not match!")
            }
            
        } else {
            ProgressHUD.showError("Every field required!")
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func genderSegmentValueChanged(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 1){
            gender = "Male"
        } else if (sender.selectedSegmentIndex == 2){
            gender = "Non-Binary"
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
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    private func isTextDataInput() -> Bool {
        
        return usernameTextField.text != "" && emailTextField.text != "" && cityTextField.text != "" && passwordTextField.text != "" && confirmPasswordTextField.text != ""
    }
    
    //MARK: - RegisterUser
    private func registerUser() {
        ProgressHUD.show()

        FUser.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!, userName: usernameTextField.text!, city: cityTextField.text!, gender: gender, dateOfBirth: datePicker.date, completion: {
            error in

            if error == nil {
                ProgressHUD.showSuccess("Verification email sent!")
                self.dismiss(animated: true, completion: nil)
            } else {
               ProgressHUD.showError(error!.localizedDescription)
            }
        })
    }
}
