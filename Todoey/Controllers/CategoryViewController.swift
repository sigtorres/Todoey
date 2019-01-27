//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Nelson Torres on 1/24/19.
//  Copyright © 2019 neltorCTS. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {

    var listOfCategories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }
    
    
    //MARK: - Tableview Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listOfCategories.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.text = listOfCategories[indexPath.row].name
        
        return cell
        
    }
    
    //MARK: - Tableview Manipulation methods
    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            listOfCategories = try context.fetch(request)
        }
        catch {
            print("error fetching from context \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func saveCategories() {
        
        do {
            try context.save()
        }
        catch {
            print("error saving context \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    

    //MARK: - Add New Categories
    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
        
        //from item list class
        var newCategoryTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            print(newCategoryTextField.text!)
            
            let newCategory = Category(context: self.context)
            newCategory.name = newCategoryTextField.text!
            
            self.listOfCategories.append(newCategory)
            
            self.saveCategories()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            newCategoryTextField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        //end from item list class
        
    }
    
    
    
    
    
    
    //leave this for later
    //MARK: - Tableview Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewControler
        
        if let indexPathSelected = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = listOfCategories[indexPathSelected.row]
            
        }
        
        //
        
    }

}
