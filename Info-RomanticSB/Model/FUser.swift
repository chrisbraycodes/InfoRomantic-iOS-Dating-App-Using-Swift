//
//  FUser.swift
//  Info-RomanticSB
//
//  Created by Christopher Bray on 11/20/22.
//

import Foundation
import Firebase
import UIKit

class FUser: Equatable {
    static func == (lhs: FUser, rhs: FUser) -> Bool {
        lhs.objectId == rhs.objectId
    }
    
    let objectId: String
    var email: String
    var username: String
    var dateOfBirth: Date
    var gender: String
    var avatar: UIImage?
    var major: String
    var job: String
    var about: String
    var city: String
    var country: String
    var height: Double
    var interestedIn: String
    var avatarLink: String
    
    var likedIdArray: [String]?
    var imageLinks: [String]?
    let registeredDate = Date()
    var pushId: String?
    
    
    var userDictionary: NSDictionary {
        
        return NSDictionary(objects: [
                                    self.objectId,
                                    self.email,
                                    self.username,
                                    self.dateOfBirth,
                                    self.gender,
                                    self.major,
                                    self.job,
                                    self.about,
                                    self.city,
                                    self.country,
                                    self.height,
                                    self.interestedIn,
                                    self.avatarLink,
                                    self.likedIdArray ?? [],
                                    self.imageLinks ?? [],
                                    self.registeredDate,
                                    self.pushId ?? ""
        ],
                            
        forKeys: [nOBJECTID as NSCopying,
                  nEMAIL as NSCopying,
                  nUSERNAME as NSCopying,
                  nDATEOFBIRTH as NSCopying,
                  nGENDER as NSCopying,
                  nMAJOR as NSCopying,
                  nJOB as NSCopying,
                  nABOUT as NSCopying,
                  nCITY as NSCopying,
                  nCOUNTRY as NSCopying,
                  nHEIGHT as NSCopying,
                  nINTERESTEDIN as NSCopying,
                  nAVATARLINK as NSCopying,
                  nLIKEDIDARRAY as NSCopying,
                  nIMAGELINKS as NSCopying,
                  nREGISTEREDDATE as NSCopying,
                  nPUSHID as NSCopying,
            ])
    }
    
    //MARK: -Inits
    
    init(_objectId: String, _email: String, _username: String, _city: String, _dateOfBirth: Date, _gender: String, _avatarLink: String = "" ) {
        
        objectId = _objectId
        email = _email
        username = _username
        dateOfBirth = _dateOfBirth
        gender = _gender
        major = ""
        job = ""
        about = ""
        city = _city
        country = ""
        height = 0.0
        interestedIn = ""
        avatarLink = _avatarLink
        likedIdArray = []
        imageLinks = []
    }
    
    init(_dictionary: NSDictionary) {
        
        objectId = _dictionary[nOBJECTID] as? String ?? ""
        email = _dictionary[nEMAIL] as? String ?? ""
        username = _dictionary[nUSERNAME] as? String ?? ""
        gender = _dictionary[nGENDER] as? String ?? ""
        major = _dictionary[nMAJOR] as? String ?? ""
        job = _dictionary[nJOB] as? String ?? ""
        about = _dictionary[nABOUT] as? String ?? ""
        city = _dictionary[nCITY] as? String ?? ""
        country = _dictionary[nCOUNTRY] as? String ?? ""
        height = _dictionary[nHEIGHT] as? Double ?? 0.0
        interestedIn = _dictionary[nINTERESTEDIN] as? String ?? ""
        avatarLink = _dictionary[nAVATARLINK] as? String ?? ""
        likedIdArray = _dictionary[nLIKEDIDARRAY] as? [String]
        imageLinks = _dictionary[nIMAGELINKS] as? [String]
        pushId = _dictionary[nPUSHID] as? String ?? ""
        
        if let date = _dictionary[nDATEOFBIRTH] as? Timestamp {
            dateOfBirth = date.dateValue()
        } else {
            dateOfBirth = _dictionary[nDATEOFBIRTH] as? Date ?? Date()
        }
        
        var placeHolder = "fPlaceholder"
        if gender == "Female"{
            placeHolder = "fPlaceholder"
        }
        else if gender == "Male"{
            placeHolder = "mPlaceholder"
        }
        else {
            placeHolder = "nonBinaryPlaceHolder"
        }
        
        avatar = UIImage(contentsOfFile: fileInDocumentsDirectory(filename: self.objectId)) ?? UIImage(named: placeHolder)
    }
    
    //MARK: - Returning current user
    
    class func currentId() -> String {
        return Auth.auth().currentUser!.uid
    }
    
    class func currentUser() -> FUser? {
        
        if Auth.auth().currentUser != nil {
            if let userDictionary = userDefaults.object(forKey: nCURRENTUSER) {
                return FUser(_dictionary: userDictionary as! NSDictionary)
            }
        }
        return nil
    }
    
