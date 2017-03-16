//
//  ItemCollectionViewController.swift
//  Let's LOL
//
//  Created by xiongmingjing on 15/03/2017.
//  Copyright © 2017 xiongmingjing. All rights reserved.
//

import UIKit
import CoreData

class ItemCollectionViewController: CoreDataViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var insertedIndexPaths: [IndexPath]!
    var updatedIndexPaths: [IndexPath]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.stopAnimating()
        collectionView.delegate = self
        collectionView.dataSource = self
        configCellUI(view.frame.size.width)
        
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        fr.sortDescriptors = []
        fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: getStack().context, sectionNameKeyPath: nil, cacheName: nil)
        
        if fc?.fetchedObjects?.count == 0 {
            activityIndicator.startAnimating()
            DownloadHelper.shared.initItemData() {error in
                
                self.activityIndicator.stopAnimating()
                if let error = error {
                    self.displayError(error)
                }
            }
        }
    }
    
    func configCellUI(_ frameSize: CGFloat) {
        
        let space: CGFloat = 0.0
        let dimension = (frameSize - (2 * space)) / 5.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        insertedIndexPaths = [IndexPath]()
        updatedIndexPaths = [IndexPath]()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            insertedIndexPaths.append(newIndexPath!)
            break
        case .update:
            updatedIndexPaths.append(indexPath!)
            break
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
        }
        
        collectionView.performBatchUpdates({ () -> Void in
            for indexPath in self.insertedIndexPaths {
                self.collectionView.insertItems(at: [indexPath])
            }
            for indexPath in self.updatedIndexPaths {
                self.collectionView.reloadItems(at: [indexPath])
            }
        }, completion: nil)
    }
}

extension ItemCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(fc!.sections![section].numberOfObjects)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCollectionViewCell
        cell.activityIndicator.startAnimating()
        cell.imageView.image = nil
        
        let item = fc?.object(at: indexPath) as! Item
        cell.item = item
        if let imageData = item.imageData {
            cell.imageView.image = UIImage(data: imageData as Data)
            cell.activityIndicator.stopAnimating()
        } else {
            DownloadHelper.shared.downloadAndSaveItemImage(item)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = fc?.object(at: indexPath) as! Item

        let controller = UIAlertController(title: item.name!, message: nil, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        controller.setValue(configItemDetailString(item), forKey: "attributedMessage")
        
        present(controller, animated: true, completion: nil)
    }
    
    private func configItemDetailString(_ item: Item) -> NSMutableAttributedString {
        
        let message = NSMutableAttributedString()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        let titieAttribute = [NSParagraphStyleAttributeName: paragraphStyle,NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14)]
        let contentAttribute = [NSFontAttributeName:UIFont.systemFont(ofSize: 14)]
        message.append(NSAttributedString(string: "\n", attributes: nil))
        
        message.append(NSAttributedString(string: "Gold: ", attributes: titieAttribute))
        message.append(NSAttributedString(string: "\(item.gold)\n\n", attributes: contentAttribute))
        
        message.append(NSAttributedString(string: "Tags: ", attributes: titieAttribute))
        message.append(NSAttributedString(string: "\(item.tags ?? "")\n\n", attributes: contentAttribute))

        message.append(NSAttributedString(string: "Description: ", attributes: titieAttribute))
        message.append(NSAttributedString(string: "\(item.desc ?? "")", attributes: contentAttribute))

        return message
    }
    
}
