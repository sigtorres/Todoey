//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Nelson Torres on 1/31/19.
//  Copyright © 2019 neltorCTS. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.rowHeight = 80
    }
    
    //MARK: - TAableview Data Source Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
        
    }
    
    
    //MARK: - Tableview Interaction methods

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("category deleted'")
//            let categoryToBeDeleted = self.listOfCategories?[indexPath.row]
//            self.deleteCategory(category: categoryToBeDeleted!)
            self.deleteCategory(at: indexPath)
//
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-Icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func deleteCategory(at indexPath: IndexPath) {
        //empty paceholder that we override in the subclass CategoryViewController
    }
    
    func deleteItem(at indexPath: IndexPath) {
        //empty placeholder that we override in the subclass TodoListViewController
    }

}
