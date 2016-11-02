//
//  ViewController.swift
//  FacebookLoginSwift3
//
//  Created by Kokpheng on 11/1/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check Session
        if let token = FBSDKAccessToken.current(){
            print(token.tokenString! as Any)
            self.fetchProfile()
        }
        
        // Default Facebook Button
        let loginButton = FBSDKLoginButton()
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        view.addSubview(loginButton)
        
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
        
        
        // Add custom fb login button
        let customFBButton = UIButton()
        customFBButton.backgroundColor = .blue
        customFBButton.frame = CGRect(x: 16, y: 116, width: view.frame.width - 32, height: 50)
        customFBButton.setTitle("Custom FB Login here", for: .normal)
        customFBButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        customFBButton.setTitleColor(.white, for: .normal)
        customFBButton.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
        view.addSubview(customFBButton)
        
        
    }
    
    // Custom method for custom fb login button
    func handleCustomFBLogin() {
        let parameters = ["email", "public_profile"]
        FBSDKLoginManager().logIn(withReadPermissions: parameters, from: self){ (result, error) in
            
            // check error
            if error != nil {
                // error happen
                print("Failed to start graph request: \(error?.localizedDescription)")
                return
            }else if (result?.isCancelled)!{
                print("Cancelled")
            }else{
                // Logged in
                if (result?.grantedPermissions.contains("public_profile"))!{
                    if let token = FBSDKAccessToken.current(){
                        print(token.tokenString! as Any)
                        self.fetchProfile()
                    }
                }
            }
        }
    }
    
    // Get Profile
    func fetchProfile() {
        print("fetch profile")
        
        // Create facebook graph with fields
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id, name, email"]).start { (connection, result, error) in
            
            // check error
            if error != nil {
                // error happen
                print("Failed to start graph request: \(error?.localizedDescription)")
                return
            }
            print(result as Any)
        }
        
        
    }
    
    // Delegate Method
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!){
        // check error
        if error != nil {
            // error happen
            print(error?.localizedDescription)
            return
        }
        
        print("Successfull login in with facebook...")
        fetchProfile()
    }
    
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!){
        print("Log Out")
    }
    
    
}

