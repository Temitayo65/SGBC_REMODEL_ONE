//
//  MainViewController.swift
//  SGBC_REMODEL
//
//  Created by ADMIN on 13/09/2022.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var mainTableViewGroups: [String] = ["about", "leadership", "ministries", "groups"]
    var mainTableViewGroupsTitle: [String] = ["About SGBC", "SGBC Leadership", "Ministries", "Small Groups"]
    @IBOutlet var MainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MainTableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "mainidentifier")
        MainTableView.delegate = self
        MainTableView.dataSource = self
        tabBarController?.tabBar.isHidden = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainTableViewGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "mainidentifier", for: indexPath) as? MainTableViewCell{
            cell.mainTableViewLabel.text = mainTableViewGroupsTitle[indexPath.row]
            cell.mainTableViewLabel.textColor = .white
            cell.mainTableViewImage.image = UIImage(named: mainTableViewGroups[indexPath.row])
            return cell 
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(160)
    }
    
    

}

