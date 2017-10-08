//
//  StudentTableViewController.swift
//  ResuMe
//
//  Created by Alex Chan on 10/8/17.
//  Copyright © 2017 HAP. All rights reserved.
//

import UIKit

class StudentTableViewController: UITableViewController {
    //MARK: Properties
    var students = [Student]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadStudents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid = "StudentTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as? StudentTableViewCell  else {
            fatalError("The dequeued cell is not an instance of StudentTableViewCell.")
        }
        let student = students[indexPath.row]

        cell.name?.text = student.firstname
        return cell
    }
 
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    private func loadStudents() {
        
        guard let s1 = Student(firstname: "Alex", lastname: "Chan", email: "alex@berkeley.edu", password: "a", year: "Junior", school: "UC Berkeley") else {
            fatalError("Unable to instantiate")
        }
        guard let s2 = Student(firstname: "Patrick", lastname: "Chao", email: "prc@berkeley.edu", password: "a", year: "Sophomore", school: "UC Berkeley") else {
            fatalError("Unable to instantiate")
        }

        guard let s3 = Student(firstname: "Hannah", lastname: "He", email: "hahe@berkeley.edu", password: "a", year: "Senior", school: "UC Berkeley") else {
            fatalError("Unable to instantiate")
        }

        guard let s4 = Student(firstname: "Michelle", lastname: "Hao", email: "mich@berkeley.edu", password: "a", year: "Sophomore", school: "UC Berkeley") else {
            fatalError("Unable to instantiate")
        }

        guard let s5 = Student(firstname: "Rosa", lastname: "Choe", email: "rosa@berkeley.edu", password: "a", year: "Junior", school: "UC Berkeley") else {
            fatalError("Unable to instantiate")
        }
        students += [s1, s2, s3, s4, s5]
    }
}
