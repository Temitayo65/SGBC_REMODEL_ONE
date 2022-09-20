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

// for later
public var globalVideoURL: String = ""


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
    let videoPath = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
    
    let playerViewController = AVPlayerViewController()
    var vplayer = AVPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // For Video
            guard let url = URL(string: videoPath) else { return }
            globalVideoURL = videoPath
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
    
    // re-write this also when you have enough data from an api 
    override func viewWillDisappear(_ animated: Bool) {
        if #available(iOS 16.0, *) {
            vplayer.pause()
            //vplayer.replaceCurrentItem(with: AVPlayerItem(url: URL(filePath: "")))
        } else {
            // Fallback on earlier versions
        }
    }
    
    // re-write this when you have enough data from an api
    override func viewWillAppear(_ animated: Bool) {
            if #available(iOS 16.0, *) {
                if globalVideoURL != videoPath{
                    vplayer.replaceCurrentItem(with: AVPlayerItem(url: URL(filePath: "")))
                    vplayer.replaceCurrentItem(with: AVPlayerItem(url: URL(filePath: videoPath)))
                }
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
            if globalAudioPlayer.playerState == .playing{
                globalAudioPlayer.pause()
                playPauseButton.updateUI()
            }
            self.hideAndRevealButtons(setTo: true)
            vplayer.play()
            view.addSubview(playerViewController.view)
            playerViewController.didMove(toParent: self)
            view.addSubview(playPauseButton)
            playPauseButton.setup(in: self)
        }
        else {
            self.hideAndRevealButtons(setTo: false)
            playerViewController.view.removeFromSuperview()
            playPauseButton.removeFromSuperview()
            vplayer.pause()
            playPauseButton.updateUI()
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
