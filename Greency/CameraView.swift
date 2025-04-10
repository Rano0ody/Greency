//
//  CameraView.swift
//  Greency
//
//  Created by bayan alshammri on 10/04/2025.
//

import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    var onCapture: (UIImage?) -> Void

    func makeUIViewController(context: Context) -> CameraViewController {
        let cameraVC = CameraViewController()
        cameraVC.onCapture = onCapture
        return cameraVC
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}

    class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
        var captureSession: AVCaptureSession!
        var photoOutput: AVCapturePhotoOutput!
        var onCapture: ((UIImage?) -> Void)?

        override func viewDidLoad() {
            super.viewDidLoad()
            setupCamera()
        }

        func setupCamera() {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                configureSession()

            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        DispatchQueue.main.async {
                            self.configureSession()
                        }
                    } else {
                        print("تم رفض إذن الكاميرا")
                    }
                }

            case .denied, .restricted:
                print("الوصول للكاميرا مرفوض أو غير مسموح")
                return

            @unknown default:
                return
            }
        }

        func configureSession() {
            captureSession = AVCaptureSession()
            captureSession.sessionPreset = .photo

            guard let backCamera = AVCaptureDevice.default(for: .video) else { return }

            do {
                let input = try AVCaptureDeviceInput(device: backCamera)
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                }

                photoOutput = AVCapturePhotoOutput()
                if captureSession.canAddOutput(photoOutput) {
                    captureSession.addOutput(photoOutput)
                }

                let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.frame = view.bounds
                view.layer.addSublayer(previewLayer)

                DispatchQueue.global(qos: .userInitiated).async {
                    self.captureSession.startRunning()
                }

                NotificationCenter.default.addObserver(self, selector: #selector(capturePhoto), name: .capturePhoto, object: nil)
            } catch {
                print("Error setting up camera: \(error)")
            }
        }

        @objc func capturePhoto() {
            let settings = AVCapturePhotoSettings()
            photoOutput.capturePhoto(with: settings, delegate: self)
        }

        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            guard let photoData = photo.fileDataRepresentation(),
                  let image = UIImage(data: photoData) else {
                onCapture?(nil)
                return
            }
            onCapture?(image)
        }

        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            captureSession?.stopRunning()
            NotificationCenter.default.removeObserver(self)
        }
    }
}

extension Notification.Name {
    static let capturePhoto = Notification.Name("CapturePhoto")
}


