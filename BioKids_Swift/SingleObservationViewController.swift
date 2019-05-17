//
//  ObservationViewController.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 10/12/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import Photos
import RealmSwift

class SingleObservationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var editReminderLbl: UILabel!
    @IBOutlet weak var observationImgView: UIImageView!
    @IBOutlet weak var editPhotoBtn: UIButton!
    var observationIdx = -1
    let observationContainer = ObservationContainer.sharedInstance
    var observation: Observation?
    var newMedia: Bool?
    
    @IBOutlet weak var observationTableView: UITableView!
    
    var displayStrings = [String]()
    var propertyNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //editReminderLbl.textColor = C.Colors.subheadingText

        observationTableView.setEditing(false, animated: false)
        
        if observationIdx > -1 {
            observation = observationContainer.observations[observationIdx]
            let photoLocation = observation?.photoLocation
            let photoURL = getDocumentsDirectory().appendingPathComponent(photoLocation!)
            observationImgView.image = UIImage(contentsOfFile: photoURL.path)
            print("photoLocation: \(String(describing: observation?.howSensed))")
            if photoLocation == "" {
                editPhotoBtn.setTitle("Add Photo", for: .normal)
            } else {
                editPhotoBtn.setTitle("Edit Photo", for: .normal)
            }
            // TODO: Change this be returned by a function in the observation container
            propertyNames = observationContainer.observations[observationIdx].getPropertyNames()            
            displayStrings = (observation?.getDisplayStrings())!
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        observationTableView.setEditing(false, animated: false)
        displayStrings = (observation?.getDisplayStrings())!
        self.observationTableView.reloadData()
    }
    
    @IBAction func editPhoto(_ sender: UIButton) {
        // The method to add new or edit photos
        if observationIdx > -1 {
            observation = observationContainer.observations[observationIdx]
            let photoLocation = observation?.photoLocation
            let photoURL = getDocumentsDirectory().appendingPathComponent(photoLocation!)
            observationImgView.image = UIImage(contentsOfFile: photoURL.path)
            // Judge if there is a photo, a alert will pop out if there is a photo, then the camera will be connected; if there isn't a photo, connect the camera directly!
            if photoLocation == "" {
                editPhotoBtn.setTitle("Add Photo", for: .normal)
                useCamera()
            } else {
                AlertControllerTool.showAlert(currentVC: self, meg: "This photo will replace your old photo, are you sure?", cancelBtn: "Cancel", otherBtn: "Yes", handler: { (action) in
                    self.useCamera()
                })
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayStrings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! ObservationEntryCell
        
        cell.entryLbl.text = displayStrings[indexPath.row]
        
        return cell
    }
    //****modified*****
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in

            let property = self.propertyNames[editActionsForRowAt.row]
            // Codes needs to be modified here; add new kinds of cases to demo the viewcontroller!!
            switch property {
            case "howSensed":
                self.performSegue(withIdentifier: "howSensedSegue", sender: self)
                break
            case "whatSensed":
                self.performSegue(withIdentifier: "whatSensedSegue", sender: self)
                break
            case "plantKind":
                self.performSegue(withIdentifier: "plantKindSegue", sender: self)
                break
            case "grassKind":
                self.performSegue(withIdentifier: "grassKindSegue", sender: self)
                break
            case "howMuchPlant":
                self.performSegue(withIdentifier: "howMuchPlantSegue", sender: self)
                break
            case "howManySeen":
                self.performSegue(withIdentifier: "howManySeenSegue", sender: self)
                break
            case "animalGroup":
                self.performSegue(withIdentifier: "animalGroupSegue", sender: self)
                break
            case "animalType":
                self.performSegue(withIdentifier: "animalTypeSegue", sender: self)
                break
            case "animalSubType":
                self.performSegue(withIdentifier: "animalSubTypeSegue", sender: self)
                break
            // Codes modified here; for animal position and animal action;** Variable name undetermined;
            case "animalPosition":
                self.performSegue(withIdentifier: "animalPositionSegue", sender: self)
                break
            // Codes modified here; for animal action and animal action;** Variable name undetermined;
            case "animalAction":
                self.performSegue(withIdentifier: "animalActionSegue", sender: self)
                break
            case "location":                                                                                //WUT??
                self.performSegue(withIdentifier: "locationEditSeque", sender: self)
            case "notes":
                self.performSegue(withIdentifier: "noteSegue", sender: self)
                break
            default:
                break
            }
            
        }
        edit.backgroundColor = .red
        
        return [edit]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //****modified*****
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let segueType = segue.identifier {
            // Codes needs to be modified here; add new kinds of cases to demo the viewcontroller!!
            switch segueType {
            case "howSensedSegue":
                let destination = segue.destination as! SensedHowViewController
                destination.observation = self.observation!
                destination.editMode = true
                break
            case "whatSensedSegue":
                let destination = segue.destination as! SensedWhatViewController
                destination.observation = self.observation!
                destination.editMode = true
                break
            case "plantKindSegue":
                let destination = segue.destination as! PlantKindViewController
                destination.observation = self.observation!
                destination.editMode = true
                break
            case "grassKindSegue":
                let destination = segue.destination as! GrassTypeViewController
                destination.observation = self.observation!
                destination.editMode = true
                break
            case "howMuchPlantSegue":
                let destination = segue.destination as! HowMuchGrassViewController
                destination.observation = self.observation!
                 destination.editMode = true
                break
            case "howManySeenSegue":
                let destination = segue.destination as! AmountSensedViewController
                destination.observation = self.observation!
                destination.editMode = true
                break
            case "animalGroupSegue":
                let destination = segue.destination as! AnimalGroupViewController
                destination.observation = self.observation!
                destination.editMode = true
                break
            case "animalTypeSegue":
                let destination = segue.destination as! AnimalTypeViewController
                destination.observation = self.observation!
                destination.editMode = true
                break
            case "animalSubTypeSegue":
                let destination = segue.destination as! AnimalSubtypeViewController
                destination.observation = self.observation!
                destination.editMode = true
                break
            // AnimalPositionTableViewController is added here;
            case "animalPositionSegue":
                let destination = segue.destination as! AnimalPositionViewController
                destination.observation = self.observation!
                destination.editMode = true
                break
            // AnimalActionTableViewController is added here;
            case "animalActionSegue":
                let destination = segue.destination as! AnimalActionViewController
                destination.observation = self.observation!
                destination.editMode = true
                break
            case "locationEditSeque":
                let destination = segue.destination as! SensedWhereViewController
                destination.observation = self.observation!
                destination.editMode = true
                break
            case "noteSegue":
                let destination = segue.destination as! NotesViewController
                destination.observation = self.observation!
                destination.editMode = true
                break
            default:
                break
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // viewdiddisapper ||this controller will be called after current pictures disapper, if this one wants to be edited, it will return to last page
//        self.navigationController?.popToRootViewController(animated: false)
    }
    
    // MARK: PHOTO SELECT
    // This is what PhotoController have!
    func useCamera() {
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        if mediaType.isEqual(to: kUTTypeImage as String) {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image,
                                               self,
                                               #selector(SingleObservationViewController.image(image:didFinishSavingWithError:contextInfo:)),
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
        } else {
            
            let date = Date()
            let df = DateFormatter()
            df.dateFormat = "yyyyMMddhhmmss"
            
            // The photo name format, this is an example：photo20180212160522.png（Photo name can be self-defined）
            let fileName = "photo\(df.string(from: date)).png"
            // Get the decimal file of the photo, this parameter will be used if it wants to be submitted to server!
            let imageData = UIImagePNGRepresentation(image)!
            let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let imageURL = docDir.appendingPathComponent(fileName)
            // write into the file;
            try! imageData.write(to: imageURL)
            // This is to give the imageView a new value after the photo is choosen
            let newImage = UIImage(contentsOfFile: imageURL.path)!
            observationImgView.image = newImage
            editPhotoBtn.setTitle("Edit Photo", for: .normal)
            
            // Save it to the database after edit the photo
            let realm = try! Realm()
            try! realm.write {
                 observation?.photoLocation = fileName
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
