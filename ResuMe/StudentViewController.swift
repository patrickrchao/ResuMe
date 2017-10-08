//
//  ViewController.swift
//  ResuMe
//
//  Created by Patrick Chao on 10/6/17.
//  Copyright © 2017 HAP. All rights reserved.
//

import UIKit
import SwiftyDropbox

class StudentViewController: UIViewController, UITextFieldDelegate,GIDSignInUIDelegate ,SelectedDropboxData{
    
    
   

    @IBAction func UploadResume(_ sender: UIButton) {
        
        if (DropboxClientsManager.authorizedClient == nil) {
            //authorize a user
            DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                          controller: self,
                                                          openURL: { (url: URL) -> Void in
                                                            UIApplication.shared.openURL(url)
            })
        }else{
            print("User is already authorized!")
            self.refreshDropboxList()
        }
   
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TableViewController"{
            let tableViewController = segue.destination  as! DBListingViewController
            tableViewController.delegate = self
            tableViewController.showDropboxData()
        }
    }
    
    func getDropboxSelectedData(_ dataArr: [String]){
        print(dataArr)
        
    }
    func refreshDropboxList() {
        self.performSegue(withIdentifier: "TableViewController", sender: nil)
    }






    @IBOutlet weak var QRImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshDropboxList), name: NSNotification.Name(rawValue: "Dropboxlistrefresh"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: "handleDidLinkNotification:", name: NSNotification.Name(rawValue: "didLinkToDropboxAccountNotification"), object: nil)
      
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
    
    
    
    
    func handleDidLinkNotification(notification: NSNotification) {
       
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



