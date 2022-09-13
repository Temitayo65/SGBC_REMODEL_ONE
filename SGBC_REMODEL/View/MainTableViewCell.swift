//
//  MainTableViewCell.swift
//  SGBC_REMODEL
//
//  Created by ADMIN on 13/09/2022.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet var mainTableViewImage: UIImageView!
    @IBOutlet var mainTableViewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainTableViewImage.layer.cornerRadius = 10
        mainTableViewLabel.layer.masksToBounds = true
        mainTableViewImage.clipsToBounds = true
        contentView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        contentView.layer.cornerRadius = 10
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
      
    }
    
}
