//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Nelson Torres on 1/24/19.
//  Copyright © 2019 neltorCTS. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()

    var listOfCategories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
        
        loadCategories()

    }
    
    
    //MARK: - Tableview Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listOfCategories?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = listOfCategories?[indexPath.row].name ?? "No categories added yet"
        
        return cell
        
    }
    
    //MARK: - Tableview Manipulation methods
    func loadCategories() {
        
        listOfCategories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
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
            
            let newCategory = Category()
            newCategory.name = newCategoryTextField.text!

            self.save(category: newCategory)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            newCategoryTextField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        //end from item list class
        
    }
    
    //MARK: - Delete Category
    
    override func deleteCategory(at indexPath: IndexPath) {
        
        if let categoryForDeletion = self.listOfCategories?[indexPath.row] {
        
            do {
                try realm.write {
                    realm.delete(categoryForDeletion)
                    
                }
            } catch {
                print("error deleting category, \(error)")
            }
            
        }
        
    }
    
    
    //leave this for later
    //MARK: - Tableview Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewControler
        
        if let indexPathSelected = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = listOfCategories?[indexPathSelected.row]
            
        }
        
        //
        
    }

}

