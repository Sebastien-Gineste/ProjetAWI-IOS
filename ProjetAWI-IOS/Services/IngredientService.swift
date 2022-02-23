//
//  IngredientService.swift
//  ProjetAWI-IOS
//
//  Created by etud on 23/02/2022.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol IngredientListServiceObserver {
    func emit(to: [Ingredient])
}

class IngredientService {
    
    public static let instance = IngredientService()
    private let firestore = Firestore.firestore()
    private var tabListObserver : [IngredientListServiceObserver] = []
    private var tabIngredient : [Ingredient] {
        didSet {
            for observer in tabListObserver {
                observer.emit(to: tabIngredient)
            }
        }
    }
    
    private init(){
        self.tabIngredient = []
    }
    
    func addObserver(observer : IngredientListServiceObserver){
        self.tabListObserver.append(observer)
        observer.emit(to: tabIngredient)
    }
    
    func getAllIngredient(){
        firestore.collection("ingredients").addSnapshotListener {
            (data, error) in
            guard let documents = data?.documents else {
                return
            }
            self.tabIngredient = documents.map{
                (doc) -> Ingredient in
                return IngredientDTO.transformDTO(
                    IngredientDTO(id: doc.documentID,
                                  nomIngredient: doc["nomIngredient"] as? String ?? "",
                                  prixUnitaire: doc["prixUnitaire"] as? Double ?? 0,
                                  qteIngredient: doc["qteIngredient"] as? Double ?? 0,
                                  unite: doc["unite"] as? String ?? "",
                                  categorie: doc["categorie"] as? String ?? "",
                                  listAllergene: []))
            }
        }

    }
}
