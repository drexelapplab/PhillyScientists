//
//  ObservationsContainer.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 3/29/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

class ObservationContainer {
    static let sharedInstance = ObservationContainer()
    
    var observations: [Observation] = []
    
    // MARK: Initializer
    private init () {
        
    }
    
    // MARK: Methods
    func addObservation(observation: Observation){
        self.observations.append(observation)
    }
    
    func removeObservation(index: Int){
        self.observations.remove(at: index)
    }
    
    func howManyNeedSubmitting() -> Int {
        var count = 0
        for observation in observations {
            if observation.wasSubmitted == false{
                count += 1
            }
        }
        return count
    }
    
    func submitData() {
        
        let submissionURL = "https://biokids.soe.drexel.edu/addObservation.php"
        
        let realm = try! Realm()
        
        for observation in self.observations {
            
            if observation.wasSubmitted == false {
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone(abbreviation: "EST")
                dateFormatter.dateFormat = "YYYY-MM-dd hh:mm:ss"
                
                let parameters: Parameters = ["date": dateFormatter.string(from: observation.date),
                                              "howSensed": observation.howSensed,
                                              "whatSensed": observation.whatSensed,
                                              "plantKind": observation.plantKind,
                                              "grassKind": observation.grassKind,
                                              "howMuchPlant": observation.howMuchPlant,
                                              "howManySeen": observation.howManySeen,
                                              "animalGroup":observation.animalGroup,
                                              "animalType": observation.animalType,
                                              "animalSubType": observation.animalSubType,
                                              "note": observation.note,
                                              "howManyIsExact": observation.howManyIsExact]
                
                ////////////////////
                // Send Text data //
                ////////////////////
                
                Alamofire.request(submissionURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseString() { response in
                    switch response.result {
                    case .success:
                        print("Validation Successful...\(String(describing: response.value))")
                        
//                        try! realm.write {
//                            observation.wasSubmitted = true
//                        }
                        
                    case .failure(let error):
                        print(error)
                    }
                }
                
                ////////////////
                // Send Photo //
                ////////////////
                
                let imageToUpload = URL(fileURLWithPath: observation.photoLocation)
                Alamofire.upload(
                    multipartFormData: { multipartFormData in
                        
                        // On the PHP side you can retrive the image using $_FILES["image"]["tmp_name"]
                        multipartFormData.append(imageToUpload, withName: observation.photoLocation)
                        for (key, val) in parameters {
                            multipartFormData.append((val as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                        }
                    },
                    
                    to: submissionURL,
                    encodingCompletion: { encodingResult in
                        switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    if let jsonResponse = response.result.value as? [String: Any] {
                                        print(jsonResponse)
                                    }
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                        }
                    }
                )
            }
        }
    }
}
