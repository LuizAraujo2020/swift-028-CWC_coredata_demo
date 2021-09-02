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
    
    
    func relationshipDemo() {
        // Create a family
        var family = Family(context: context)
        family.name = "ABC Family"
        
        // Create a person
        
        var person = Person(context: context)
        person.name = "Maggie"
        person.family = family
        
        // Save context
        do {
            try context.save()
        } catch {
            print("Error trying to save relationship")
        }
    }
    
    
    
    func fetchPeople() {
        
        // Fetch the data from Core Data to display in the tableView
        do {
            let request = Person.fetchRequest() as NSFetchRequest<Person>
            let name = "Luiz"
            
            // Set the filtering
//            let predicate = NSPredicate(format: "name CONTAINS 'Luiz'")
//            let predicate = NSPredicate(format: "name CONTAINS %@", name) ///dynamic value, %@ is a wildcard
            
//            request.predicate = predicate
            
            // Sorting on the request
            let sorting = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sorting]
            
            
            // Some functions
            //fetchLimit -> number of objects to be returned
            // fetchOffset start the fetch from a certain offset...
            
            /*
            Resources
            
            Core Data: https://developer.apple.com/documenta...
            NSPredicate: https://developer.apple.com/documenta...
            NSFetchRequest: https://developer.apple.com/documenta...
            */
            
            self.items = try context.fetch(request)
            
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
            let textField = alert.textFields![0]
            
            // TODO: Edit name property of person object
            person.name = textField.text
            
            // TODO: Save the data
            do {
                try self.context.save()
            } catch {
                print("Couldn't be able to save the modifications")
            }
            
            // TODO: Re-fetch the data
            self.fetchPeople()
            
        }
        
        // Add button
        alert.addAction(saveButton)
        
        // Show alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Create swipe action
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            // TODO: Which person to remove
            let personToRemove = self.items![indexPath.row]
            
            // TODO: Remove the person
            self.context.delete(personToRemove)
            
            // TODO: Save the data
            do {
                try self.context.save()
            } catch {
                print("Error saving the removal")
            }
            
            // TODO: Re-fetch the data
            self.fetchPeople()

        }
        
        // Return swipe actions
        return UISwipeActionsConfiguration(actions: [action])
        
    }
    
}
