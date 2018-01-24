//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by HarryZen on 2018/1/19.
//  Copyright © 2018年 harry. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var debugTextView: UITextView!
    var appDelegate: AppDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
    
    }
    
    @IBAction func logInUdacity(sender: AnyObject){
        guard let userName = userNameTextField.text, userName != "" else {
            debugTextView.text = "Email can't be empty."
            return
        }
        
        guard let password = passwordTextField.text, password != "" else {
            debugTextView.text = "Password can't be empty."
            return
        }
        OTMClient.sharedInstance().udacityPOSTSession(userName: userName, password: password){(success, sessionID, error) in
            if error != nil {
                print(error)
                DispatchQueue.main.async {
                    self.debugTextView.text = "LogIn failed."
                }
            }else {
                if success {
                    if let sessionID = sessionID {
                        OTMClient.sharedInstance().sessionID = sessionID
                        print(sessionID)
                        OTMClient.sharedInstance().getStudentLocation((["limit":"10"]) as! [String : AnyObject]){(success, studentsLocations, error) in
                            if error != nil {
                                print("\(error)")
                            }else {
                                if success {
                                    DispatchQueue.main.async {
                                        let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                                        let mkMapViewController = self.storyboard?.instantiateViewController(withIdentifier: "MKMapViewController") as! MKMapViewController
                                        if let locations = studentsLocations{
                                            for location in locations {
                                                if location.count == 10 {
                                                    self.appDelegate.locations.append(location)
                                                }
                                            }
                                            self.present(tabBarController, animated: true, completion: nil)
                                        }
                                    }
                                   
                                }
                            }
                        }
                    }
                }else {
                        print("There is no sessionID")
                }
            }
        }
    }
}
