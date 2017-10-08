//
//  ViewController.swift
//  ResuMe
//
//  Created by Patrick Chao on 10/6/17.
//  Copyright © 2017 HAP. All rights reserved.
//

import UIKit
import SwiftyDropbox
class StudentViewController: UIViewController, UITextFieldDelegate,GIDSignInUIDelegate {

    @IBAction func UploadResume(_ sender: UIButton) {
        
        DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                      controller: self,
                                                      openURL: { (url: URL) -> Void in
                                                        UIApplication.shared.openURL(url)
        })
    }
    
    
    @IBOutlet weak var QRImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        let myString = "http://www.eaze.com"
        
        let data = myString.data(using: .ascii, allowLossyConversion:  false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        
        let ciImage = filter?.outputImage
        
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let transformImage = ciImage?.applying(transform)
        
        let image = UIImage(ciImage: transformImage!)
        QRImage.image = image
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    @IBAction func didTapSignOut(sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
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



