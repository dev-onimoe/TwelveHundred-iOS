//
//  WelcomeController.swift
//  TwelveHundred
//
//  Created by Mas'ud on 6/28/21.
//

import Foundation

import UIKit

class WelcomeController: UIViewController {

    @IBOutlet var userlogin: UIButton!
    
    @IBOutlet var userSignUp: UIButton!
    @IBOutlet var vendorSignUp: UIButton!
    
    @IBOutlet var vendorSignIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the
        userlogin.backgroundColor = UIColor(red: 186/255, green: 186/255, blue: 186/255, alpha: 1.0)
        userlogin.layer.cornerRadius = userlogin.frame.height/2
        
        
        userSignUp.backgroundColor = UIColor(red: 186/255, green: 186/255, blue: 186/255, alpha: 1.0)
        userSignUp.layer.cornerRadius = userSignUp.frame.height/2
        
        vendorSignUp.layer.borderWidth = 1/UIScreen.main.nativeScale
        vendorSignUp.layer.cornerRadius = vendorSignUp.frame.height/2
        vendorSignUp.layer.borderColor = UIColor.black.cgColor
        
        vendorSignIn.layer.borderWidth = 1/UIScreen.main.nativeScale
        vendorSignIn.layer.cornerRadius = vendorSignIn.frame.height/2
        vendorSignIn.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func loginpressed() {
        let vc = storyboard?.instantiateViewController(identifier: "login2") as! LoginController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func vendorSignup() {
        
    }
    
    @IBAction func signupPressed() {
        let vc = storyboard?.instantiateViewController(identifier: "register2") as! RegisterController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }


}

