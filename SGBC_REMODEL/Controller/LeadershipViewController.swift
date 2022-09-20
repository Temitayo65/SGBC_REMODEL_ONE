//
//  LeadershipViewController.swift
//  SGBC_REMODEL
//
//  Created by ADMIN on 19/09/2022.
//

import UIKit

class LeadershipViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet var leadershipImageView: UIImageView!
    @IBOutlet var leadershipCollectionView: UICollectionView!
    
    @IBOutlet var leadershipCategoryTitleLabel: UILabel!
    
    var leaders: [Leader] = [Leader(leaderName: "Tony Okoroh", leaderHistory: "Tony has pastored Sovereign Grace Bible Church for 18 years. He is a graduate of the Mount Zion Bible Institute in Pensacola Florida. He has been married to Ori for 44years, has two sons and three grandchildren.", leaderImage: "leaderone"), Leader(leaderName: "Osinachi Nwowo", leaderHistory: "Osinachi has pastored Sovereign Grace Bible Church for 18 years. He is a graduate of the Mount Zion Bible Institute in Pensacola Florida. He has been married to Ori for 44years, has two sons and three grandchildren.", leaderImage: "leaderone"), Leader(leaderName: "Osagie Azeta", leaderHistory: "Osagie has pastored Sovereign Grace Bible Church for 18 years. He is a graduate of the Mount Zion Bible Institute in Pensacola Florida. He has been married to Ori for 44years, has two sons and three grandchildren.", leaderImage: "leaderone")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        tabBarController?.tabBar.isHidden = true
        leadershipCollectionView.register(UINib(nibName: "LeadershipCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "leadershipcell")
        leadershipCollectionView.delegate = self
        leadershipCollectionView.dataSource = self
        leadershipImageView.image = UIImage(named: "about")
        leadershipCategoryTitleLabel.text = "SGBC Leadership"
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        leaders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "leadershipcell", for: indexPath) as? LeadershipCollectionViewCell{
            cell.configureCell(with: leaders, atIndex: indexPath)
            return cell
        }
        return UICollectionViewCell()
    }
}

extension LeadershipViewController: UICollectionViewDelegateFlowLayout{
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 300, height: 650)
        }
    
}
