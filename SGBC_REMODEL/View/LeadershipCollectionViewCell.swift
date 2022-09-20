//
//  LeadershipCollectionViewCell.swift
//  SGBC_REMODEL
//
//  Created by ADMIN on 19/09/2022.
//

import UIKit

class LeadershipCollectionViewCell: UICollectionViewCell {
    @IBOutlet var leaderImageView: UIImageView!
    @IBOutlet var leaderNameLabel: UILabel!
    @IBOutlet var leaderAboutLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        leaderImageView.layer.cornerRadius = 5

    }
    
    func configureCell(with info: [Leader], atIndex indexPath: IndexPath){
        leaderNameLabel.text = info[indexPath.row].leaderName
        leaderImageView.image = UIImage(named: info[indexPath.row].leaderImage)
        leaderAboutLabel.text = info[indexPath.row].leaderHistory
        leaderAboutLabel.textAlignment = .left
    }
    

}
