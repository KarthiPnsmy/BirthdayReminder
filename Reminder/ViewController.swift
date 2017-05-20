//
//  ViewController.swift
//  Reminder
//
//  Created by Karthi Ponnusamy on 19/4/17.
//  Copyright © 2017 Karthi Ponnusamy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    var loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.addSubview(loginButton)
        loginButton.center = view.center
        loginButton.delegate = self

        
        if let token = FBSDKAccessToken.current(){
            fetchProfile()
        }
        
    }
    
    func fetchProfile(){
        print("fetchProfile")
        let parameters = ["fields":"email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) in
            if error != nil {
                print("error fetchProfile")
                return
            }
            
            if let dict = result as? NSDictionary, let email = dict["email"] as? String{
                print("email \(email)")
                print("result \(result)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!){
        
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!){
        
    }

    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
}

