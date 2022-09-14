//
//  SermonAudioPlayerViewController.swift
//  SGBC_REMODEL
//
//  Created by ADMIN on 14/09/2022.
//

import UIKit

class SermonAudioPlayerViewController: UIViewController {
    var sermonImageURL: String?
    var sermonTitle: String!
    var preacherTitle: String!
    
    @IBOutlet var sermonImageView: UIImageView!
    @IBOutlet var sermonTitleLabel: UILabel!
    @IBOutlet var preacherTitleLabel: UILabel!
    @IBOutlet var sermonProgressView: UIProgressView!
    @IBOutlet var sermonPlayButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sermonTitleLabel.text = sermonTitle
        preacherTitleLabel.text = preacherTitle
        if let sermonImageURL = sermonImageURL {
            sermonImageView.load(url: URL(string: sermonImageURL)!)
            sermonImageView.layer.borderColor = CGColor(red: 0.5, green: 0.5, blue: 0.3, alpha: 0.3)
            sermonImageView.layer.cornerRadius = 15
            view.reloadInputViews()
        }else{
            sermonImageView.image = UIImage(named: "placeholder")
            sermonImageView.layer.cornerRadius = 15
            view.reloadInputViews()
        }
        tabBarController?.tabBar.isHidden = true 

    }
    
    
    
    @IBAction func sermonRewindButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func sermonForwardButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func sermonPlayButtonPressed(_ sender: Any) {
    }
    
    @IBAction func sermonRateButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func sermonOptionButtonPressed(_ sender: UIButton) {
        
    }
    
    

}
