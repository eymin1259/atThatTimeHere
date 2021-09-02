//
//  NoteViewModel.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 8/26/21.
//

import UIKit
import CoreLocation

struct NoteViewModel {
    
    //MARK: properties
    
    //  note attributes
    var isNewNote : Bool = false
    var isEditiing : Bool = false
    var isNoteWithPhoto : Bool = false
    
    // note image
    var noteImage : UIImage?
    var noteImageUrl : URL?
    
    // note location
    var currentLocation : CLLocation?

}
