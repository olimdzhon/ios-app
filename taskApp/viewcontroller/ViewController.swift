//
//  ViewController.swift
//  taskApp
//
//  Created by Олимджон Садыков on 14.10.2021.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func didTapButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var previewBorderView: UIView!
    
    @IBOutlet weak var flashlightBtn: UIButton!
    
    private var captureSession = AVCaptureSession()
    private var cameraPreviewLayer: AVCaptureVideoPreviewLayer!
    private var isTorchOn: Bool = false
   

    
    let transparentView = UIView()
    let tableView = UITableView()
    let modelTableView = UITableView()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
                 
        checkForCameraPermission()
        
        flashlightBtn.titleLabel?.textAlignment = .center
        flashlightBtn.imageView?.contentMode = .scaleAspectFit
        
        view.layoutIfNeeded()
    }
    
    func setupInputOutput(){
        print("setupInputOutput")
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            print("Your device is not aplicable for video processing")
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            print("Your device can not add input in capture session")
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr, .ean8, .ean13, .pdf417, .upce, .code128, .code39, .code39Mod43, .code93, .interleaved2of5, .itf14, .upce]
        } else {
            return
        }
    }
    
    func setupPreviewLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.previewBorderView.layer.bounds
        self.previewBorderView.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    
    func startRunningCaptureSession(){
        captureSession.startRunning()
    }
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            flashlightBtn.isHidden = true
        }
    }
    
    
    @IBAction func didTapTorchBtn(_ sender: Any) {
        isTorchOn = !isTorchOn
        toggleTorch(on: isTorchOn)
    }
    
    private func checkForCameraPermission() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch cameraAuthorizationStatus {
        case .notDetermined: requestCameraPermission()
        case .authorized:
            DispatchQueue.main.async {
                self.flashlightBtn.isUserInteractionEnabled = true
                if Platform.isSimulator {
                    // Do one thing
                }
                else {
                    self.setupInputOutput()
                    self.setupPreviewLayer()
                    self.startRunningCaptureSession()
                }
            }
        case .restricted, .denied:
            DispatchQueue.main.async {
                self.flashlightBtn.isUserInteractionEnabled = false
                self.displayCameraPermissionAlert()
            }
        @unknown default:
            break
        }
    }
    
    private func displayCameraPermissionAlert() {
        let alert = UIAlertController(title: "\"App\" Would Like to Access the Camera", message: "App requires to access camera for capturing QR codes", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Don't Allow", style: .cancel, handler: {action in
            self.flashlightBtn.isUserInteractionEnabled = false
            self.dismiss(animated: true, completion: nil)
        })
        let confirm = UIAlertAction(title: "OK", style: .default, handler: {action in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        })
        
        alert.addAction(cancel)
        alert.addAction(confirm)
        present(alert, animated: true, completion: nil)
    }
    
    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { accessGranted in
            DispatchQueue.main.async {
                guard accessGranted == true else {
                    self.flashlightBtn.isUserInteractionEnabled = false
                    return }
                self.flashlightBtn.isUserInteractionEnabled = true
                if Platform.isSimulator {
                    // Do one thing
                }
                else {
                    self.setupInputOutput()
                    self.setupPreviewLayer()
                    self.startRunningCaptureSession()
                }
            }
        })
    }
}

extension ViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            let alert = UIAlertController(title: "Scan success", message: stringValue, preferredStyle: .alert)
            let confirm = UIAlertAction(title: "OK", style: .default, handler: {action in
                self.dismiss(animated: true, completion: nil)
            })
            
            alert.addAction(confirm)
            present(alert, animated: true, completion: nil)
            
        }
    }
}

  
