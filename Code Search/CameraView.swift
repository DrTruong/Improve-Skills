//
//  CameraView.swift
//  Code Search
//
//  Created by Kis User on 4/26/21.
//

import UIKit
import AVFoundation

class CameraView: UIViewController{

    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!

    var deviceInput = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        captureSession = AVCaptureSession()
        
        do {
            
            deviceInput?.isFocusModeSupported(.continuousAutoFocus)

            try deviceInput?.lockForConfiguration()
            deviceInput?.focusMode = .continuousAutoFocus
            deviceInput?.unlockForConfiguration()


            let input = try AVCaptureDeviceInput(device: deviceInput!)
            stillImageOutput = AVCapturePhotoOutput()
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)

                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                videoPreviewLayer.videoGravity = .resizeAspectFill
                videoPreviewLayer.connection?.videoOrientation = .portrait

                self.captureSession.startRunning()

            }
        }
        catch let error{
            print(error.localizedDescription)
        }
    }

}

