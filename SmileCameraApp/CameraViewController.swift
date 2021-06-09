//
//  CameraViewController.swift
//  SmileCameraApp
//
//  Created by Dr.Truong on 09/06/2021.
//

import UIKit
import AVFoundation
import SmileCameraLib

protocol CapturePictureDelegate {
    func capturePicture()
}

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var buttonTake: UIButton!
    
    var captureImageView = UIImage()
    
    var takePhotoDelegate: CapturePictureDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CameraManager.share.startCamera(previewview: previewView)
        
        buttonTake.backgroundColor = .none
        buttonTake.layer.cornerRadius = buttonTake.frame.height/2
        buttonTake.layer.borderWidth = 5
        buttonTake.layer.borderColor = UIColor.white.cgColor
        
        previewView.addSubview(buttonTake)
        
        print("camera view controller")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToImageCaptured" {
            let destinationVC = segue.destination as! ImageCaptureViewController
            destinationVC.captureImage = self.captureImageView
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        if let imageData = photo.fileDataRepresentation(){
//            self.captureImageView = UIImage(data: imageData)!
//            // save capture
//            UIImageWriteToSavedPhotosAlbum(self.captureImageView, nil, nil, nil)
//            dismiss(animated: true, completion: nil)
//            print("Save successful")
//        }
        
        if let imageData = photo.fileDataRepresentation() {
            let image = UIImage(data: imageData)
            captureImageView = image!
            
            performSegue(withIdentifier: "goToImageCaptured", sender: nil)
        }

        
    
    }
    
    @IBAction func didTakePhoto(_ sender: Any) {
        CameraManager.share.didTakePhoto(delegate: self)
        self.takePhotoDelegate?.capturePicture()
    }
}
