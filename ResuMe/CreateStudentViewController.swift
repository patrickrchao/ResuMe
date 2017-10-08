//
//  CreateStudentViewController.swift
//  ResuMe
//
//  Created by Alex Chan on 10/7/17.
//  Copyright © 2017 HAP. All rights reserved.
//

import Foundation
import UIKit

class CreateStudentViewController: UIViewController, UITextFieldDelegate {
    //MARK: Properties
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var year: UITextField!
    @IBOutlet weak var university: UITextField!
    @IBOutlet weak var error: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstname.delegate = self
        lastname.delegate = self
        email.delegate = self
        password.delegate = self
        year.delegate = self
        university.delegate = self
        
    }

    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Actions
    @IBAction func submit(_ sender: Any) {
        if firstname.text!.isEmpty || lastname.text!.isEmpty || email.text!.isEmpty || password.text!.isEmpty || year.text!.isEmpty || university.text!.isEmpty {
            error.text = "Fill out all fields to continue"
        } else {
            error.text = ""
            print("We made it")
            let endpoint: String = "https://datastore.googleapis.com/v1/projects/resume-182211:commit"
            guard let datastoreURL = URL(string: endpoint) else {
                print("Error: cannot create URL")
                return
            }
            var postData = URLRequest(url: datastoreURL)
            postData.httpMethod = "POST"
            print(postData)
            let student: [String: Any] = ["firstname": firstname.text!, "lastname":lastname.text!, "email": email.text!, "password": password.text!, "School Year": year.text!, "University": university.text!]
            let jsonData : Data
            do {
                jsonData = try JSONSerialization.data(withJSONObject: student, options:[])
                postData.httpBody = jsonData
            } catch {
                print("Parsing Error")
                return
            }
            print(jsonData)
            let session = URLSession.shared
            print(session)
            let task = session.dataTask(with: postData) {_, _, _ in}
            task.resume()
            
        }
    }
    
}
