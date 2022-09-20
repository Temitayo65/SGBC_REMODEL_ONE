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
        // hiding the navigation bar
        navigationController?.navigationBar.isHidden = true
        
        MainTableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "mainidentifier")
        MainTableView.delegate = self
        MainTableView.dataSource = self
        tabBarController?.tabBar.isHidden = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if mainTableViewGroups[indexPath.row] == "leadership"{
            performSegue(withIdentifier: "leadershipidentifier", sender: self)
        }
        else if mainTableViewGroups[indexPath.row] == "about"{
            performSegue(withIdentifier: "aboutidentifier", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(160)
    }
    
    

}


// Including the slice function just created in all view controller instances 
extension UIViewController{
    func slice(_ string: String, from startingIndex: Int, to endIndex: Int) -> String {
        let chosenString = string
        var start = chosenString.startIndex
        if start.hashValue != 0{
            start = chosenString.index(start, offsetBy: startingIndex)
        }
        let end = chosenString.index(start, offsetBy: endIndex)
        return String(chosenString[start...end])
    }
    
    func slice(_ string: String, from startingIndex: Int, to character: Character) -> String? {
        let chosenString = string
        var start = chosenString.startIndex
        if start.hashValue != 0{
            start = chosenString.index(start, offsetBy: startingIndex)
        }
        guard let end = chosenString.firstIndex(of: character)else{ return nil}
        return String(chosenString[start..<end])
    }

    func slice(_ string: String, from character: Character, to secondCharacter: Character) -> String? {
        let chosenString = string
        var start = chosenString.firstIndex(of: character)!
        start = chosenString.index(start, offsetBy: 1)
        guard let end = chosenString.firstIndex(of: secondCharacter)else{ return nil}
        return String(chosenString[start..<end])
    }
}
