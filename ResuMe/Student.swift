//
//  Student.swift
//  ResuMe
//
//  Created by Alex Chan on 10/8/17.
//  Copyright © 2017 HAP. All rights reserved.
//

import Foundation
import UIKit

class Student {
    var firstname: String
    var lastname: String
    var email: String
    var password: String
    var year: String
    var school: String
    var resumeLink: String
    var qr: String
    
    init!(firstname: String, lastname: String, email: String, password: String, year: String, school: String) {
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
        self.password = password
        self.year = year
        self.school = school
        self.resumeLink = ""
        self.qr = ""
    }

}
