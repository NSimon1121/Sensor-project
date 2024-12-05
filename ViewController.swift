//
//  ViewController.swift
//  Sensor project
//
//  Created by Nicholas Simon on 11/27/24.
//

import UIKit
import AVFoundation
import AudioToolbox
class ViewController: UIViewController{
    let videoCapture = VideoCapture()
    var previewLayer: AVCaptureVideoPreviewLayer?

    var pointsLayer = CAShapeLayer()
    var isActionDetected = false

    override func viewDidLoad(){
        super.viewDidLoad()

        setupVideoPreview()

        videoCapture.predictor.delegate = self
    }

    private func setupVideoPreview(){
        videoCapture.startCaptureSession()
        previewLayer = AVCaptureVideoPreviewLayer(session: videoCapture.captureSession)

        guard let previewlayer = previewLayer else{ return }
        
        view.layer.addSublayer(previewlayer)
        previewlayer.frame = view.frame
        view.layer.addSublayer(pointsLayer)
        pointsLayer.frame = view.frame
        pointsLayer.strokeColor = UIColor.green.cgColor
    }
}

extension ViewController: PredictorDelegate{
    
    
    
    func predictor(_ predictor: Predictor, didLabelAction action: String, with confidence: Double) {
        if action == ("JumpingJacks") && confidence > 0.8 && isActionDetected == false {
            print("Jumping Jack detected")
            isActionDetected = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                self.isActionDetected = false
            }
            DispatchQueue.main.async{
                AudioServicesPlayAlertSound(SystemSoundID(1322))
            }
        }
        if action == ("Lunges") && confidence > 0.8 && isActionDetected == false {
            print("Lunges detected")
            isActionDetected = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                self.isActionDetected = false
            }
            DispatchQueue.main.async{
                AudioServicesPlayAlertSound(SystemSoundID(1322))
            }
        }
    }
        
        func predictor(_ predictor: Predictor, didFindRecognizedPoints points: [CGPoint]){
            guard let previewLayer = previewLayer else{return}
            
            let convertedPoints = points.map{
                previewLayer.layerPointConverted(fromCaptureDevicePoint: $0)
            }
            
            let combinePath = CGMutablePath()
            for point in convertedPoints{
                let dotPath = UIBezierPath(ovalIn: CGRect(x: point.x, y: point.y, width: 10, height: 10))
                combinePath.addPath(dotPath.cgPath)
            }
            pointsLayer.path = combinePath
            
            DispatchQueue.main.async{
                self.pointsLayer.didChangeValue(for: \.path)
            }
            
        }
    }
    
    

