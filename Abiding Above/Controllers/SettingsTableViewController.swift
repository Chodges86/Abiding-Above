//
//  SettingsTableViewController.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 2/17/22.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var versionNumber: UILabel!
    @IBOutlet weak var supportEmailButton: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        versionNumber.text = appVersion
    }
    
    @IBAction func supportEmailTapped(_ sender: UIButton) {
        
        let email = "caleb.hodges0606@gmail.com"
        if let url = URL(string: "mailto:\(email)") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
        
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
