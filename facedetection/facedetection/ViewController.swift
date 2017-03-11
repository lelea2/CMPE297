//
//  ViewController.swift
//  facedetection
//
//  Created by Dao, Khanh on 3/10/17.
//  Copyright © 2017 kdao. All rights reserved.
//
import UIKit
import AVFoundation
import CoreImage

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var previewLayer: AVCaptureVideoPreviewLayer!
    var faceRectCALayer: CALayer!
    var textLayer: CATextLayer!
    fileprivate var currentCameraFace: AVCaptureDevice?
    fileprivate var sessionQueue: DispatchQueue = DispatchQueue(label: "videoQueue", attributes: [])
    fileprivate var session: AVCaptureSession!
    fileprivate var backCameraDevice: AVCaptureDevice?
    fileprivate var frontCameraDevice: AVCaptureDevice?
    fileprivate var metadataOutput: AVCaptureMetadataOutput!
    fileprivate var stillImageOutput = AVCaptureStillImageOutput()
    var button = UIButton()

    var shouldCall = true
    var left: Int!
    var right: Int!
    var bottom: Int!
    var top: Int!

    let HOST = "https://facedection.herokuapp.com/api"

    override func viewDidLoad() {
        super.viewDidLoad()
        //Flip view here, image doesnt seem appear correct either
//        self.view.transform = CGAffineTransform(scaleX: -1, y: 1);
        setupSession()
        setupPreview()
        setupFace()
        startSession()
        createBtn() //Create btn
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Setup session and preview
    func setupSession() {
        //        shouldCall = true
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPreset640x480
        let avaliableCameraDevices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        for device in avaliableCameraDevices as! [AVCaptureDevice] {
            if device.position == .back {
                backCameraDevice = device
            } else if device.position == .front {
                frontCameraDevice = device
            }
        }
        do {
            let input = try AVCaptureDeviceInput(device: frontCameraDevice)
            if session.canAddInput(input) {
                session.addInput(input)
            }

        } catch {
            print("Error handling the camera Input: \(error)")
            return
        }
        let metadataOutput = AVCaptureMetadataOutput()
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: sessionQueue)
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeFace]
        }
    }


    func setupPreview() {
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.bounds
        previewLayer.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        view.layer.addSublayer(previewLayer)
    }

    func startSession() {
        if !session.isRunning {
            session.startRunning()
            if session.canAddOutput(stillImageOutput) {
                session.addOutput(stillImageOutput)
            }
        }
    }

    func getImageData(faceObject: CGRect!) {
        stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
        left = Int((faceObject?.origin.x)!)
        top = Int((faceObject?.origin.y)!)
        right = Int((faceObject?.origin.x.rounded())!) + Int((faceObject?.size.width.rounded())!)
        bottom = Int((faceObject?.origin.y.rounded())!) + Int((faceObject?.size.height.rounded())!)

        if (shouldCall == true) {
            if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo) {
                //                videoConnection.videoOrientation = .landscapeRight
                //                videoConnection.videoOrientation = .portrait
                //                videoConnection.videoOrientation = .landscapeLeft
                //                videoConnection.videoOrientation = .portraitUpsideDown
                stillImageOutput.captureStillImageAsynchronously(from: videoConnection) {
                    (imageDataSampleBuffer, error) -> Void in
                    //Bytes data
                    if imageDataSampleBuffer != nil {
                        let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                        let dataProvider = CGDataProvider(data: imageData as! CFData)
                        let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
                        let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right) //need to downsize image
                        var ciImage = CIImage(image: image)
                        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
                        let faces = faceDetector?.features(in: ciImage!) as! [CIFaceFeature]
                        print("Number of faces: \(faces.count)")
                        //                        print(image.size)
                        //                        let imageNew = self.imageRotatedByDegrees(oldImage: image, deg: 90.0)
                        //                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        //                        print(imageNew.size) //(960.0, 1280.0) => (480.0, 640.0)
                        //                        print(imageNew.size.width) //(960.0, 1280.0) => (480.0, 640.0)
                        //                        let finalData = UIImagePNGRepresentation(imageNew)
                        //                        let finalData = UIImageJPEGRepresentation(imageNew, 0.5)
                        //                        print(imageData)
                        //                        print(finalData)
                        //                    UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData!)!, nil, nil, nil)
                        let urlInit = self.HOST + "?left=" + String(self.left) + "&right=" + String(self.right)
                        let url = URL(string: urlInit + "&top=" + String(self.top) + "&bottom=" + String(self.bottom))
                        //                let jsonDict = ["image": imageData]
                        //                let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])
                        print(url)
                        var request = URLRequest(url: url!)
                        request.httpMethod = "post"
                        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
                        request.httpBody = imageData
                        self.shouldCall = false
                        self.button.setTitle("Refresh", for: .normal)
                        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                            print (">>>>> Start session....<<<<<")
                            if let error = error {
                                print("error:", error)
                                self.shouldCall = true
                                return
                            }
                            do {
                                guard let data = try data else { return }
                                print(data)
                                //                              guard let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return
                                //                                }
                                //                                self.shouldCall = false
                                let dataString = String(data: data, encoding: String.Encoding.utf8)
                                self.setupFaceValue(dataString!)
                                //                                self.displayAlertBox(msg: dataString!)
                            } catch {
                                print("error:", error)
                                self.shouldCall = true
                            }
                        }
                        task.resume()
                    } else {
                        print("AV not existing...")
                    }
                }
            }
        } else {
            //            print("should not make the call")
        }
    }


