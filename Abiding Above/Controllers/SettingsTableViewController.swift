//
//  SettingsTableViewController.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 2/17/22.
//

import UIKit


var versionSelected = BibleVersion.NASB

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var versionNumber: UILabel!
    @IBOutlet weak var supportEmailButton: UIButton!
    @IBOutlet weak var versionSelector: UIButton!
    
    let defaults = UserDefaults.standard
    var nasbState: UIMenu.State = .on
    var nltState: UIMenu.State = .off
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .systemBlue
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        versionNumber.text = appVersion
        setVersionOption()
        
        if defaults.string(forKey: "version") == nil {
            versionSelector.setTitle("Version", for: .normal)
        } else {
            versionSelector.setTitle(defaults.string(forKey: "version"), for: .normal)
        }
    }
    
    @IBAction func supportEmailTapped(_ sender: UIButton) {
        
        let email = "chodgesdev@gmail.com"
        if let url = URL(string: "mailto:\(email)") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
    }
    func setVersionOption() {
        
        let optionClosure = {(action: UIAction) in
            
            switch action.title {
            case "NASB":
                self.defaults.set("NASB", forKey: "version")
                self.versionSelector.setTitle(action.title, for: .normal)
                versionSelected = .NASB
            case "NLT":
                break // NLT Version not available yet
            case "NIV":
                break // NIV Version not available yet
            default:
                versionSelected = .NASB
            }
            
        }
        // Add more versions to menu here when versions are available
        versionSelector.menu = UIMenu(children: [
            UIAction(title: "NASB", handler: optionClosure)])
        
        versionSelector.showsMenuAsPrimaryAction = true


    }
   
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath == IndexPath(row: 3, section: 0) {
            performSegue(withIdentifier: "CopyrightSegue", sender: self)
        }
    }
}
