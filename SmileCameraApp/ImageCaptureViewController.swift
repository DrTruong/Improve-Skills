//
//  ImageCaptureViewController.swift
//  SmileCameraApp
//
//  Created by Dr.Truong on 08/06/2021.
//

import UIKit

class ImageCaptureViewController: UIViewController {

    @IBOutlet weak var captureView: ImageCaptureView!
    
    var captureImage = UIImage()
    
    private var cameraViewController = CameraViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        
        cameraViewController.takePhotoDelegate = self.capturePicture() as? CapturePictureDelegate

        print("image capture view controller")
        
    }
    
}

extension ImageCaptureViewController: CapturePictureDelegate {
    func capturePicture() {
        self.captureView.imageCaptureView.image = self.captureImage
        print("this is image capture view controller")
    }
}
