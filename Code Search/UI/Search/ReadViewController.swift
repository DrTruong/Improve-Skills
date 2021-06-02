//
//  ReadViewController.swift
//  Code Search
//
//  Created by Kis User on 4/26/21.
//

import UIKit
import AVFoundation

import QRBarcodeLib

protocol StartCameraDelegate {
    func startCamera()
}

class ReadViewController: UIViewController, StartCameraDelegate {

    @IBOutlet weak var searchView: UIView!
    private var scanView: BarcodeScanView!
    let mainTabController: MainTabBarController? = nil
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTabController?.startCameraDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.scanView = BarcodeScanView(parent: self.searchView)
        BarcodeScanLib.shared.start(barcodeScanView: self.scanView, listener: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        BarcodeScanLib.shared.stop()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let _searchView = self.searchView {
            _searchView.setNeedsLayout()
            _searchView.layoutIfNeeded()
        }
        if let _scanView = self.scanView {
            _scanView.setNeedsLayout()
            _scanView.layoutIfNeeded()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpTabBar()
    }
    
    // MARK: - Set up functions
    func setUpTabBar() {
        let tabBar = self.tabBarController?.tabBar
        tabBar?.backgroundColor = .clear
        tabBar?.selectionIndicatorImage = UIImage().createSelectionIndicate(color: UIColor.white, size: CGSize(width: tabBar!.frame.width/CGFloat(tabBar!.items!.count), height:  tabBar!.frame.height), lineWidth: 5.0)
        
        tabBarController?.tabBar.tintColor = UIColor.white
        tabBarController?.tabBar.unselectedItemTintColor = UIColor.lightGray
    }
    
    func startCamera() {
        BarcodeScanLib.shared.start(barcodeScanView: scanView, listener: self)
    }
}

extension ReadViewController: BarcodeRecognizeListener {
    
    func onSuccess(codes: Array<BarcodeScanResult>) {
        for code in codes {
            BarcodeCoreDataHelper.createIfNotExist(opened: false, value: code.rawValue)
        }
    }
    
    func onError(error: Error) {
        print("Failed to scan barcodes with error: \(error.localizedDescription).")
    }
    
}

extension UIImage{
    
    func createSelectionIndicate(color: UIColor, size: CGSize, lineWidth: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x: size.width / 4, y: 0, width: size.width / 2, height: lineWidth))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}
