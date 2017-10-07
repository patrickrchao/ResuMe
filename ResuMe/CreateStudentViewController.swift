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
            let student: [String: Any] = [
                //"key": "AIzaSyD2U7K6744gP8uUuqdyVLyPjfbpRZ2c6xc",
                "mutations": ["firstname": firstname.text!, "lastname":lastname.text!, "email": email.text!, "password": password.text!, "School Year": year.text!, "University": university.text!],
                "transaction": "string"
            ]
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
            let task = URLSession.shared.dataTask(with: postData) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                }
                
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
            }
            task.resume()
            
        }
    }
    
}
