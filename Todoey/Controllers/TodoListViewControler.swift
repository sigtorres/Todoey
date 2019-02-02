//
//  ViewController.swift
//  Todoey
//
//  Created by Nelson Torres on 1/20/19.
//  Copyright © 2019 neltorCTS. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewControler: SwipeTableViewController {
    
    var todoItems : Results<Item>?
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let colorHex = selectedCategory?.cellBackgroundHex else {fatalError()}
            
        title = selectedCategory?.name
        
        updateNavBar(navBarWithHexcode: colorHex)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
//        guard let originalColor = UIColor(hexString: "18C9D9") else {fatalError()}
//        navigationController?.navigationBar.barTintColor = originalColor
//        navigationController?.navigationBar.tintColor = FlatWhite()
//        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:FlatWhite()]

        updateNavBar(navBarWithHexcode: "18C9D9")
        
    }
    
    //MARK: - nav bar setup methods
    
    func updateNavBar(navBarWithHexcode colorHexCode: String){
        
        guard let navBar = navigationController?.navigationBar else {fatalError("navigation controller does not exist")}
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else {fatalError()}
        
        navBar.barTintColor = navBarColor
        
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        
        searchBar.barTintColor = navBarColor
        
    }
    
    
    
    
    //MARK: - Tableview data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done == true ? .checkmark : .none
            
            
            if let backColor = UIColor(hexString: selectedCategory!.cellBackgroundHex)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
//            if let backColor = FlatSkyBlue().darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
            
                cell.backgroundColor = backColor
                cell.textLabel?.textColor = ContrastColorOf(backColor, returnFlat: true)
                
            }
            
        } else {
            cell.textLabel?.text = "no items added"
        }
        
        return cell
        
    }
    
    //MARK: - TableviewView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
//                    realm.delete(item)
                    item.done = !item.done
                }
            } catch {
                print("error updating item \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)

    }

    
    //MARK: - Add new Items
    
    @IBAction func addButtonPressed(_ sender: Any) {

        var newItemTextField = UITextField()
        
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print(newItemTextField.text!)
            
            if let currentCategory = self.selectedCategory {
                
                do {
                    try self.realm.write {
                        
                        let newItem = Item()
                        newItem.title = newItemTextField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("error saving new item to Realm :(")
                }
                
            }

            self.tableView.reloadData()

        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            newItemTextField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: - Model manipulation methods
//    func saveItems() {
//
//        do {
//            //try context.save()
//        }
//        catch {
//            print("error saving context \(error)")
//        }
//
//        self.tableView.reloadData()
//
//    }
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()

    }
    
    //MARK: - Delete Items
    override func deleteCategory(at indexPath: IndexPath) {
        
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            
            do {
                try realm.write {
                    realm.delete(itemForDeletion)
                    
                }
            } catch {
                print("error deleting category, \(error)")
            }
            
        }
        
    }
    
}


//MARK: - Search bar methods
extension TodoListViewControler: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
    
}

