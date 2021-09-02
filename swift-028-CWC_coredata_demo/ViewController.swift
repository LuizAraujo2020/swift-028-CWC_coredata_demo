//
//  ViewController.swift
//  swift-028-CWC_coredata_demo
//
//  Created by Luiz Carlos da Silva Araujo on 01/09/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    
    
    @IBOutlet var tableView: UITableView!
    
    // Reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Data for the table
    var items: [Person]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Get items from Core Data
        fetchPeople()
    }
    
    func fetchPeople() {
        
        // Fetch the data from Core Data to display in the tableView
        do {
            self.items = try context.fetch(Person.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Couldn't retrieve data from CoreData")
        }
        
    }
    
    @IBAction func addTapped(_ sender: Any) {
        
        // Create Alert
        let alert = UIAlertController(title: "Add Person", message: "What is their name?", preferredStyle: .alert)
        alert.addTextField()
        alert.addTextField()
//        alert.addTextField()
        
        // Configure button handler
        let submitButton = UIAlertAction(title: "Add", style: .default) { (action) in
     
            // Get the textField for the alert
            let textField = alert.textFields![0]
//            let textFieldAge = alert.textFields![1]
            let textFieldGender = alert.textFields![1]
            
            // Create a person object in the context
            let newPerson = Person(context: self.context)
            newPerson.name = textField.text
            newPerson.age = 20
            newPerson.gender = textFieldGender.text
            
            // Save the data
            do {
                try self.context.save()
            } catch {
                print("Couldn't save the context")
            }
            // Re-fetch the data
            self.fetchPeople()
        }
    
    // Add button
    alert.addAction(submitButton)
    
    // Show Alert
    self.present(alert, animated: true, completion: nil)
        
    }
       


}



extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return the number of people
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
        
        // Get person from array and set the label
        let person = self.items![indexPath.row]
        cell.textLabel?.text = person.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Selected Person
        let person = self.items![indexPath.row]
        
        // Create alert
        let alert = UIAlertController(title: "Edit Person", message: "Edit name: ", preferredStyle: .alert)
        alert.addTextField()
        
        let textField = alert.textFields![0]
        textField.text = person.name
        
        // Configure button handler
        let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
            // Get the textfield for the alert
        }
        
        
    }
    
    
}
