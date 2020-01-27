//
//  ViewController.swift
//  d20forSpring2020
//
//  Created by Tendaishe Gwini on 1/26/20.
//  Copyright © 2020 Tendaishe Gwini. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        imageTapGestureRecognizer.numberOfTapsRequired = 1
        imageTapGestureRecognizer.addTarget(self, action: #selector(tapToRoll))
        diceImageView.addGestureRecognizer(imageTapGestureRecognizer)
    }


    //MARK: Properties
    
    /**The sound effects that are going to be used for the rolls and different results. The audio resource names are saved as Raw values for the enum cases*/
    private enum SoundEffect: String {
        case fail = "failwah.mp3"
        case roll = "rolldice.mp3"
        case fanfare = "zfanfare.mp3"
    }
    
    private var diceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "d1")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private var diceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Dice Game"
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    let imageTapGestureRecognizer = UITapGestureRecognizer()
    
    private var soundEffectPlayer: AVAudioPlayer?
    
    //MARK: Methods
    
    private func setupView() {
        
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.addSubview(diceImageView)
        view.addSubview(diceLabel)
        
        diceLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        diceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        diceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        diceLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        diceImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        diceImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        diceImageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        diceImageView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        //Handle what may happen after rotation
        diceImageView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        diceImageView.bottomAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        
    }
    
    /**Rolls the die. Total rolls can be changed during call to determine how many rolls should appear before final result*/
    func rollDie(counter: Int = 0, totalRolls: Int = 5, randomNumber: Int = 0) {
        
        if counter == totalRolls {
            if randomNumber == 7 {
                soundEffectPlayer = provideSound(effect: .fail)
                soundEffectPlayer?.play()
            }
            return
        }
        
        let randomNumber: Int = Int.random(in: 1...20)
        let imageName: String = "d\(randomNumber)"
        diceImageView.image = UIImage(named: imageName)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.rollDie(counter: counter + 1, randomNumber: randomNumber)
        }
   
    }
    
    private func provideSound(effect: SoundEffect) -> AVAudioPlayer {
        
        var player = AVAudioPlayer()
        let path = Bundle.main.path(forResource: effect.rawValue, ofType: nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("File could not be loaded")
        }
        return player
        
    }
    
    
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollDie()
        soundEffectPlayer = provideSound(effect: .roll)
        soundEffectPlayer?.play()
    }
    
    @objc func tapToRoll() {
        rollDie()
        soundEffectPlayer = provideSound(effect: .roll)
        soundEffectPlayer?.play()
    }
    
}

