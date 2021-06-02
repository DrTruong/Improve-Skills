//
//  MenuViewController.swift
//  Code Search
//
//  Created by Kis User on 4/27/21.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var menuView: MenuView!
    
    var hasRemoveAll: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if hasRemoveAll {
            menuView.removeAllButton.isHidden = false
            menuView.removeAllButton.setTitle("Remove all", for: .normal)
        } else {
            menuView.removeAllButton.isHidden = true
        }
        menuView.privacyButton.setTitle("Help", for: .normal)
        menuView.aboutAppButton.setTitle("About", for: .normal)
        menuView.delegate = self.delegate
    }
    
    var delegate: ShowViewButtonDelegate?

}
