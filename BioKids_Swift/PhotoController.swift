//
//  PhotoController.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 1/9/17. noah helped
//  Copyright © 2017 App Lab. All rights reserved.
//

import MobileCoreServices
import UIKit
import RealmSwift

class PhotoController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var takePhotoBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var newMedia: Bool?
    
    let realm = try! Realm()
    var observation = Observation()
    
    override func viewDidLoad() {
        takePhotoBtn.layer.cornerRadius = 10
        nextBtn.layer.cornerRadius = 10
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
    
    @IBAction func useCameraRoll(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true,
                         completion: nil)
            newMedia = false
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        self.dismiss(animated: true, completion: nil)
        
        if mediaType.isEqual(to: kUTTypeImage as String) {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            
            imageView.image = image
            
            let fileManager = FileManager.default
            let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
            
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.long
            dateFormatter.timeStyle = DateFormatter.Style.long
            let dateString = dateFormatter.string(from: date)
            let imagePath = documentsPath?.appendingPathComponent("image_\(dateString).jpg")
            
            // extract image from the picker and save it
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                
                do {
                    try UIImageJPEGRepresentation(pickedImage, 0.0)?.write(to: imagePath!)
                }
                catch {
                    print("Not saved")
                }
            }
            
            observation.photoLocation = "image_\(dateString).jpg"
            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image,
                                               self,
                                               #selector(PhotoController.image(image:didFinishSavingWithError:contextInfo:)),
                                               nil)
            } else if mediaType.isEqual(to: kUTTypeMovie as String) {
                // Code to support video here
            }
            
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafeRawPointer) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                                          message: "Failed to save image",
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "howSensedSegue"{
            let destination = segue.destination as! SensedHowViewController
            destination.observation = self.observation
        }
    }
    
}
