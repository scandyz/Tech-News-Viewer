//
//  SavedTableViewController.swift
//  Tech News Viewer
//
//  Created by Никита Бычков on 03/04/2019.
//  Copyright © 2019 Никита Бычков. All rights reserved.
//

import UIKit
import CoreData

class SavedTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    
    var articles = [SavedArticle]()
    
    var fetchResultsController: NSFetchedResultsController<SavedArticle>!

    override func viewDidLoad() {
        super.viewDidLoad()
        let fetchRequest: NSFetchRequest<SavedArticle> = SavedArticle.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            fetchResultsController =  NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsController.delegate = self
            do {
                try fetchResultsController.performFetch()
                articles = fetchResultsController.fetchedObjects!
                print("Articles were successfully fetched")
            } catch let error as NSError {
                print("Fetching Error \(error)")
            }
        }
        
        
    }
    
    // MARK: - Fetch results controller delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert: guard let indexPath = newIndexPath else { break }
        tableView.insertRows(at: [indexPath], with: .fade)
        case .delete: guard let indexPath = indexPath else { break }
        tableView.deleteRows(at: [indexPath], with: .fade)
        case .update: guard let indexPath = indexPath else { break }
        tableView.reloadRows(at: [indexPath], with: .fade)
        default:
            tableView.reloadData()
        }
        articles = controller.fetchedObjects as! [SavedArticle]
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SavedTableViewCell
        cell.headlineLabel.text = articles[indexPath.row].title

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
                 let objectToDelete = self.fetchResultsController.object(at: indexPath)
                context.delete(objectToDelete)
                do {
                    try context.save()
                    print("Article was successfully deleted")
                    tableView.deleteRows(at: [indexPath], with: .fade)
                } catch let error as NSError {
                    print("Deleting Error \(error)")
                }
            }
        }
        delete.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        return [delete]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "savedWebSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dvc =  segue.destination as! SavedWebViewController
                dvc.urlString = self.articles[indexPath.row].url!
            }
        }
    }
}
