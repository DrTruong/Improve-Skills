//
//  RandomNumberView.swift
//  ImproveDelegate
//
//  Created by Dr.Truong on 02/06/2021.
//

import UIKit

class RandomNumberView: UIView {    
    @IBOutlet weak var numberView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupRandomNumberView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupRandomNumberView()
    }
    
    private func setupRandomNumberView() {
        let view = Bundle.main.loadNibNamed("RandomNumberView", owner: self, options: nil)![0] as! UIView
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
    }
    
}
