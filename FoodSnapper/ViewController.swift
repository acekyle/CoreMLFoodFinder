//
//  ViewController.swift
//  FoodSnapper
//
//  Created by Aaron Anderson on 12/14/17.
//  Copyright © 2017 Aaron Anderson. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBAction func cameraButtonTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    @IBOutlet weak var imgView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedimage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgView.image = pickedimage
            guard let ciImage = CIImage(image: pickedimage) else {
                fatalError("Couldn't convert image to CIImage")
            }
            detect(image: ciImage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    func detect(image: CIImage){
            guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
                fatalError("Loading the model failed")
            }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }
            print(results)
            
            if let firstResult = results.first {
                print(firstResult.identifier)
                if firstResult.identifier.contains("hotdog"){
                    self.navigationItem.title = "Hotdog!"
                }else{
                    self.navigationItem.title = firstResult.identifier
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        }catch{
            print(error)
        }
       
    }

}

