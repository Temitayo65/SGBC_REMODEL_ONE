//
//  SermonAudioPlayerViewController.swift
//  SGBC_REMODEL
//
//  Created by ADMIN on 14/09/2022.
//

import UIKit
import SwiftAudio
import AVKit

public var globalPlayerURL: String = ""
public var globalPlayerState: AudioPlayerState = .idle
public var globalAudioPlayer = AudioPlayer()

class SermonAudioPlayerViewController: UIViewController {
    
    var sermonImageURL: String?
    var sermonTitle: String!
    var preacherTitle: String!
    var sermonAudioURL: String!
    
    @IBOutlet var sermonImageView: UIImageView!
    @IBOutlet var sermonTitleLabel: UILabel!
    @IBOutlet var preacherTitleLabel: UILabel!
    @IBOutlet var sermonProgressView: UIProgressView!
    @IBOutlet var sermonPlayButton: UIButton!
    @IBOutlet var sermonProgressSlider: UISlider!
    @IBOutlet var sermonRateButton: UIButton!
    @IBOutlet var sermonOptionsButton: UIButton!
    @IBOutlet var startButtonLabel: UILabel!
    @IBOutlet var endButtonLabel: UILabel!
    @IBOutlet var audioVideoSegmentedControl: UISegmentedControl!
   
    @IBOutlet var sermonRewindButton: UIButton!
    
    @IBOutlet var sermonForwardButton: UIButton!
    var audioItem: DefaultAudioItem!
    var currentURL: String = ""
    
    // For Video
    var playPauseButton: PlayPauseButton!
    
    // For video
    //let videoPath = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
    //let videoPath = "https://www.googleapis.com/youtube/v3/videos"
    
    // make the videoPath url be a property sent from the previous view controller
    // i.e videoPathURL: String!
    // then let videoPath = videoPathURL or just use it directly in your code 
     let videoPath = "https://rr4---sn-a5mekn6r.googlevideo.com/videoplayback?expire=1663442210&ei=wcglY-SJOoT6kgags4XwBA&ip=207.204.228.190&id=o-AHO1hmDRBfExpVzVT-WlzYcIsjMCypmJYjlF2EIVllXE&itag=22&source=youtube&requiressl=yes&mh=Il&mm=31%2C26&mn=sn-a5mekn6r%2Csn-o097znsr&ms=au%2Conr&mv=m&mvi=4&pl=24&initcwndbps=1253750&spc=yR2vp-bJOqkikZoZaCsecV6d7C0vyJI&vprv=1&mime=video%2Fmp4&ns=Le8uz2Rrg-DOc1ITdhQPAhII&cnr=14&ratebypass=yes&dur=3770.293&lmt=1663008251179537&mt=1663420146&fvip=3&fexp=24001373%2C24007246&c=WEB&rbqsm=fr&txp=7211224&n=TPwd6OxT9cDQsw&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cspc%2Cvprv%2Cmime%2Cns%2Ccnr%2Cratebypass%2Cdur%2Clmt&sig=AOq0QJ8wRQIgat3JJKrwxPyVpW_qzsgR-UgdCEfqsNHJ4tBNifo9uOICIQCYVD_wdieyNDvlx9QPM_LDxQQLFPfoM8H71jCCkmlKgw%3D%3D&lsparams=mh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Cinitcwndbps&lsig=AG3C_xAwRAIgFrsfSsVNb-FY-bC4clrTKgINpR2734DZLWmkA-M0BxICIGV3arf_Em1vFWXYnr59Ypt5V9QoA2VXigkJ0kFu-avW&title=Pastor%20Osagie%20Azeta%20%7C%20The%20Treasure%20of%20Knowing%20Christ%20(Colossians%202%3A1-3)"
    
    let playerViewController = AVPlayerViewController()
    var vplayer = AVPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // For Video
        guard let url = URL(string: videoPath) else { return }
        vplayer = AVPlayer(url: url)
        vplayer.rate = 1 //auto play
        let playerFrame = CGRect(x: 10 , y: view.frame.height / 6.2, width: view.frame.width-20, height: view.frame.height/3)
        playerViewController.player = vplayer
        playerViewController.view.frame = playerFrame
        addChild(playerViewController)
        playPauseButton = PlayPauseButton()
        playPauseButton.avPlayer = vplayer
        vplayer.pause()
        
        
        // For audio
        changeUIOnButtonClick()
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        try! AVAudioSession.sharedInstance().setActive(true)
        
        sermonProgressSlider.isHidden = true
        currentURL = sermonAudioURL
        sermonTitleLabel.text = sermonTitle
        preacherTitleLabel.text = preacherTitle
        if let sermonImageURL = sermonImageURL {
            sermonImageView.load(url: URL(string: sermonImageURL)!)//talk to Dara about this
            sermonImageView.layer.borderColor = CGColor(red: 0.5, green: 0.5, blue: 0.3, alpha: 0.3)
            sermonImageView.layer.cornerRadius = 15
        }else{
            sermonImageView.image = UIImage(named: "placeholder")
            sermonImageView.layer.cornerRadius = 15
        }
        tabBarController?.tabBar.isHidden = true
        
