//
//  SermonsViewController.swift
//  SGBC_REMODEL
//
//  Created by ADMIN on 13/09/2022.
//

import UIKit

class SermonsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SermonManagerDelegate{
   
    var sermonManager = SermonManager()
    var sermons = [Sermons]()
    var currentIndexPath: Int = 0
    @IBOutlet var spinner: UIActivityIndicatorView!
    var sermonByBookData = ["Genesis", "Exodus", "Leviticus", "Numbers", "Deuteronomy", "Joshua", "Judges", "Ruth", "1 Samuel", "2 Samuel","1 Kings", "2 Kings", "1 Chronicles", "2 Chronicles", "Ezra", "Nehemiah", "Esther", "Job", "Psalms", "Proverbs", "Ecclessiastes", "Song of Solomon", "Isaiah", "Jeremiah", "Lamentation", "Ezekiel", "Daniel", "Hosea", "Joel", "Amos", "Obadiah", "Jonah", "Micah", "Nahum", "Habakkuk", "Zepheniah","Haggai", "Zechariah", "Malachi", "Matthew", "Mark", "Luke", "John", "Acts", "Romans", "1 Corinthians", "2 Corinthians", "Galatians", "Ephesians", "Philippians", "Colossians", "1 Thessalonians", "2 Thessalonians", "1 Timothy", "2Timothy", "Titus", "Philemon", "Hebrew", "James", "1 Peter", "2 Peter", "1 John", "2 John", "3 John", "Jude", "Revelation"]
   

    @IBOutlet var SermonsHeaderImageView: UIImageView!
    @IBOutlet var recentSermonButton: UIButton!
    @IBOutlet var seriesSermonButton: UIButton!
    @IBOutlet var booksSermonButton: UIButton!
    @IBOutlet var speakersSermonButton: UIButton!
    
    @IBOutlet var recentSermonsTableView: UITableView!
    
    
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        
        tabBarController?.tabBar.isHidden = true
        recentSermonButton.layer.borderWidth = 0.5
        recentSermonButton.layer.borderColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        recentSermonButton.layer.cornerRadius = 5
        seriesSermonButton.layer.borderWidth = 0.5
        seriesSermonButton.layer.borderColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        seriesSermonButton.layer.cornerRadius = 5
        booksSermonButton.layer.borderWidth = 0.5
        booksSermonButton.layer.borderColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        booksSermonButton.layer.cornerRadius = 5
        speakersSermonButton.layer.borderWidth = 0.5
        speakersSermonButton.layer.borderColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        speakersSermonButton.layer.cornerRadius = 5
        
        SermonsHeaderImageView.image = UIImage(named: "sermonsimage")
        
        
        sermonByBooksTableView.register(UINib(nibName: "SermonByBooksTableViewCell", bundle: nil), forCellReuseIdentifier: "sermonbybooksidentifier")
        sermonByBooksTableView.delegate = self
        sermonByBooksTableView.dataSource = self
        
        
        recentSermonsTableView.register(UINib(nibName: "RecentSermonTableViewCell", bundle: nil), forCellReuseIdentifier: "recentsermonidentifier")
        recentSermonsTableView.delegate = self
        recentSermonsTableView.dataSource = self
        

        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        recentSermonsTableView.addSubview(refreshControl)
        
        
        sermonManager.delegate = self
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        sermonManager.fetchSermons()
        
        recentSermonButton.backgroundColor = .blue
        
        sermonByBooksTableView.isHidden = true
        
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        sermonManager.fetchSermons()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == recentSermonsTableView{return sermons.count}
        else if tableView == sermonByBooksTableView{return sermonByBookData.count}
        else{return 10}
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Sorting sermons by how recent they are
        sermons.sort {sermon_one, sermon_two in
            sermon_one.date_preached > sermon_two.date_preached
        }
        if tableView == recentSermonsTableView{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "recentsermonidentifier", for: indexPath) as? RecentSermonTableViewCell{
                cell.RecentSermonTitleLabel.text = sermons[indexPath.row].title
                let sliced_date = slice(sermons[indexPath.row].date_preached, from: 0, to: "T")!
                cell.RecentSermonDate.text = sliced_date
                cell.RecentSermonImageView.image = UIImage(named: "placeholder")
                cell.RecentSermonPreacherName.text = sermons[indexPath.row].sermonPastor.first_name + " " + sermons[indexPath.row].sermonPastor.last_name
                return cell
            }
        }
        else if tableView == sermonByBooksTableView{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "sermonbybooksidentifier", for: indexPath) as? SermonByBooksTableViewCell{
                cell.bookTitle.text = sermonByBookData[indexPath.row]
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentIndexPath = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true) // remove selection background when clicked
        if tableView == recentSermonsTableView{ performSegue(withIdentifier: "playAudio", sender: self)}
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == recentSermonsTableView{return 120}
        else{return 40}
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playAudio"{
            let vc = segue.destination as! SermonAudioPlayerViewController
            vc.sermonImageURL = sermons[currentIndexPath].sermonImage?.image_url ?? "https://sgbc.ams3.digitaloceanspaces.com/Images/March-2021/The-Obedience-of-the-Last-Adam.jpg?AWSAccessKeyId=C663TNSAPB6NR24LMYTF&Expires=1663281102&Signature=P9bexmZq%2FHpPJeWK6BnVPTBnHcQ%3D"
            vc.preacherTitle = sermons[currentIndexPath].sermonPastor.first_name + " " + sermons[currentIndexPath].sermonPastor.last_name
            vc.sermonTitle = sermons[currentIndexPath].title
            vc.sermonAudioURL = sermons[currentIndexPath].sermonAudio.audio_url
            
        }
    }
    
    func didUpdateSermonData(sermon: [Sermons]?) {
        DispatchQueue.main.async {
            if let sermon = sermon {
                self.sermons = sermon
                self.recentSermonsTableView.reloadData()
                self.spinner.stopAnimating()
                self.refreshControl.endRefreshing()
            }
        }
    }

    
    @IBOutlet var sermonByBooksTableView: UITableView!
    
    
    
    @IBAction func categoryButtonPressed(_ sender: UIButton) {
        if sender.titleLabel?.text?.lowercased() == "books"{
            recentSermonsTableView.isHidden = true
            sermonByBooksTableView.isHidden = false
            booksSermonButton.backgroundColor = .blue
            recentSermonButton.backgroundColor = .clear
        }
        else if sender.titleLabel?.text?.lowercased() == "recent"{
            recentSermonsTableView.isHidden = false
            sermonByBooksTableView.isHidden = true
            booksSermonButton.backgroundColor = .clear
            recentSermonButton.backgroundColor = .blue
        }
        
        
    }
    
    
    
}
