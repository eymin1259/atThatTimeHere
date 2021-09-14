//
//  NoteListViewModel.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 9/2/21.
//

import Foundation
import RxSwift

class NoteListViewModel {
    
    //MARK: properties
    var  noteList = [Note]()
    var disposebag : DisposeBag?
    
    func updateNoteList() {
        
        // 현재 로그인된 유저아이디
        guard let uid = UserDefaults.standard.dictionary(forKey: CURRENTUSERKEY)?["id"] as? String else { return }
        guard let disposebag = disposebag else {return}
        
        // notes from db
        NoteService.shared.getNotesRX(userId: uid)
            .subscribe(onNext: { notes in
                self.noteList.removeAll()
                self.noteList = notes
            }, onError: {error in
                //  실패
                self.noteList.removeAll()
                self.noteList = [Note]() // 빈배열 할당
            }).disposed(by: disposebag)
    }
}
