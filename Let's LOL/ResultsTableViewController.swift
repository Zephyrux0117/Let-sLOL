//
//  ResultsTableViewController.swift
//  Let's LOL
//
//  Created by xiongmingjing on 14/03/2017.
//  Copyright © 2017 xiongmingjing. All rights reserved.
//

import UIKit

class ResultsTableViewController: UITableViewController {

    var filterChampions = [Champion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ChampionCell")
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterChampions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChampionCell", for: indexPath)
        let champion = filterChampions[indexPath.row]
        
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
}
