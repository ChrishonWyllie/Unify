//
//  CameraViewController.swift
//  Unify
//
//  Created by Chrishon Wyllie on 12/10/17.
//  Copyright © 2017 Chrishon Wyllie. All rights reserved.
//

import UIKit
import AVFoundation


class CameraViewController: UIViewController {
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    let error: NSError? = nil
    var captureDevice: AVCaptureDevice? = nil
    
    var imageHasBeenCaptured: Bool = false
    var timer: Timer?
    var currentNumImages: Int = 0
    // Count should be 10
    private var capturedImages: [UIImage] = []
    
    private var cameraView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var dismissButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("<", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        btn.addTarget(self, action: #selector(dismissDidTapped(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var cameraButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Take Photos", for: .normal)
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 8
        btn.backgroundColor = UIColor.white
        btn.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        btn.layer.borderWidth = 2
        btn.addTarget(self, action: #selector(beginTakingTenPhotos), for: .touchUpInside)
        return btn
    }()
    
    @objc private func dismissDidTapped(_ sender: Any) {
        //_ = navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupUIElements() {
        
        self.view.addSubview(cameraView)
        
        self.view.addSubview(cameraButton)
        self.view.addSubview(dismissButton)
        
        cameraView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        cameraView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        cameraView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        cameraView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        cameraButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        cameraButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16).isActive = true
        cameraButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        cameraButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        
        dismissButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        dismissButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -4).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    private func setUpCameraView() {
        
        print("Setting up camera view")
        
        captureSession?.stopRunning()
        previewLayer?.removeFromSuperlayer()
        
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = AVCaptureSession.Preset.hd1920x1080
        
        
        _ = AVCaptureDevice.DiscoverySession.init(deviceTypes: [.builtInMicrophone, .builtInWideAngleCamera], mediaType: AVMediaType.video, position: .front)
        captureDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: .front)
        
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            
            if (error == nil && captureSession?.canAddInput(input) != nil) {
                
                captureSession?.addInput(input)
                stillImageOutput = AVCaptureStillImageOutput()
                stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
                
                if (captureSession?.canAddOutput(stillImageOutput!) != nil) {
                    captureSession?.addOutput(stillImageOutput!)
                    
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                    previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                    cameraView.layer.addSublayer(previewLayer!)
                    captureSession?.startRunning()
                }
            }
        } catch let error {
            print("Something went wrong... \(error.localizedDescription)")
        }
        
        previewLayer?.frame = self.view.bounds
        
    }
    
    private func capturePhoto() {
        
        if let videoConnection = stillImageOutput?.connection(with: AVMediaType.video) {
            
            videoConnection.videoOrientation = AVCaptureVideoOrientation.portrait
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (sampleBuffer, error) in
                
                if sampleBuffer != nil {
                    
                    let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer!, previewPhotoSampleBuffer: nil)

                    
                    let dataProvider = CGDataProvider(data: imageData! as CFData)
                    let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
                    
                    let image: UIImage = self.fixOrientation(ForImage: UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.leftMirrored))
                    
                    self.capturedImages.append(image)
                    
                    self.currentNumImages = self.currentNumImages + 1
                    print("current num images: \(self.currentNumImages)")
                    print("current number of captured images: \(self.capturedImages.count)")
                    
                    // Turn the image into Data that can be written to a file, which will can be uploaded
                    
                    let when = DispatchTime.now() + 0.1
                    
                    // Now store these images Securely in Core Data
                    DispatchQueue.main.asyncAfter(deadline: when, execute: {
                        
                    })
                    
                    
                    self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
                        if self.currentNumImages < 10 {
                            self.capturePhoto()
                        } else if self.currentNumImages == 10 {
                            print("we've reached ten photos")
                            UserDefaults.standard.set(true, forKey: "SecurityImagesCaptured")
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                } 
            })
        }
    }
    
    private func fixOrientation(ForImage image: UIImage) -> UIImage {
        
        if (image.imageOrientation == UIImageOrientation.up) {
            return image
        }
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale);
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        image.draw(in: rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return normalizedImage
        
    }
    
    @objc private func beginTakingTenPhotos() {
        
        print("Attempting to take photos......")
        
        capturePhoto()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUIElements()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpCameraView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
