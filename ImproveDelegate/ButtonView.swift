//
//  ButtonView.swift
//  ImproveDelegate
//
//  Created by Dr.Truong on 02/06/2021.
//

import UIKit

@available(iOS 13.0, *)
class ButtonView: UIView {

    var randDelegate: TransitRandomlDelegate?
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var buttonLabel: UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtonView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButtonView()
    }
    
    private func setupButtonView() {
        let view = Bundle.main.loadNibNamed("ButtonView", owner: self, options: nil)![0] as! UIView
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
    }

    @IBAction func randomDidTouch(_ sender: Any) {
        let randomNumber = Int.random(in: 0...100)
        
        let randomColor = CGColor(red: CGFloat(Double.random(in: 0...1)), green: CGFloat(Double.random(in: 0...1)), blue: CGFloat(Double.random(in: 0...1)), alpha: 1)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.randDelegate!.changeLable(newLabel: String(format: "%.0f", randomNumber))
            self.randDelegate!.changeColor(color: UIColor(cgColor: randomColor))
        })
    
        print(randomNumber)
        print(randomColor.components as Any)
    }
}
