//
//  PhotoController.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 1/9/17. noah helped
//  Modified by Shiv
//  Copyright © 2017 App Lab. All rights reserved.
//

import MobileCoreServices
import UIKit
import Photos

class PhotoController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var takePhotoBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var fileURL: URL?
    var newMedia: Bool?
    
    var observation = Observation()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        takePhotoBtn.layer.cornerRadius = 10
        nextBtn.layer.cornerRadius = 10
        cancelBtn.layer.cornerRadius = 10
        
        // If this is not initial loading change view to observation view
        
        print(defaults.bool(forKey: "initialLoading"))
        print("In PhotoController.swift")
        if !defaults.bool(forKey: "initialLoading") {
            if ObservationContainer.sharedInstance.observations.count > 0 {
                self.tabBarController?.selectedIndex = 0
            }
        }

    }
    
    @IBAction func useCamera(_ sender: AnyObject) {
        
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
            newMedia = true
            
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        
        
        if mediaType.isEqual(to: kUTTypeImage as String) {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            printImageSize(image: image)
            
            var imageData = image.jpeg(.lowest)
            
            let imageCompressed = UIImage(data: imageData!)
            printImageSize(image: imageCompressed!)
            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(imageCompressed!,
                                               self,
                                               #selector(PhotoController.image(image:didFinishSavingWithError:contextInfo:)),
                                               nil)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafeRawPointer) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                                          message: "Failed to save image",
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            
            let date = Date()
            let df = DateFormatter()
            df.dateFormat = "yyyyMMddhhmmss"
            
            let fileName = "photo\(df.string(from: date)).png"
            
            let imageData = UIImagePNGRepresentation(image)!
            let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let imageURL = docDir.appendingPathComponent(fileName)
            try! imageData.write(to: imageURL)
            
            let newImage = UIImage(contentsOfFile: imageURL.path)!
            imageView.image = newImage
            
            observation.photoLocation = fileName
            print("The imageURL just saved is: ")
            print(fileName)
            print("the imageURL that we're trying to save is ")
            print(observation.photoLocation)
            
            print("the observation is")
            print("photoController", observation)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showMessageToUser(title: String, msg: String)  {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
            // Return
            print("pressed yes")
            
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        
        let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            print("pressed no")
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didPressCancelBtn(_ sender: Any) {
        self.showMessageToUser(title: "Alert", msg: C.Strings.observationCancel)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "whatSensedSegue"{
            let destination = segue.destination as! SensedWhatViewController
            destination.observation = self.observation
        }
    }
    
    func printImageSize(image: UIImage){
        if let imageData = UIImagePNGRepresentation(image) {
            let bytes = imageData.count
            let kB = Double(bytes) / 1000.0 // Note the difference
            let KB = Double(bytes) / 1024.0 // Note the difference
            print("image size: \(KB)")
        }
    }
    
    
}
