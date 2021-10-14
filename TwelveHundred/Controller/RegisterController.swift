//
//  RegisterController.swift
//  TwelveHundred
//
//  Created by Mas'ud on 7/1/21.
//

import UIKit
import Firebase

class RegisterController: UIViewController {
    
    @IBOutlet var signUpBtn:UIButton!
    @IBOutlet var FullNameField:UITextField!
    @IBOutlet var EmailField:UITextField!
    @IBOutlet var UsernameField:UITextField!
    @IBOutlet var PasswordField:UITextField!
    @IBOutlet var CpasswordField:UITextField!
    
    let spinningCircleView = SpinningCircleView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        spinningCircleView.startAnimating()
        self.view.isUserInteractionEnabled = false
        if (FullNameField.text! == "" || EmailField.text! == "" || UsernameField.text! == "" || PasswordField.text! == "" || CpasswordField.text! == ""){
            spinningCircleView.stopAnimating()
            self.view.isUserInteractionEnabled = true
            self.view.showToast(toastMessage: "Please fill out all fields", duration: 3)
        }else if(PasswordField.text != CpasswordField.text){
            spinningCircleView.stopAnimating()
            self.view.isUserInteractionEnabled = true
            self.view.showToast(toastMessage: "Please check both password fields", duration: 3)
        }else{
            checkCred()
        }
    }
    
    func configureSpinner() {
        spinningCircleView.frame = CGRect(x: view.center.x - 50, y: view.center.y - 50, width: 60, height: 60)
        self.view.addSubview(spinningCircleView)
        spinningCircleView.hidesWhenStopped = true
    }
    
    func checkCred(){
        let email = EmailField.text!
        //let Fullname = FullNameField.text!
        let username = UsernameField.text!
        //let password = PasswordField.text!
        
        let ref = Database.database().reference()
        
        ref.observeSingleEvent(of: .value, with: {snapshot in
            
            if (snapshot.childSnapshot(forPath: "Users").hasChild(email.replacingOccurrences(of: ".", with: ""))){
                self.spinningCircleView.stopAnimating()
                self.view.isUserInteractionEnabled = true
                self.view.showToast(toastMessage: "User email already exist", duration: 3)
            }else if snapshot.childSnapshot(forPath: "Usernames").hasChild(username){
                self.spinningCircleView.stopAnimating()
                self.view.isUserInteractionEnabled = true
                self.view.showToast(toastMessage: "Username is taken", duration: 3)
            }else{
                self.signUp()
            }
        })
        
    }
    
    func signUp(){
        let email = EmailField.text!
        let emailMan = email.replacingOccurrences(of: ".", with: "")
        let Fullname = FullNameField.text!
        let username = UsernameField.text!
        let password = PasswordField.text!
        
        Auth.auth().createUser(withEmail: email, password: password, completion: {authResult, error in
            if error != nil{
                self.spinningCircleView.stopAnimating()
                self.view.isUserInteractionEnabled = true
                self.view.showToast(toastMessage: "Authentication unsuccessful: \(error!.localizedDescription)", duration: 4)
            }else{
                let uid = authResult!.user.uid
                let cred = ["UserID":uid, "address":"default", "delieveryPhone":"default","Email":email, "name":Fullname, "password":password, "phone":"default", "profile_image":"default", "username":username]
                let rootref = Database.database().reference()
                rootref.child("Users").child(emailMan).setValue(cred, withCompletionBlock: {error, ref in
                    if error != nil{
                        self.spinningCircleView.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        self.view.showToast(toastMessage: "Registration unsuccessful: \(error!.localizedDescription)", duration: 4)
                    }else{
                        self.view.showToast(toastMessage: "Registration Successful", duration: 4)
                        rootref.child("Usernames").updateChildValues(["username":username])
                        let currentUser = Users(phone: "default", name: Fullname, email: email, password: password, username: username, profileImage: "default", delieveryPhone: "default", address: "default", userID: uid)
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
                    }
                })
            }
        })
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        signUpBtn.backgroundColor = UIColor(red: 186/255, green: 186/255, blue: 186/255, alpha: 1.0)
        signUpBtn.layer.cornerRadius = signUpBtn.frame.height/2
        
        FullNameField.layer.borderColor = UIColor.black.cgColor
        FullNameField.layer.borderWidth = 1/UIScreen.main.nativeScale
        FullNameField.layer.cornerRadius = 8
        FullNameField.backgroundColor = .clear
        
        EmailField.layer.borderColor = UIColor.black.cgColor
        EmailField.layer.borderWidth = 1/UIScreen.main.nativeScale
        EmailField.layer.cornerRadius = 8
        EmailField.backgroundColor = .clear
        
        UsernameField.layer.borderColor = UIColor.black.cgColor
        UsernameField.layer.borderWidth = 1/UIScreen.main.nativeScale
        UsernameField.layer.cornerRadius = 8
        UsernameField.backgroundColor = .clear
        
        PasswordField.layer.borderColor = UIColor.black.cgColor
        PasswordField.layer.borderWidth = 1/UIScreen.main.nativeScale
        PasswordField.layer.cornerRadius = 8
        PasswordField.backgroundColor = .clear
        
        CpasswordField.layer.borderColor = UIColor.black.cgColor
        CpasswordField.layer.borderWidth = 1/UIScreen.main.nativeScale
        CpasswordField.layer.cornerRadius = 8
        CpasswordField.backgroundColor = .clear
        
        configureSpinner()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