        globalAudioPlayer.event.stateChange.addListener(self, handleAudioPlayerStateChange)
        globalAudioPlayer.event.updateDuration.addListener(self, handleAudioPlayerTimeEvent)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        if #available(iOS 16.0, *) {
            vplayer.pause()
            vplayer.replaceCurrentItem(with: AVPlayerItem(url: URL(filePath: "")))
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransition(to: size, with: coordinator)
            playPauseButton.updateUI()
    }
    
    
    @IBAction func audioVideoControlClicked(_ sender: UISegmentedControl) {
        //print(sender.selectedSegmentIndex)
        if sender.selectedSegmentIndex == 1{
            self.hideAndRevealButtons(setTo: true)
            vplayer.play()
            view.addSubview(playerViewController.view)
            playerViewController.didMove(toParent: self)
            view.addSubview(playPauseButton)
            playPauseButton.setup(in: self)
        }
        else {
            self.hideAndRevealButtons(setTo: false)
            self.sermonImageView.isHidden = false
            self.sermonProgressSlider.isHidden = false
            self.playPauseButton.isHidden = false
            self.sermonRateButton.isHidden = false
            playerViewController.view.removeFromSuperview()
            playPauseButton.removeFromSuperview()
            vplayer.pause()
        }
    }
    
    func hideAndRevealButtons(setTo result: Bool){
        self.sermonImageView.isHidden = result
        self.sermonProgressSlider.isHidden = result
        self.playPauseButton.isHidden = result
        self.sermonRateButton.isHidden = result
        self.sermonRewindButton.isHidden = result
        self.sermonForwardButton.isHidden = result
        self.startButtonLabel.isHidden = result
        self.endButtonLabel.isHidden = result
        self.sermonPlayButton.isHidden = result
        self.sermonProgressView.isHidden = result
    }
    
    
    func handleAudioPlayerStateChange(state: AudioPlayerState) {
        
        switch state {
        case .buffering:
            //print("Audio is  buffering")
            changeUIOnButtonClick()
            return
        case .playing:
            //print("Audio is  playing")
            changeUIOnButtonClick()
            return
        case .paused:
            //print("Audio is paused")
            changeUIOnButtonClick()
            return
        case .idle:
            //print("Engine is idle")
            changeUIOnButtonClick()
            return
        case .ready:
            //print("Engine is ready to start")
            changeUIOnButtonClick()
            return
        case .loading:
            //print("Engine is loading")
            changeUIOnButtonClick()
            return
        }
        
    }
    
    func changeUIOnButtonClick(){
        let playerState = globalPlayerState
        
        if playerState == .paused{
            DispatchQueue.main.async {
                self.sermonPlayButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            }
        }
        else if playerState == .playing{
            DispatchQueue.main.async {
                self.sermonPlayButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
            }
        }
        else if playerState == .idle {
            DispatchQueue.main.async {
                self.sermonPlayButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)

            }
        }
        
    }
    
    @IBAction func sermonRewindButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func sermonForwardButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func sermonPlayButtonPressed(_ sender: Any) {
        if globalPlayerState == .idle{
            //print("Starting out initially")
            globalPlayerState = .playing
            globalPlayerURL = currentURL
            loadAudio()
            globalAudioPlayer.play()
        }
        else if globalPlayerState == .playing && globalPlayerURL == currentURL{
            //print("Pausing after having started")
            globalPlayerState = .paused
            globalAudioPlayer.pause()
        }
        else if globalPlayerState == .paused && globalPlayerURL == currentURL{
            //print("Playing after having paused")
            globalPlayerState = .playing
            globalAudioPlayer.play()
        }
        else if globalPlayerState == .playing && globalPlayerURL != currentURL{
            //print("Audio has been changed because of different row click and is now playing new audio")
            globalAudioPlayer.stop()
            loadAudio()
            globalPlayerURL = currentURL
            globalAudioPlayer.play()
    
        }
        else if globalPlayerState == .paused && globalPlayerURL != currentURL{
            //print("Audio has been changed because of different row click with previous audio paused and is now playing new audio")
            globalAudioPlayer.stop()
            loadAudio()
            globalPlayerURL = currentURL
            globalAudioPlayer.play()

        }
            

    }
    
    func handleAudioPlayerTimeEvent(event: AudioPlayer.UpdateDurationEventData){
        DispatchQueue.main.async { [self] in
            var hours: Float = 0
            let seconds: Int = Int(globalAudioPlayer.currentTime)
            let secondsLeft = seconds % 60
            var minutes: Float = Float(seconds/60)
            if minutes >= 60{
                minutes = minutes.remainder(dividingBy: 60)
                hours += 1
            }
            
            func updateTimer(){
                // sort this countdown issue later
                self.startButtonLabel.text = "\(String(format: "%.0f",hours)).\(String(format: "%.0f",minutes)).\(secondsLeft)"
                self.endButtonLabel.text = String(format: "%.0f", (Float(globalAudioPlayer.duration)/60)) + "." + String(Float(Int(globalAudioPlayer.duration)%60))
            }
            
            
            if globalPlayerURL == currentURL{
                self.sermonProgressView.setProgress(Float(globalAudioPlayer.currentTime/globalAudioPlayer.duration), animated: true)
                updateTimer()
            }
            else{
                self.sermonPlayButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            }
            if globalAudioPlayer.rate == 2.0 && globalPlayerURL == currentURL{
                self.sermonRateButton.setTitle("2X", for: .normal)
                updateTimer()
            }
            else{
                self.sermonRateButton.setTitle("1X", for: .normal)
            }
            
        }
    }
    
    func loadAudio(){
        audioItem = DefaultAudioItem(audioUrl: self.currentURL, sourceType: .stream)
        try! globalAudioPlayer.load(item: audioItem, playWhenReady: true)
    }
        
    @IBAction func sermonRateButtonPressed(_ sender: UIButton) {
        if globalAudioPlayer.rate == 1.0 {
            DispatchQueue.main.async {
                globalAudioPlayer.rate = 2.0
            }
        }
        else{
            DispatchQueue.main.async {
            globalAudioPlayer.rate = 1.0
            }
        }
    }
    
    
    @IBAction func sermonOptionButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func sermonProgressSliderDragged(_ sender: Any) {
        
    }
    
}
