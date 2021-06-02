//
//  MainTabBarController.swift
//  Code Search
//
//  Created by Kis User on 5/5/21.
//

import UIKit
import QRBarcodeLib

class MainTabBarController: UITabBarController {
    
    private var historyDelegate: HistoryViewControllerDelegate? = nil
    
    var startCameraDelegate: StartCameraDelegate? = nil
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegate()
        setUpUI()
    }
    
    func setUpDelegate() {
        for viewController in self.viewControllers ?? [] {
            if viewController is HistoryViewController {
                historyDelegate = viewController as? HistoryViewControllerDelegate
            }
            if viewController is ReadViewController {
                startCameraDelegate = viewController as? ReadViewController
            }
        }
    }
    
    func setUpUI() {
        transparentNavigationBar()
        transparentTabBar()
    }
    
    @IBAction func showMenuButtonDidTouch(_ sender: UIBarButtonItem) {
        BarcodeScanLib.shared.stop()
        
        let optionVC = MenuViewController()
        
        optionVC.hasRemoveAll = self.selectedIndex == 1
        
        optionVC.delegate = self
        
                
        optionVC.modalPresentationStyle = .popover
        
        let barButtonItem = self.navigationItem.rightBarButtonItem
        let buttonItemView = barButtonItem!.value(forKey: "view") as? UIView
        buttonItemView?.frame = buttonItemView!.bounds
        
        let screenSizeWidth = UIScreen.main.bounds.width
        
        let window = UIApplication.shared.windows[0]
        let topPadding = window.safeAreaInsets.top
        let bottomPadding = window.safeAreaInsets.bottom
        
        let popover = optionVC.popoverPresentationController
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        popover?.sourceView = self.view
        
        optionVC.preferredContentSize = CGSize(width: 200, height: 100)
        
        if(bottomPadding==0){
            popover?.sourceRect = CGRect(x: screenSizeWidth-(buttonItemView?.center.x)!, y: ((buttonItemView?.center.y)!)-15, width: (buttonItemView?.frame.size.width)!, height: (buttonItemView?.frame.size.height)!)
        }else{
            popover?.sourceRect = CGRect(x: screenSizeWidth-(buttonItemView?.center.x)!, y: ((buttonItemView?.center.y)!)+(topPadding-bottomPadding), width: (buttonItemView?.frame.size.width)!, height: (buttonItemView?.frame.size.height)!)
        }
        
        popover?.delegate = self
        
        self.present(optionVC, animated: true, completion: nil)
    }
    
    func transparentNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
    
    func transparentTabBar() {
        self.tabBar.barTintColor = UIColor.clear
        self.tabBar.shadowImage = UIImage()
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.isTranslucent = true
        self.tabBar.backgroundColor = .clear
    }
    
    
}

extension MainTabBarController: UIPopoverPresentationControllerDelegate {
  
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
     
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        startCameraDelegate?.startCamera()
    }
     
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
    
}

extension MainTabBarController: ShowViewButtonDelegate{
    func showMenuPrivacyView(title: String) {
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        let privacyButtonView = PrivacyButtonViewController()
        privacyButtonView.title = title
        self.navigationController?.pushViewController(privacyButtonView, animated: true)
    }
    
    func showMenuAboutAppView(title: String) {
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        let aboutAppButonView = AboutAppViewController()
        aboutAppButonView.title = title
        self.navigationController?.pushViewController(aboutAppButonView, animated: true)
    }
    
    func showMenuRemoveAllView(title: String) {
        let alert = UIAlertController(title: "", message: "Are you sure you want to delete all items", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            self.presentedViewController?.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.historyDelegate?.onDeleteAll()
            self.presentedViewController?.dismiss(animated: true, completion: nil)
        }))
        self.presentedViewController?.present(alert, animated: true, completion: nil)
    }
}
