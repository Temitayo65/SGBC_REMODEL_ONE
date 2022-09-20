//
//  AboutTableViewController.swift
//  SGBC_REMODEL
//
//  Created by ADMIN on 20/09/2022.
//

import UIKit

class AboutTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var aboutImageHeaderView: UIImageView!
    @IBOutlet var aboutCategoryTitle: UILabel!
    
    var sectionChosen = 0
    var aboutSectionTextTitles : [String] = ["Summary", "Our Mission", "Our History"]
    var aboutSectionTexts : [String] = ["At SGBC, we want to do everything to the glory of God. That the way we live and love might tell everyone of the great work of salvation which God has worked in our lives. It is our goal to be of one mind as it pertains to life and godliness so we encourage each other to attend weekly worship services, be part of a neighborhood small group, and find ways to serve one another, the communities in which we live, and our nation.", "Our calling is to preach the whole counsel of God that will cause us and all around us to live to God’s glory.","In 1994 a group of Christians attended a Family Radio program where they heard the true gospel preached; in order to continue to hear the truth preached they decided to keep meeting with Tony Okoroh as coordinator. By 1997, the group became known as Sovereign Grace Bible Fellowship and started to meet regularly on Sundays in a classroom at a school in Anifowoshe Ikeja and later on Adegbola Street also in Anifowoshe. They prayed together, held Bible studies and listened to taped sermons from Mount Zion Bible Church, Florida, and Christ Bible Church, San Francisco for a while until they were ready -with oversight from other reformed churches- to covenant together.\n\nThe first 12 regular attendees covenanted together to become Sovereign Grace Bible Church and laid hands on Tony Okoroh to become the Pastor in 2002. Since then we have seen steady growth and now have a membership of over 70 adults, are blessed with lots of children and regular attendees.\n\nIn 2010, Pst. Femi Sonuga-Oye became our second elder while Pst. Osagie Azeta and Pst. Osinachi Nwoko were ordained in 2019.\n\nThrough efforts in Tract Distribution (since 1994), Blessed Children Ministry (since 1999), Lagos Bible Conference (since 2002), and Christ Pastor’s Seminary (since 2010), we hope to share the truth of God’s word with our city and nation.\n\nThe Lord God is still working in us and through us each day and we are excited and hopeful that He would use us in more ways."]
    
    
    
    @IBOutlet var aboutTableView: UITableView!
    @IBOutlet var aboutHeaderImageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        aboutTableView.register(UINib(nibName: "AboutTableViewCell", bundle: nil), forCellReuseIdentifier: "aboutcellidentifier")
        aboutTableView.delegate = self
        aboutTableView.dataSource = self
        aboutImageHeaderView.image = UIImage(named: "about")
        aboutCategoryTitle.text = "About"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "aboutcellidentifier", for: indexPath) as? AboutTableViewCell{
            cell.configureCell(with: aboutSectionTexts, atIndex: sectionChosen)
            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return aboutSectionTexts.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sectionChosen = section
        return aboutSectionTextTitles[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    

}
