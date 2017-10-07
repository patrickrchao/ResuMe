//
//  ViewController.swift
//  ResuMe
//
//  Created by Patrick Chao on 10/6/17.
//  Copyright © 2017 HAP. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var WelcomeLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBAction func Login(_ sender: UIButton) {
        print("received")
        if emailTextField.text == "r" {
            self.performSegue(withIdentifier: "RecruiterSegue", sender: self)
        }else if emailTextField.text == "s" {
            self.performSegue(withIdentifier: "StudentSegue", sender: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        emailTextField.delegate = self
        passwordTextField.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }

}

