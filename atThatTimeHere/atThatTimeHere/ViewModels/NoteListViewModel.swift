//
//  NoteListViewModel.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 9/2/21.
//

import Foundation

class NoteListViewModel {
    
    //MARK: properties
    var  noteList = [Note]()
    
    func getNoteList() {
        // db
        DBService.shared.getNotes { result, notes in
            if result == false {
                //  실패
                self.noteList.removeAll()
                return
            }
            self.noteList = notes!
        }
    }

}
