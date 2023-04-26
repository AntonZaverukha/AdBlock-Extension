//
//  ViewController.swift
//  Blocker
//
//  Created by Anton on 13.04.2023.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var blockerButton: UIButton!

    var isBlockerEnabled = true

    override func viewDidLoad() {
        super.viewDidLoad()

        blockerButton.isEnabled = false

        ContentBlockerManager.shared.isExtensionEnabled { isEnabled in
            DispatchQueue.main.async {
                self.blockerButton.isEnabled = isEnabled
                self.isBlockerEnabled = isEnabled
                self.blockerButton.setTitle(isEnabled ? "Disable Instagram Blocker" : "Enable Instagram Blocker", for: .normal)
            }
        }
    }

    @IBAction func blockerButtonTapped(_ sender: Any) {
        if isBlockerEnabled {
            ContentBlockerManager.shared.disableInstagramBlocker { error in
                DispatchQueue.main.async {
                    if error == nil {
                        self.isBlockerEnabled = false
                        self.blockerButton.setTitle("Enable Blocker", for: .normal)
                    } else {
                        self.showErrorAlert(error: error)
                    }
                }
            }
        } else {
            ContentBlockerManager.shared.enableInstagramBlocker { error in
                DispatchQueue.main.async {
                    if error == nil {
                        self.isBlockerEnabled = true
                        self.blockerButton.setTitle("Disable Blocker", for: .normal)
                    } else {
                        self.showErrorAlert(error: error)
                    }
                }
            }
        }
    }

    private func showErrorAlert(error: Error?) {
        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription ?? "Unknown error", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

