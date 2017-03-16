//
//  ChampionDetailViewController.swift
//  Let's LOL
//
//  Created by xiongmingjing on 13/03/2017.
//  Copyright © 2017 xiongmingjing. All rights reserved.
//

import UIKit

class ChampionDetailViewController: UIViewController {

    var champion: Champion?

    @IBOutlet weak var splashImageView: UIImageView!
    @IBOutlet weak var championLabel: UILabel!
    @IBOutlet weak var allyTipsTextView: UITextView!
    @IBOutlet weak var enemyTipsTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI(champion!)
    }

    let championTextAttributes: [String: Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSStrokeWidthAttributeName: -3.0
    ]

    func configUI(_ champion: Champion) {

        activityIndicator.startAnimating()
        championLabel.attributedText = NSMutableAttributedString(string: champion.name!, attributes: championTextAttributes)
        allyTipsTextView.text = champion.allyTips
        enemyTipsTextView.text = champion.enemyTips
        if let splashData = champion.splashData {
            splashImageView.image = UIImage(data: splashData as Data)
            activityIndicator.stopAnimating()
        } else {
            DownloadHelper.shared.downloadAndSaveSplash(champion) { (champion, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        self.activityIndicator.stopAnimating()
                        self.displayError(error)
                    }
                    if let champion = champion {
                        self.splashImageView.image = UIImage(data: champion.splashData! as Data)
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
        }
    }
}