//    func imageRotatedByDegrees(oldImage: UIImage, deg degrees: CGFloat) -> UIImage {
//        //Calculate the size of the rotated view's containing box for our drawing space
//        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: oldImage.size.width, height: oldImage.size.height))
//        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat(M_PI / 180))
//        rotatedViewBox.transform = t
//        let rotatedSize: CGSize = rotatedViewBox.frame.size
//        //Create the bitmap context
//        UIGraphicsBeginImageContext(rotatedSize)
//        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
//        //Move the origin to the middle of the image so we will rotate and scale around the center.
//        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
//        //Rotate the image context
//        bitmap.rotate(by: (degrees * CGFloat(M_PI / 180)))
//        //Now, draw the rotated/scaled image into the context
//        bitmap.scaleBy(x: 1.0, y: -1.0)
//        bitmap.draw(oldImage.cgImage!, in: CGRect(x: -oldImage.size.width / 2, y: -oldImage.size.height / 2, width: oldImage.size.width, height: oldImage.size.height))
//        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        return newImage
//    }

    func setupFace() {
        faceRectCALayer = CALayer()
        faceRectCALayer.shadowOpacity = 0.8;
        faceRectCALayer.zPosition = 1
        faceRectCALayer.borderColor = UIColor.red.cgColor
        faceRectCALayer.borderWidth = 3.0
        previewLayer.addSublayer(faceRectCALayer)
        setupInitalText()
    }

    //Initial set up text
    func setupInitalText() {
        textLayer = CATextLayer()
        textLayer.frame = previewLayer.bounds
        textLayer.fontSize = 24
        textLayer.zPosition = 3
        textLayer.foregroundColor = UIColor.blue.cgColor
        textLayer.isWrapped = true
        textLayer.alignmentMode = kCAAlignmentLeft
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.string = ""
        faceRectCALayer.addSublayer(textLayer)
    }

    func setupFaceValue(_ text: String) {
        print("set up face value")
        CATransaction.begin() //Need to display value
        CATransaction.setDisableActions(true)
        self.textLayer?.string = text
        CATransaction.commit() //Need to display value
    }

    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        var faces = [CGRect]()
        //        <AVCaptureConnection: 0x17000fee0 [type:mobj][enabled:1][active:1]>
        //        print(connection)
        for metadataObject in metadataObjects as! [AVMetadataObject] {
            if metadataObject.type == AVMetadataObjectTypeFace {
                let transformedMetadataObject = previewLayer.transformedMetadataObject(for: metadataObject)
                let face = transformedMetadataObject?.bounds
                faces.append(face!)
            }
        }
        if (faces.count > 0) { //face available
            setlayerHidden(false)
            DispatchQueue.main.async(execute: {
                () -> Void in
                self.faceRectCALayer.frame = self.findMaxFaceRect(faces)
                self.getImageData(faceObject: self.faceRectCALayer.frame)
            })
        } else {
            print("set hidden layer")
            setlayerHidden(true)
        }
    }

    /**
     * Set layer for image
     */
    func setlayerHidden(_ hidden: Bool) {
        if (faceRectCALayer.isHidden != hidden) {
            print("hidden:" , hidden)
            DispatchQueue.main.async(execute: {
                () -> Void in
                self.faceRectCALayer.isHidden = hidden
            })
        }
    }

    func increaseRect(rect: CGRect, byPercentage percentage: CGFloat) -> CGRect {
        let startWidth = rect.width
        let startHeight = rect.height
        let adjustmentWidth = (startWidth * percentage) / 2.0
        let adjustmentHeight = (startHeight * percentage) / 2.0
        return rect.insetBy(dx: -adjustmentWidth, dy: -adjustmentHeight)
    }


    /**
     * Function draw rectangle for image
     */
    func findMaxFaceRect(_ faces : Array<CGRect>) -> CGRect {
        if (faces.count == 1) {
            return increaseRect(rect: faces[0], byPercentage: 0.1)
            //            return faces[0]
        }
        var maxFace = CGRect.zero
        var maxFace_size = maxFace.size.width + maxFace.size.height
        for face in faces {
            let face_size = face.size.width + face.size.height
            if (face_size > maxFace_size) {
                maxFace = face
                maxFace_size = face_size
            }
        }
        return increaseRect(rect: maxFace, byPercentage: 0.1)
        //        return maxFace
    }

    func createBtn() {
        button.frame = (frame: CGRect(x: self.view.frame.size.width - 250, y: 20, width: 150, height: 50))
        button.backgroundColor = UIColor.blue
        button.setTitle("Running...", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(button)
    }

    func buttonAction(sender: UIButton!) {
        //        print("Button tapped")
        if (!shouldCall) {
            button.setTitle("Running...", for: .normal)
            shouldCall = true
        } else {
            button.setTitle("Refresh", for: .normal)
            shouldCall = false
        }
    }
}

