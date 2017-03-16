//
//  CoreDataViewController.swift
//  Let's LOL
//
//  Created by xiongmingjing on 07/03/2017.
//  Copyright © 2017 xiongmingjing. All rights reserved.
//

import UIKit
import CoreData

class CoreDataViewController: UIViewController, NSFetchedResultsControllerDelegate {

    var fc: NSFetchedResultsController<NSFetchRequestResult>? {
        didSet {
            fc?.delegate = self
            executeSearch()
        }
    }
    
    init(fc: NSFetchedResultsController<NSFetchRequestResult>) {
        self.fc = fc
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func executeSearch() {
        if let fc = fc {
            do {
                try fc.performFetch()
            } catch {
                print("Failed to execute search")
            }
        }
    }
    
    func getStack() -> CoreDataStack {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.stack
    }
}

extension UIViewController {
    func displayError(_ error: String) {
        let alert = UIAlertController(title: nil, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
