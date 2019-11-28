//
//  ViewController.swift
//  iCloudExample
//
//  Created by Seokho on 2019/11/27.
//  Copyright © 2019 Seokho. All rights reserved.
//

import CoreData
import UIKit

class MainViewController: UIViewController {
    var fetchedResults: NSFetchedResultsController<ToDo>!

    var tableView: UITableView {
        guard let tableView = self.view as? UITableView else {
            preconditionFailure()
        }
        return tableView
    }

    override func loadView() {
        self.navigationItem.title = "To Do"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(MainViewController.addButtonPressed(_:)))

        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            preconditionFailure()
        }

        let fetchRequest: NSFetchRequest = ToDo.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \ToDo.date, ascending: true),
        ]

        let fetchedResults = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                        managedObjectContext: delegate.persistentContainer.viewContext,
                                                        sectionNameKeyPath: nil,
                                                        cacheName: nil)
        self.fetchedResults = fetchedResults
        fetchedResults.delegate = self

        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        self.view = tableView
        tableView.register(MainViewCell.self, forCellReuseIdentifier: "\(ToDo.self)")
        tableView.delegate = self

        let dataSource = UITableViewDiffableDataSourceReference(tableView: tableView) { (tableView, indexPath, item) -> UITableViewCell? in
            let object = fetchedResults.object(at: indexPath)

            let cell = tableView.dequeueReusableCell(withIdentifier: "\(type(of: object))", for: indexPath)

            switch cell {
            case let cell as MainViewCell:
                cell.object = object
            default:
                preconditionFailure()
            }

            return cell
        }
        self.dataSource = dataSource
        dataSource.defaultRowAnimation = .fade

        do {
            try fetchedResults.performFetch()
        } catch {
            fatalError("\(error)")
        }
    }

    var dataSource: UITableViewDiffableDataSourceReference!

    @objc
    func addButtonPressed(_ sender: UIBarButtonItem) {
        let createToDoForm = UIAlertController(title: "할 일", message: "할 일을 입력학세요.", preferredStyle: .alert)
        createToDoForm.addTextField { textField in
            textField.placeholder = "할 일"
        }

        createToDoForm.addAction(UIAlertAction(title: "확인", style: .default) { action in
            guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
                preconditionFailure()
            }

            let title = createToDoForm.textFields?[0].text

            delegate.persistentContainer.performBackgroundTask { context in
                let object = ToDo(context: context)
                object.title = title
                object.date = Date()

                do {
                    try context.save()
                } catch {
                    fatalError("\(error)")
                }
            }
        })
        createToDoForm.addAction(UIAlertAction(title: "취소", style: .cancel))

        self.present(createToDoForm, animated: true)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [
            UIContextualAction(style: .destructive, title: "삭제") { action, sourceView, completionHandler in
                guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
                    preconditionFailure()
                }

                let deleteObjectID = self.fetchedResults.object(at: indexPath).objectID

                delegate.persistentContainer.performBackgroundTask { context in
                    context.delete(context.object(with: deleteObjectID))

                    do {
                        try context.save()
                    } catch {
                        fatalError("\(error)")
                    }
                    DispatchQueue.main.sync {
                        completionHandler(true)
                    }
                }
            },
        ])
    }
}

extension MainViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        self.dataSource.applySnapshot(snapshot, animatingDifferences: self.dataSource.snapshot().numberOfSections > 0)
    }
}
