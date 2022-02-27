//
//  CategorieIngredientService.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 27/02/2022.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol CategorieIngredientServiceObserver {
    func emit(to: [String])
}

class CategorieIngredientService {
    private let firestore = Firestore.firestore()
    private var tabObserver : [CategorieIngredientServiceObserver] = []
    private var tabCategorieIngredient : [String] {
        didSet {
            for observer in tabObserver {
                observer.emit(to: tabCategorieIngredient)
            }
        }
    }
    
    init(){
        self.tabCategorieIngredient = []
    }
    
    func addObserver(observer : CategorieIngredientServiceObserver){
        self.tabObserver.append(observer)
        observer.emit(to: tabCategorieIngredient)
    }
    
    func getAllCategorieIngredient(){
        firestore.collection("categories-ingrédients").addSnapshotListener {
            (data, error) in
            guard let documents = data?.documents else {
                return
            }
            self.tabCategorieIngredient = documents.map{
                (doc) -> String in
                return doc["nomCategorie"] as? String ?? ""
            }
        }

    }
    /*
    func deleteIngredient(id : String){
        firestore.collection("ingredients").document(id).delete() {
            (error) in if let _ = error {
                self.sendResultList(result: .failure(.deleteError))
            } else{
                self.sendResultList(result: .success("Suppresion effectué !"))
            }
        }
    }
    
    func addIngredient(ingredient : Ingredient){
        firestore.collection("ingredients").addDocument(data: IngredientDTO.transformToDTO(ingredient)){
            (error) in if let _ = error {
                self.sendResultElement(result: .failure(.createError))
            } else {
                self.sendResultElement(result: .success("Création effectué"))
            }
        }
    }*/
}

