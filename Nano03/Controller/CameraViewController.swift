//
//  CameraViewController.swift
//  Nano03
//
//  Created by Tiago Camargo Maciel dos Santos on 30/09/25.
//

import AVFoundation
import UIKit

class CameraViewController: UIViewController {
    
    // MARK: - Control Elements
    // Capture session
    var session: AVCaptureSession?
    // Photo output
    let output = AVCapturePhotoOutput()
    
    // MARK: - UI Elements
    // Video preview
    let previewLayer = AVCaptureVideoPreviewLayer()
    // Capture button
    let shutterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 50
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.white.cgColor
        
        return button
    }()
    
    let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        checkPermissions()
        
        shutterButton.addTarget(self, action: #selector(didTapShutterButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupLayers()
    }
    
    // MARK: - Setup UI Functions
    private func setupLayers() {
        previewLayer.frame = view.bounds
        NSLayoutConstraint.activate([
            shutterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shutterButton.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            shutterButton.heightAnchor.constraint(equalToConstant: 100),
            shutterButton.widthAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    // MARK: - Camera Setup Functions
    private func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            requestAccessAndHandle()
        case .restricted:
            requestAccessAndHandle()
        case .denied:
            requestAccessAndHandle()
        case .authorized:
            setupCamera()
        @unknown default:
            break
        }
    }
    
    private func requestAccessAndHandle() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] grantedAccess in
            guard grantedAccess else { return }
            
            DispatchQueue.main.async {
                self?.setupCamera()
            }
        }
    }
    
    private func setupCamera() {
        let session = AVCaptureSession()
        let inputDevice = AVCaptureDevice.default(for: .video)
        guard let inputDevice else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: inputDevice)
            if session.canAddInput(input) {
                session.addInput(input)
            }
            
            if session.canAddOutput(output) {
                session.addOutput(output)
            }
            
            previewLayer.session = session
            previewLayer.videoGravity = .resizeAspectFill
            
            DispatchQueue.global(qos: .background).async {
                // TODO: - Make sure it's worth it to put this in the background
                session.startRunning()
            }
            self.session = session
            view.layer.addSublayer(previewLayer)
            view.addSubview(shutterButton)
        } catch {
            print("Unable to initialize camera input: ", error)
        }
    }
    
    // MARK: - Intent function
    @objc private func didTapShutterButton() {
        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
}

// MARK: - Extension to CameraViewController to save camera output
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: (any Error)?) {
        guard let data = photo.fileDataRepresentation() else { return }
        
        session?.stopRunning()
        imageView.image = UIImage(data: data)
        imageView.frame = view.bounds
        view.addSubview(imageView)
    }
}
