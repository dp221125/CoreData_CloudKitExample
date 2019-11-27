//
//  ViewController.swift
//  iCloudExample
//
//  Created by Seokho on 2019/11/27.
//  Copyright © 2019 Seokho. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    private let resultController: NSFetchedResultsController<ToDo>
    
    private var ownView: UITableView {
        return self.view as! UITableView
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let request: NSFetchRequest = ToDo.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "date", ascending: true)
        let delegate: AppDelegate! = UIApplication.shared.delegate as? AppDelegate
        request.sortDescriptors = [sortDescriptors]
        self.resultController = NSFetchedResultsController(fetchRequest: request,
                                                           managedObjectContext: delegate.persistentContainer.viewContext,
                                                           sectionNameKeyPath: nil,
                                                           cacheName: nil)
        
        do {
            try resultController.performFetch()
        } catch {
            print("Perform fetch error: \(error)")
        }
    

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .systemBackground
        tableView.register(MainViewCell.self, forCellReuseIdentifier: CellList.mainViewCell)
        
        let tableReloadData = UIRefreshControl()
        
        tableReloadData.addTarget(self, action: #selector(reload), for: .valueChanged)
        tableView.refreshControl = tableReloadData
        self.view = tableView
        tableView.dataSource = self
        tableView.delegate = self
        self.resultController.delegate = self
        self.navigationItem.title = "ToDo"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(addTodo))
    }
    
    @objc func reload() {
        let appDelegage: AppDelegate! = UIApplication.shared.delegate as? AppDelegate

           do {
            try appDelegage.persistentContainer.viewContext.setQueryGenerationFrom(.current)
            } catch {
                print("Perform fetch error: \(error)")
            }
        ownView.refreshControl?.endRefreshing()
        
    }
    
    @objc func addTodo() {
        
        let alert = UIAlertController(title: "할 일", message: "할 일을 입력학세요.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            let delegate: AppDelegate! = UIApplication.shared.delegate as? AppDelegate
            let title = alert.textFields?.first?.text
            delegate.persistentContainer.performBackgroundTask { (context) in
                let todo = ToDo(context: context)
                todo.title = title
                todo.date = Date()
                
                do {
                    try context.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancel)
        alert.addTextField()
        
        self.present(alert, animated: true) 
    }
}
extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return resultController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellList.mainViewCell, for: indexPath) as? MainViewCell else { fatalError() }
        let object = self.resultController.object(at: indexPath)
        cell.todoTitleLabel?.text = object.title
        cell.todoMakeDate?.text = object.date?.convertString()
        return cell
    }
}
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { _,_,completion in
            let todo = self.resultController.object(at: indexPath)
            
            let delegate: AppDelegate! = UIApplication.shared.delegate as? AppDelegate
            assert(delegate != nil)
            
            let context = delegate.persistentContainer.viewContext
            context.delete(todo)
            
            do {
                try context.save()
                completion(true)
            } catch {
                print("delete failed: \(error)")
                completion(false)
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
extension MainViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        ownView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        ownView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                ownView.insertRows(at: [indexPath], with: indexPath.row % 2 != 0 ? .left : .right)
            }
        case .delete:
            if let indexPath = indexPath {
                ownView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath, let cell = ownView.cellForRow(at: indexPath) as? MainViewCell {
                let todo = resultController.object(at: indexPath)
                cell.todoTitleLabel?.text = todo.title
            }
        default:
            break
        }
    }
}
