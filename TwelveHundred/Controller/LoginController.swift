//
//  LoginController.swift
//  TwelveHundred
//
//  Created by Mas'ud on 6/29/21.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    
    @IBOutlet var loginBtn:UIButton!
    @IBOutlet var emailloginTextfield:UITextField!
    @IBOutlet var pwloginTextfield:UITextField!
    
    let spinningCircleView = SpinningCircleView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    
    @IBAction func loginPressed(_ sender: UIButton) {
        spinningCircleView.startAnimating()
        self.view.isUserInteractionEnabled = false
        if emailloginTextfield.text!.isEmpty || pwloginTextfield.text!.isEmpty{
            spinningCircleView.stopAnimating()
            self.view.isUserInteractionEnabled = true
            self.view.showToast(toastMessage: "Please fill out all fields", duration: 4)
        }else{
            validateCred()
        }
    }
    
    func validateCred(){
        let email = emailloginTextfield.text
        let pass = pwloginTextfield.text
        let emailMan = email!.replacingOccurrences(of: ".", with: "")
        
        Auth.auth().signIn(withEmail: email!, password: pass!, completion: {authResult, error in
            if error == nil && authResult != nil{
                let rootRef = Database.database().reference()
                rootRef.observeSingleEvent(of: .value, with: {snapshot in
                    if (snapshot.childSnapshot(forPath: "Users").hasChild(emailMan)){
                        let pwCheck = snapshot.childSnapshot(forPath: "Users").childSnapshot(forPath: emailMan).childSnapshot(forPath: "password").value as! String
                        if pass == pwCheck{
                            let name = snapshot.childSnapshot(forPath: "Users").childSnapshot(forPath: emailMan).childSnapshot(forPath: "name").value as! String
                            let email = snapshot.childSnapshot(forPath: "Users").childSnapshot(forPath: emailMan).childSnapshot(forPath: "email").value as! String
                            let phone = snapshot.childSnapshot(forPath: "Users").childSnapshot(forPath: emailMan).childSnapshot(forPath: "phone").value as! String
                            let password = pwCheck
                            let username = snapshot.childSnapshot(forPath: "Users").childSnapshot(forPath: emailMan).childSnapshot(forPath: "username").value as! String
                            let profileImage = snapshot.childSnapshot(forPath: "Users").childSnapshot(forPath: emailMan).childSnapshot(forPath: "profile_image").value as! String
                            let delieveryPhone = snapshot.childSnapshot(forPath: "Users").childSnapshot(forPath: emailMan).childSnapshot(forPath: "delieveryphone").value as! String
                            let address = snapshot.childSnapshot(forPath: "Users").childSnapshot(forPath: emailMan).childSnapshot(forPath: "address").value as! String
                            let uID = snapshot.childSnapshot(forPath: "Users").childSnapshot(forPath: emailMan).childSnapshot(forPath: "Userid").value as! String
                            
                            let currentUser = Users(phone: phone, name: name, email: email, password: password, username: username, profileImage: profileImage, delieveryPhone: delieveryPhone, address: address, userID: uID)
                            let data = try? JSONEncoder().encode(currentUser)
                            if UserDefaults.standard.object(forKey: "currentUser") != nil{
                                UserDefaults.standard.removeObject(forKey: "currentUser")
                                UserDefaults.standard.set(data, forKey: "currentUser")
                            }else{
                                UserDefaults.standard.set(data, forKey: "currentUser")
                            }
                            let vc = self.storyboard!.instantiateViewController(identifier: "tabbar") as! UITabBarController
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true)
                        }else{
                            self.spinningCircleView.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            self.view.showToast(toastMessage: "Incorrect password, please try again", duration: 4)
                        }
                        
                    }else{
                        self.spinningCircleView.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        self.view.showToast(toastMessage: "User does not exist, Please sign up", duration: 4)
                    }
                })
            }else{
                self.spinningCircleView.stopAnimating()
                self.view.isUserInteractionEnabled = true
                self.view.showToast(toastMessage: "Authentication Unsuccesful", duration: 4)
            }
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the
        
        loginBtn.backgroundColor = UIColor(red: 186/255, green: 186/255, blue: 186/255, alpha: 1.0)
        loginBtn.layer.cornerRadius = loginBtn.frame.height/2
        
        emailloginTextfield.layer.borderWidth = 1/UIScreen.main.nativeScale
        emailloginTextfield.layer.borderColor = UIColor.black.cgColor
        emailloginTextfield.backgroundColor = .clear
        emailloginTextfield.layer.cornerRadius = 8
        
        pwloginTextfield.layer.borderWidth = 1/UIScreen.main.nativeScale
        pwloginTextfield.backgroundColor = .clear
        pwloginTextfield.layer.borderColor = UIColor.black.cgColor
        pwloginTextfield.layer.cornerRadius = 8
    }
}
