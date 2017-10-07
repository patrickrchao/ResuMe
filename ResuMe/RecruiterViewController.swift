//
//  ViewController.swift
//  ResuMe
//
//  Created by Patrick Chao on 10/6/17.
//  Copyright © 2017 HAP. All rights reserved.
//

import UIKit

class RecruiterViewController: UIViewController, UITextFieldDelegate {
    
    @IBAction func ScanResume(_ sender: UIButton) {
         self.performSegue(withIdentifier: "QRSegue",sender: self)
    }

        
        
    override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
            
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


