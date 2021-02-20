//
//  ViewController.swift
//  Slot Machine
//
//  Created by Raj Kumar Shahu and Supriya Gadkari
//  Created on 2021-02-09.
//  @Description: Add logic to the User Interface (UI) for the Slot Machine App

import UIKit
import Lottie
import AVFoundation
import Canvas

class ViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer?
    
    @IBOutlet weak var balanceLabel: UILabel!
    
    var balance: Int = 0 {
        didSet {
            balanceLabel.text = "\(balance)"
        }
    }
    
    @IBOutlet weak var betLabel: UILabel!
    
    var bet: Int = 0 {
        didSet {
            betLabel.text = "\(bet)"
        }
    }
    
    @IBOutlet weak var jackPotLabel: UILabel!
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var thirdImage: UIImageView!
    @IBOutlet weak var fourthImage: UIImageView!
    @IBOutlet weak var fifthImage: UIImageView!
    @IBOutlet weak var sixthImage: UIImageView!
    @IBOutlet weak var seventhImage: UIImageView!
    @IBOutlet weak var eighthImage: UIImageView!
    @IBOutlet weak var ninethImage: UIImageView!
    @IBOutlet weak var decreaseButtonImage: UIButton!
    @IBOutlet weak var increaseBtnImage: UIButton!
    @IBOutlet weak var spinButtonImage: UIButton!
    @IBOutlet weak var jackpotLineImage: UIImageView!
    
    @IBOutlet weak var diagonalLineImage: UIImageView!
    
    
    @IBOutlet weak var spinAreaAnimation: CSAnimationView!
    
    @IBOutlet weak var jackpotImage: UIImageView!
    
    let animationView = AnimationView()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        reset()
    }
    
    @IBAction func btnReset(_ sender: Any) {
        reset()
    }
    
    @IBAction func quitButton(_ sender: UIButton) {
        let quitAlert = UIAlertController(title: "Quit", message: "Do you really want to quit?.", preferredStyle: UIAlertController.Style.alert)
        
        quitAlert.addAction(UIAlertAction(title: "Quit", style: .destructive, handler: { (action: UIAlertAction!) in
            exit(0)
        }))
        
        quitAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Cancelled")
        }))
        
        present(quitAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func btnSpin(_ sender: UIButton) {
        
        updateImages()
        
        self.setupSpinAreaAnimation(spinColumn: spinAreaAnimation, duration: 0.01, delay: 0.01, type: "bounceUp")
        
        balance = balance - bet
        
        if  balance == 0  {
            bet = 0
            spinButtonImage.isEnabled = false
            decreaseButtonImage.isEnabled = false
            increaseBtnImage.isEnabled = false
        }
        
        if bet > balance {
            
            increaseBtnImage.isEnabled = false
            spinButtonImage.isEnabled = false
        }
        playSound(sound: "slot-machine", type: "mp3")
        determineWinnings()
    }
    
    @IBAction func btnBetIncrease(_ sender: UILongPressGestureRecognizer) {
        
        bet += 10
        balance -= 10
        if balance < bet {
            increaseBtnImage.isEnabled = false
            spinButtonImage.isEnabled = false
        } else if bet >= 10 {
            decreaseButtonImage.isEnabled = true
        }
        else {
            spinButtonImage.isEnabled = true
            increaseBtnImage.isEnabled = true
            balance -= 10
        }
    }
    
    @IBAction func btnBetDecrease(_ sender: UIButton) {
        
        if balance <= 10  {
            balance += 10
            spinButtonImage.isEnabled = true
            
        } else if bet >= 10 {
            bet -= 10
            balance += 10
            decreaseButtonImage.isEnabled = true
            if bet > balance {
                spinButtonImage.isEnabled = false
            } else {
                spinButtonImage.isEnabled = true
                increaseBtnImage.isEnabled = true
            }
        } else if bet == 0 {
            balance += 0
            decreaseButtonImage.isEnabled = false
        }
    }
    
    
    @IBAction func btnHelp(_ sender: UIButton) {
        playSound(sound: "casino-chips", type: "mp3")
        
    }
    
    
    // MARK: - reset Function
    
    func reset() {
        balance = 1000
        bet = 10
        spinButtonImage.isEnabled = true
        decreaseButtonImage.isEnabled = true
        increaseBtnImage.isEnabled = true
        jackpotImage.image = nil
        jackPotLabel.text = "1000"
        jackpotLineImage.image = nil
        firstImage.image = UIImage(named: "bell")
        secondImage.image = UIImage(named: "cherry")
        thirdImage.image = UIImage(named: "crown")
        fourthImage.image = UIImage(named: "diamond")
        fifthImage.image = UIImage(named: "bell")
        sixthImage.image = UIImage(named: "leaf")
        seventhImage.image = UIImage(named: "magnet")
        eighthImage.image = UIImage(named: "seven")
        ninethImage.image = UIImage(named: "star")
        playSound(sound: "chimeup", type: "mp3")
        self.setupSpinAreaAnimation(spinColumn: spinAreaAnimation, duration: 0.01, delay: 0.02, type: "shake")
        
    }
    
    // MARK: - updateImages Function
    
    func updateImages () {
        
        let seven = [String](repeating: "seven", count: 40) // 5.5%
        let bell = [String](repeating: "bell", count: 50) // 7%
        let cherry = [String](repeating: "cherry", count: 55) // 7.6%
        let crown = [String](repeating: "crown", count: 57) // 7.9%
        let diamond = [String](repeating: "diamond", count: 60) // 8.3%
        let leaf = [String](repeating: "leaf", count: 70) // 9.7%
        let magnet = [String](repeating: "magnet", count: 80) // 11%
        let star = [String](repeating: "star", count: 90) // 12.5
        let strawberry = [String](repeating: "strawberry", count: 100) // 13.9
        let watermelon = [String](repeating: "watermelon", count: 120) // 16.7
        
        
        let imageList = seven + bell + cherry + crown + diamond + leaf + magnet + star + strawberry + watermelon
        
        firstImage.image = UIImage(named: imageList.randomElement()!)
        secondImage.image = UIImage(named: imageList.randomElement()!)
        thirdImage.image = UIImage(named: imageList.randomElement()!)
        fourthImage.image = UIImage(named: imageList.randomElement()!)
        fifthImage.image = UIImage(named: imageList.randomElement()!)
        sixthImage.image = UIImage(named: imageList.randomElement()!)
        seventhImage.image = UIImage(named: imageList.randomElement()!)
        eighthImage.image = UIImage(named: imageList.randomElement()!)
        ninethImage.image = UIImage(named: imageList.randomElement()!)
    }
    
    // MARK: - setupCoinAnimation Function
    
    func setupCoinAnimation() {
        animationView.animation = Animation.named("coin-collect")
        animationView.frame = CGRect(x: 75, y: 160, width: 300, height: 300)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        view.addSubview(animationView)
        animationView.play()
    }
    
    // MARK: - determineWinnings Function
    
    func determineWinnings() {
        
        let seven = UIImage(named: "seven")
        let bell = UIImage(named: "bell")
        let cherry = UIImage(named: "cherry")
        let crown = UIImage(named: "crown")
        let diamond = UIImage(named: "diamond")
        let leaf = UIImage(named: "leaf")
        let magnet = UIImage(named: "magnet")
        let star = UIImage(named: "star")
        let strawberry = UIImage(named: "strawberry")
        let watermelon = UIImage(named: "watermelon")
        
        if (secondImage.image == seven && fifthImage.image == seven && eighthImage.image == seven ) || (firstImage.image == seven && fifthImage.image == seven && ninethImage.image == seven) {
            jackPotLabel.text = "Jackpot!!!!!!"
            balance = balance + 1000
            // jackpotLineImage.image = UIImage(named: "jackpotLine")
            jackpotImage.image = UIImage(named: "jackpotImage")
            
            playSound(sound: "high-score", type: "mp3")
            
            animationView.animation = Animation.named("stars-winner")
            animationView.frame = CGRect(x: 75, y: 160, width: 300, height: 300)
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            view.addSubview(animationView)
            animationView.play()
            
        } else if secondImage.image == seven && fifthImage.image == seven {
            jackPotLabel.text = "Win 300"
            balance = balance + 300
            setupCoinAnimation()
            playSound(sound: "coin-collect", type: "mp3")
            
        } else if (secondImage.image == bell && fifthImage.image == bell && eighthImage.image == bell) || (firstImage.image == bell && fifthImage.image == bell && ninethImage.image == bell) {
            jackPotLabel.text = "Win 200"
            balance = balance + 200
            playSound(sound: "coin-collect", type: "mp3")
            setupCoinAnimation()
            
        } else if secondImage.image == bell && fifthImage.image == bell {
            jackPotLabel.text = "Win 100"
            balance = balance + 100
            playSound(sound: "coin-collect", type: "mp3")
            setupCoinAnimation()
            
        } else if (secondImage.image == cherry && fifthImage.image == cherry && eighthImage.image == cherry) || (firstImage.image == cherry && fifthImage.image == cherry && ninethImage.image == cherry) {
            jackPotLabel.text = "Win 150"
            balance = balance + 150
            playSound(sound: "coin-collect", type: "mp3")
            setupCoinAnimation()
            
        } else if secondImage.image == cherry && fifthImage.image == cherry {
            jackPotLabel.text = "Win 75"
            balance = balance + 75
            playSound(sound: "coin-collect", type: "mp3")
            setupCoinAnimation()
            
        } else if (secondImage.image == crown && fifthImage.image == crown && eighthImage.image == crown ) || (firstImage.image == crown && fifthImage.image == crown && ninethImage.image == crown) {
            jackPotLabel.text = "Win 125"
            balance = balance + 125
            playSound(sound: "coin-collect", type: "mp3")
            setupCoinAnimation()
            
        } else if secondImage.image == crown && fifthImage.image == crown {
            jackPotLabel.text = "Win 65"
            balance = balance + 65
            playSound(sound: "coin-collect", type: "mp3")
            setupCoinAnimation()
            
        } else if (secondImage.image == diamond && fifthImage.image == diamond && eighthImage.image == diamond) || (firstImage.image == diamond && fifthImage.image == diamond && ninethImage.image == diamond) {
            jackPotLabel.text = "Win 100"
            balance = balance + 100
            playSound(sound: "coin-collect", type: "mp3")
            setupCoinAnimation()
            
        } else if secondImage.image == diamond && fifthImage.image == diamond {
            jackPotLabel.text = "Win 60"
            balance = balance + 60
            playSound(sound: "coin-collect", type: "mp3")
            setupCoinAnimation()
            
        } else if secondImage.image == leaf && fifthImage.image == leaf && eighthImage.image == leaf  {
            jackPotLabel.text = "Win 90"
            balance = balance + 90
            playSound(sound: "coin-collect", type: "mp3")
            setupCoinAnimation()
            
        } else if secondImage.image == leaf && fifthImage.image == leaf {
            jackPotLabel.text = "Win 50"
            balance = balance + 50
            playSound(sound: "coin-collect", type: "mp3")
            setupCoinAnimation()
            
        } else if secondImage.image == magnet && fifthImage.image == magnet && eighthImage.image == magnet  {
            jackPotLabel.text = "Win 125"
            balance = balance + 125
            playSound(sound: "coin-collect", type: "mp3")
            setupCoinAnimation()
            
        } else if secondImage.image == magnet && fifthImage.image == magnet {
            jackPotLabel.text = "Win 50"
            balance = balance + 50
            playSound(sound: "coin-collect", type: "mp3")
            setupCoinAnimation()
            
        } else if secondImage.image == star && fifthImage.image == star && eighthImage.image == star  {
            jackPotLabel.text = "Win 70"
            balance = balance + 70
            playSound(sound: "coin-collect", type: "mp3")
            setupCoinAnimation()
            
        } else if secondImage.image == star && fifthImage.image == star {
            jackPotLabel.text = "Win 40"
            balance = balance + 40
            playSound(sound: "coin-collect", type: "mp3")
            setupCoinAnimation()
            
        } else if secondImage.image == strawberry && fifthImage.image == strawberry && eighthImage.image == strawberry  {
            jackPotLabel.text = "Win 50"
            balance = balance + 50
            playSound(sound: "coin-collect", type: "mp3")
            setupCoinAnimation()
            
        } else if secondImage.image == strawberry && fifthImage.image == strawberry {
            jackPotLabel.text = "Win 35"
            balance = balance + 35
            playSound(sound: "coin-collect", type: "mp3")
            setupCoinAnimation()
            
        } else if secondImage.image == watermelon && fifthImage.image == watermelon && eighthImage.image == watermelon  {
            jackPotLabel.text = "Win 25"
            balance = balance + 25
            playSound(sound: "coin-collect", type: "mp3")
            setupCoinAnimation()
            
        } else if secondImage.image == watermelon && fifthImage.image == watermelon {
            jackPotLabel.text = "Win 10"
            balance = balance + 10
            setupCoinAnimation()
            playSound(sound: "coin-collect", type: "mp3")
            setupCoinAnimation()
        }
        else {
            jackPotLabel.text = "1000"
            jackpotLineImage.image = nil
            // diagonalLineImage.image = nil
            jackpotImage.image = nil
            animationView.stop()
        }
    }
    
    // MARK: - playSound Function
    
    func playSound(sound: String, type: String) {
        if let path = Bundle.main.path(forResource: sound, ofType: type){
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.play()
            } catch {
                print("Error occured while fetching the sound file!")
            }
        }
    }
    
    func setupSpinAreaAnimation(spinColumn: CSAnimationView, duration: TimeInterval, delay: TimeInterval, type: String) {
        spinColumn.duration = duration
        spinColumn.type = type
        spinColumn.delay = delay
        self.view.addSubview(spinColumn)
        spinColumn.startCanvasAnimation()
    }
}

