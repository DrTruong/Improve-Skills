//
//  ViewController.swift
//  ImproveDelegate
//
//  Created by Dr.Truong on 02/06/2021.
//

import UIKit

protocol TransitRandomlDelegate {
    func changeLable(newLabel: String)
    func changeColor(color: UIColor)
}

@available(iOS 13.0, *)
class ViewController: UIViewController {

    private var buttonView = ButtonView()
    
    @IBOutlet weak var randomNumberView: RandomNumberView!
    @IBOutlet weak var randomColorView: RandomColorView!
    @IBOutlet weak var randomButtonView: ButtonView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonView.randDelegate = self
    }
    
}

@available(iOS 13.0, *)
extension ViewController: TransitRandomlDelegate {
    func changeLable(newLabel: String) {
        self.randomNumberView.numberLabel.text = newLabel
    }
    
    func changeColor(color: UIColor) {
        self.randomColorView.colorView.backgroundColor = color
    }
}
