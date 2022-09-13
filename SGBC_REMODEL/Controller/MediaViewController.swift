//
//  MediaViewController.swift
//  SGBC_REMODEL
//
//  Created by ADMIN on 13/09/2022.
//

import UIKit

class MediaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    var mediaTableViewGroups: [String] = ["sermons", "podcasts", "radio", "blogs"]
    var mediaTableViewGroupsTitle: [String] = ["Sermons", "Podcasts", "Radio", "Blogs"]
    @IBOutlet var MediaTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MediaTableView.register(UINib(nibName: "MediaTableViewCell", bundle: nil), forCellReuseIdentifier: "mediaidentifier")
        MediaTableView.delegate = self
        MediaTableView.dataSource = self
    
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaTableViewGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "mediaidentifier", for: indexPath) as? MediaTableViewCell{
            cell.MediaTableViewLabel.text = mediaTableViewGroupsTitle[indexPath.row]
            cell.MediaTableViewLabel.textColor = .white
            cell.MediaTableViewImage.image = UIImage(named: mediaTableViewGroups[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(160)
    }
    
    


}
