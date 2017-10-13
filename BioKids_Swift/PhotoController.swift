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
import Photos


class PhotoController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var takePhotoBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var fileURL: URL?
    var newMedia: Bool?
    
    let realm = try! Realm()
    var observation = Observation()
    
    override func viewDidLoad() {
        takePhotoBtn.layer.cornerRadius = 10
        nextBtn.layer.cornerRadius = 10
        print(observation)
        
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
        self.dismiss(animated: true, completion: nil)
        
        if mediaType.isEqual(to: kUTTypeImage as String) {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
//            imageView.image = image
            

//            let data = UIImageJPEGRepresentation(image, 0.8)
//
//            // Save image
//            do {
//                try data!.write(to: fileURL!, options: .atomic)
//                try print(fileURL!.checkResourceIsReachable())
//            } catch {
//                print ("couldn't save photo \(error)")
//            }
            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image,
                                               self,
                                               #selector(PhotoController.image(image:didFinishSavingWithError:contextInfo:)),
                                               nil)
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
            
//            fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
//
//            let data = UIImagePNGRepresentation(image)
//
//            do{
//                try data?.write(to: fileURL!, options: .atomic)
//            }catch {
//                print(error.localizedDescription)
//            }
            
            observation.photoLocation = fileName
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
