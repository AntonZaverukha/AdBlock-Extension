//
// ViewController.swift
// ContentBlocker
//
// Created by Anton on 15.04.2023.
//
import UIKit
import SafariServices

class ViewController: UIViewController {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var disableButton: UIButton!
    @IBOutlet weak var activatedRulesView: UIView!
    @IBOutlet weak var activeStateLabel: UILabel!
    @IBOutlet weak var tapToActivateLabel: UILabel!
    @IBOutlet weak var shieldImage: UIImageView!
    @IBOutlet weak var enableButton: UIButton!
    
    struct Colors {
        static let blue = UIColor(red: 47/255, green: 128/255, blue: 237/255, alpha: 1.0)
        static let yellow = UIColor(red: 245/255, green: 192/255, blue: 2/255, alpha: 1.0)
    }
    
    var sharedContainerURL: URL? {
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.AntonZ.ContentBlocker")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableButton.layer.cornerRadius = 16
        enableButton.layer.masksToBounds = true
        disableButton.layer.cornerRadius = 16
        disableButton.layer.masksToBounds = true
        
        let isEnabled = loadAdblockerState()
        if isEnabled {
            adBlockTurnedOn(Colors.blue)
        } else {
            adBlockTurnedOff(Colors.yellow)
        }
    }
    
    @IBAction func switchToDisableRules(_ sender: UIButton) {
        updateRules(isEnabled: false)
        adBlockTurnedOff(Colors.yellow)
        saveAdblockerState(isEnabled: false)
    }
    
    @IBAction func switchToEnableRules(_ sender: UIButton) {
        updateRules(isEnabled: true)
        adBlockTurnedOn(Colors.blue)
        saveAdblockerState(isEnabled: true)
    }
}

extension ViewController {
    func saveAdblockerState(isEnabled: Bool) {
        UserDefaults.standard.set(isEnabled, forKey: "adblockerState")
    }
    
    func loadAdblockerState() -> Bool {
        return UserDefaults.standard.bool(forKey: "adblockerState")
    }
    
    func adBlockTurnedOn(_ blueColor: UIColor) {
        headerLabel.textColor = blueColor
        activatedRulesView.backgroundColor = blueColor
        activeStateLabel.textColor = blueColor
        activeStateLabel.text = "Guard activated"
        tapToActivateLabel.textColor = blueColor
        tapToActivateLabel.text = "Tap to disable"
        shieldImage.image = UIImage(named: "Image 9")
        disableButton.isHidden = false
        enableButton.isHidden = true
    }
    
    func adBlockTurnedOff(_ yellowColor: UIColor) {
        headerLabel.textColor = yellowColor
        activatedRulesView.backgroundColor = yellowColor
        activeStateLabel.textColor = yellowColor
        activeStateLabel.text = "Guard deactivated"
        tapToActivateLabel.textColor = yellowColor
        tapToActivateLabel.text = "Tap to activate"
        shieldImage.image = UIImage(named: "Image 10")
        enableButton.backgroundColor = yellowColor
        disableButton.isHidden = true
        enableButton.isHidden = false
    }
    
    func updateRules(isEnabled: Bool) {
        guard let sharedContainer = sharedContainerURL else {
            print("Error accessing shared container")
            return
        }
        
        guard let blockInstagramURL = Bundle.main.url(forResource: "block_instagram", withExtension: "json"),
              let noRulesURL = Bundle.main.url(forResource: "no_rules", withExtension: "json") else {
            print("Error accessing JSON files")
            return
        }
        
        let blockRulesURL = sharedContainer.appendingPathComponent("block_rules.json")
        let currentRules = try? String(contentsOf: blockRulesURL)
        let newRulesURL = isEnabled ? blockInstagramURL : noRulesURL
        
        try? FileManager.default.removeItem(at: blockRulesURL)
        try? FileManager.default.copyItem(at: newRulesURL, to: blockRulesURL)
        
        SFContentBlockerManager.reloadContentBlocker(withIdentifier: "AntonZ.ContentBlocker.ContentBlockerEx") { error in
            if let error = error {
                print("Error reloading content blocker: \(error)")
            }
            print("reloaded")
        }
    }
}
