//
//  ViewController.swift
//  Todoey
//
//  Created by Nelson Torres on 1/20/19.
//  Copyright © 2019 neltorCTS. All rights reserved.
//

import UIKit

class TodoListViewControler: UITableViewController {
    
    var itemArray = [ItemDataModel]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let newItem = ItemDataModel()
        newItem.title = "find Mike"
        itemArray.append(newItem)
        
        let newItem2 = ItemDataModel()
        newItem2.title = "Buy Eggos"
        itemArray.append(newItem2)
        
        let newItem3 = ItemDataModel()
        newItem3.title = "Destroy Demogorgon"
        itemArray.append(newItem3)
        
        if let persistentArray = defaults.array(forKey: "TodoListArray") as? [ItemDataModel] {
            itemArray = persistentArray
        }
        
    }
    
    //MARK: - Tableview data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        
        
        cell.accessoryType = item.done == true ? .checkmark : .none
//
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        }
//        else {
//            cell.accessoryType = .none
//        }
        
        
        
        return cell
        
    }
    
    //MARK: - TableviewView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
//        else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }

    
    //MARK: - Add new Items
    
    @IBAction func addButtonPressed(_ sender: Any) {

        var newItemTextField = UITextField()
        
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print(newItemTextField.text!)
            
            let newItem = ItemDataModel()
            newItem.title = newItemTextField.text!
            
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            newItemTextField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