    func getUserAvatarFromFirestore(completion: @escaping (_ didSet: Bool) -> Void) {
        
        FileStorage.downloadImage(imageUrl: self.avatarLink) { (avatarImage) in
            
            let placeholder = self.gender
            self.avatar = avatarImage ?? UIImage(named: placeholder)
            
            completion(true)
        }
    }
    
    //MARK: - Login
    class func loginUserWith(email: String, password: String, completion: @escaping (_ error: Error?, _ isEmailVerified: Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            
            if error == nil {
                
                if authDataResult!.user.isEmailVerified {
                    
                    FirebaseListener.shared.downloadCurrentUserFromFirebase(userId:
                        authDataResult!.user.uid, email: email)
                    
                    completion(error, true)
                } else {
                    print("Email needs to be verified")
                    completion(error, false)
                }
            } else {
                completion(error, false)
            }
        }
    }
    
    
    //MARK: - Register
    
    class func registerUserWith(email: String, password: String, userName: String, city: String, gender: String, dateOfBirth: Date, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (authData, error) in
            
            completion(error)
            
            if error == nil {
                
                authData!.user.sendEmailVerification { (error) in
                    print("auth email verification sent", error?.localizedDescription)
                }
                
                if authData?.user != nil {
                    
                    let user = FUser(_objectId: authData!.user.uid, _email: email, _username: userName,
                        _city: city, _dateOfBirth: dateOfBirth, _gender: gender)
                    
                    user.saveUserLocally()
                }
            }
        }
    }
    
    //MARK: - Edit User profile
    
    func updateUserEmail(newEmail: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().currentUser?.updateEmail(to: newEmail, completion: { (error) in
            
            FUser.resendVerificationEmail(email: newEmail) { (error) in
                
            }
            completion(error)
        })
    }
    
    
    //MARK: - Resend Links
    
    class func resendVerificationEmail(email: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().currentUser?.reload(completion: { (error) in
            
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                    completion(error)
            })
        })
    }
    
    class func resetPassword(email: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            
            completion(error)
        }
    }
    
    //MARK: - LogOut user
    
    class func logOutCurrentUser(completion: @escaping(_ error: Error?) -> Void){
        
        do {
            try Auth.auth().signOut()
            
            userDefaults.removeObject(forKey: nCURRENTUSER)
            userDefaults.synchronize()
            completion(nil)
            
        } catch let error as NSError {
            completion(error)
        }
    }
    
    //MARK: - Save user funcs
    
    func saveUserLocally() {
        
        userDefaults.setValue(self.userDictionary as! [String : Any], forKey: nCURRENTUSER)
        userDefaults.synchronize()
        
    }
    
    func saveUserToFireStore() {
        
        FirebaseReference(.User).document(self.objectId).setData(self.userDictionary as! [String : Any]) { (error) in
            
            if error != nil {
                print(error!.localizedDescription)
            }
            
        }
    }
    
    //MARK: - Update User funcs
    
    func updateCurrentUserInFireStore(withValues: [String : Any], completion: @escaping (_ error: Error?) -> Void) {
        
        if let dictionary = userDefaults.object(forKey: nCURRENTUSER) {
            
            let userObject = (dictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
            userObject.setValuesForKeys(withValues)
            
            FirebaseReference(.User).document(FUser.currentId()).updateData(withValues) {
                error in
                
                completion(error)
                if error == nil {
                    FUser(_dictionary: userObject).saveUserLocally()
                }
            }
        }
    }

    
    
    
}


func createUsers() {
    
    let names = ["Jessie Stamp", "Arden Duggan", "Briar Thornton", "Brighton Neale", "Callaway Gates", "Cove Bate", "Cypress Tundrid", "Ever Gates", "Hollis Tumber", "Kit Scale", "Merritt Gunder", "Rory Aloom",
    "Ocean Centrey", "Revel Stormbre", "Adrian Spar", "Ariel Dunes", "Bay Kingsley", "Bobbie Fishhook", "Casey Windche", "Charlie States", "Corey Bloom"]
    
    let gender = ["Male", "Female", "Female", "Female", "Female", "Male", "Male", "Female", "Male", "Male", "Female"]
    
    var imageIndex = 1
    var userIndex = 1
    
    for i in 0..<10 {
        
        let id = UUID().uuidString

        
        let fileDirectory = "Avatars/_" + id + ".jpg"

        FileStorage.uploadImage(UIImage(named: "user\(imageIndex)")!, directory: fileDirectory) { (avatarLink) in
            
            let user = FUser(_objectId: id, _email: "user\(userIndex)@mail.com", _username: names[i], _city: "No City", _dateOfBirth: Date(), _gender: gender[i], _avatarLink: avatarLink ?? "")
            
            userIndex += 1
            user.saveUserToFireStore()
        }
     
        imageIndex += 1
        
        if imageIndex == 21 {
            imageIndex = 1
        }
        
    }

    
}




    
    
    
    
    
    

