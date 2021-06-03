//
//  RandomColorView.swift
//  ImproveDelegate
//
//  Created by Dr.Truong on 02/06/2021.
//

import UIKit

class RandomColorView: UIView {

    @IBOutlet weak var colorView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupRandomColorView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupRandomColorView()
    }
    
    private func setupRandomColorView() {
        let view = Bundle.main.loadNibNamed("RandomColorView", owner: self, options: nil)![0] as! UIView
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
    }

}
