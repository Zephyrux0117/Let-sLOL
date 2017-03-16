//
//  ChampionTableViewController.swift
//  Let's LOL
//
//  Created by xiongmingjing on 10/03/2017.
//  Copyright © 2017 xiongmingjing. All rights reserved.
//

import UIKit
import CoreData

class ChampionTableViewController: CoreDataViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var champions = [Champion]()
    var searchController: UISearchController!
    var resultsTableViewController: ResultsTableViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.stopAnimating()

        tableView.delegate = self
        tableView.dataSource = self

        initFetchedResultController()
        initSearchController()
        registerCell()
    }

    private func initFetchedResultController() {
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Champion")
        fr.sortDescriptors = []
        fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: getStack().context, sectionNameKeyPath: nil, cacheName: nil)

        champions = fc?.fetchedObjects as! [Champion]
        if champions.count == 0 {
            activityIndicator.startAnimating()
            DownloadHelper.shared.downloadInitData() {error in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    if let error = error {
                        
                        
                        self.displayError(error)
                        
                    }
                }
                
            }
        }
    }

    private func initSearchController() {
        resultsTableViewController = ResultsTableViewController()
        resultsTableViewController.tableView.delegate = self

        searchController = UISearchController(searchResultsController: resultsTableViewController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar

        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self

        definesPresentationContext = true
    }

    private func registerCell() {
        let nib = UINib(nibName: "TableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ChampionCell")
    }
}

// MARK: - Table view data source

extension ChampionTableViewController {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let fc = fc {
            return fc.sections![section].numberOfObjects
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let champion = fc?.object(at: indexPath) as! Champion
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChampionCell", for: indexPath)

        cell.textLabel?.text = champion.name
        cell.detailTextLabel?.text = champion.tags
        cell.imageView?.image = nil

        if let imageData = champion.imageData as? Data {
            cell.imageView?.image = UIImage(data: imageData)
        } else {
            DownloadHelper.shared.downloadAndSaveImage(champion)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: false)
        
        var champion: Champion
        if tableView === self.tableView {
            champion = champions[indexPath.row]
        } else {
            champion = resultsTableViewController.filterChampions[indexPath.row]
        }
        if champion.blurb != nil {
            pushDetailView(champion)
        } else {
            activityIndicator.startAnimating()
            DownloadHelper.shared.downloadAndSaveDetailInfo(champion) { (champion, error) in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    if let error = error {
                        self.displayError(error)
                    }
                    if let champion = champion {
                        self.pushDetailView(champion)
                    }
                }
            }
        }
    }

    private func pushDetailView(_ champion: Champion) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ChampionDetailViewController") as! ChampionDetailViewController
        controller.champion = champion
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ChampionTableViewController {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {

        let set = IndexSet(integer: sectionIndex)
        switch (type) {
        case .insert:
            tableView.insertSections(set, with: .fade)
        case .delete:
            tableView.deleteSections(set, with: .fade)
        default:
            break
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch (type) {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        champions = fc?.fetchedObjects as! [Champion]
        activityIndicator.stopAnimating()
        tableView.endUpdates()
    }
}

extension ChampionTableViewController: UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func updateSearchResults(for searchController: UISearchController) {

        let searchText = searchController.searchBar.text!
        var filterChampions = [Champion]()
        for champion in champions {
            if champion.name!.hasPrefix(searchText) {
                filterChampions.append(champion)
            }
        }
        let resultsController = searchController.searchResultsController as! ResultsTableViewController
        resultsController.filterChampions = filterChampions
        resultsController.tableView.reloadData()
    }
}
