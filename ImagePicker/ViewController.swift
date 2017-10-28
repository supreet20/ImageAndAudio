//
//  ViewController.swift
//  ImagePicker
//
//  Created by Abhilash on 15/03/17.
//  Copyright © 2017 Abhilash. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices
import QuartzCore
class ViewController: UIViewController {
    let imagePicker = UIImagePickerController()
  var localPath: String?
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
   
    }
    @IBAction func openCamAction(_ sender: Any) {
        openCamera()

    }
    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("This device doesn't have a camera.")
            return
        }
        
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .rear
//        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for:.camera)!
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
    
    @IBAction func openLibraryAction(_ sender: Any) {
        openPhotoLibrary()

    }
    func openPhotoLibrary() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("can't open photo library")
            return
        }
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        defer {
            picker.dismiss(animated: true)
        }
        
        print(info)
        // get the image
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
    
        imageView.image = image
       
        
        let documentDirectory: NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        
        let imageName = "temp"
        let imagePath = documentDirectory.appendingPathComponent(imageName)
     
        if let data = UIImageJPEGRepresentation(image, 80) {
            // Save cloned image into document directory
            let urlFile = NSURL(string: imagePath)
            
            do {
                try data.write(to: urlFile! as URL, options: .atomic)
            } catch {
                print(error)
            }
            // Save it's path
            localPath = imagePath
        }
        
        let imageData = UIImagePNGRepresentation(image)!
        
//
        
        let headers: HTTPHeaders = [
            "Authorization": "Basic YWNjX2MwNDUzYzkzNTEyOGNkYzo0ZmE5MWM4Zjg0MDk1ZGI0NGE2ZjNjODJkNTczZDUxOQ==",
            "Accept": "application/json"
        ]
        
        Alamofire.request("https://httpbin.org/basic-auth/\("acc_c0453c935128cdc")/\("4fa91c8f84095db44a6f3c82d573d519")", parameters: ["url": "http://docs.imagga.com/static/images/docs/sample/japan-605234_1280.jpg"], headers: headers)
            .authenticate(user: "acc_c0453c935128cdc", password: "4fa91c8f84095db44a6f3c82d573d519")
            .responseJSON { response in
                debugPrint(response)
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value{
                        
                        
                        print("YOUR JSON DATA>>  \(response.data!)")
                        
                        
                    }
                    break
                    
                case .failure(_):
                    print(response.result.error)
                    
                    
                    break
                    
                }
                
        }
        
        
        
    }
    
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        defer {
            picker.dismiss(animated: true)
        }
        
        print("did cancel")
    }


