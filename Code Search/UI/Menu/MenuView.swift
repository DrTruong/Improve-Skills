//
//  MenuView.swift
//  Code Search
//
//  Created by Kis User on 4/27/21.
//

import UIKit

protocol ShowViewButtonDelegate {
    func showMenuPrivacyView(title: String)
    func showMenuAboutAppView(title: String)
    func showMenuRemoveAllView(title: String)
}

class MenuView: UIView{
    
    var delegate: ShowViewButtonDelegate?
    
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var aboutAppButton: UIButton!
    @IBOutlet weak var removeAllButton: UIButton!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupMenuView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupMenuView()
    }
    
    func setupMenuView(){
        let menuView = Bundle.main.loadNibNamed("MenuView", owner: self, options: nil)![0] as! UIView
        menuView.frame = self.bounds
        addSubview(menuView)
    }
    
    @IBAction func privacyButtonDidTouch(_ sender: UIButton) {
        delegate?.showMenuPrivacyView(title: self.privacyButton.currentTitle!)
    }
    
    @IBAction func aboutAppButtonDidTouch(_ sender: UIButton) {
        delegate?.showMenuAboutAppView(title: self.aboutAppButton.currentTitle!)
    }
    
    @IBAction func removeAllButtonDidTouch(_ sender: UIButton) {
        delegate?.showMenuRemoveAllView(title: self.removeAllButton.currentTitle!)
    }
}


