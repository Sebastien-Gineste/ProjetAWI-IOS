//
//  CategorieRecetteService.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 02/03/2022.
//

import Foundation


import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol CategorieRecetteServiceObserver {
    func emit(to: [String])
}

class CategorieRecetteService {
    private let firestore = Firestore.firestore()
    private var tabObserver : [CategorieRecetteServiceObserver] = []
    private var tabCategorieRecette : [String] {
        didSet {
            for observer in tabObserver {
                observer.emit(to: tabCategorieRecette)
            }
        }
    }
    
    init(){
        self.tabCategorieRecette = []
    }
    
    func addObserver(observer : CategorieRecetteServiceObserver){
        self.tabObserver.append(observer)
        observer.emit(to: tabCategorieRecette)
    }
    
    func getAllCategorieRecette(){
        firestore.collection("categories-recettes").addSnapshotListener {
            (data, error) in
            guard let documents = data?.documents else {
                return
            }
            self.tabCategorieRecette = documents.map{
                (doc) -> String in
                return doc["nomCategorie"] as? String ?? ""
            }
            
        }

    }
}
