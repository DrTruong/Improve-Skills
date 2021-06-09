//
//  ImageCaptureView.swift
//  SmileCameraApp
//
//  Created by Dr.Truong on 08/06/2021.
//

import UIKit

class ImageCaptureView: UIView {

    @IBOutlet weak var imageCaptureView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        
        print("image capture view")
    }
    
    private func setupView() {
        let view = Bundle.main.loadNibNamed("ImageCaptureView", owner: self, options: nil)![0] as! UIView
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
    }

}
