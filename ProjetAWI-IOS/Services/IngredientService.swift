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
    func emit(to: Result<String,IngredientListViewModelError>)
}

protocol IngredientServiceObserver {
    func emit(to: Result<String,IngredientViewModelError>)
}

class IngredientService {
    private let firestore = Firestore.firestore()
    private var tabListObserver : [IngredientListServiceObserver] = []
    private var tabObserver : [IngredientServiceObserver] = []
    private var tabIngredient : [Ingredient] {
        didSet {
            for observer in tabListObserver {
                observer.emit(to: tabIngredient)
            }
        }
    }
    
    init(){
        self.tabIngredient = []
    }
    
    func addObserver(observer : IngredientListServiceObserver){
        self.tabListObserver.append(observer)
        observer.emit(to: tabIngredient)
    }
    
    func addObserver(observer : IngredientServiceObserver){
        self.tabObserver.append(observer)
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
                                  listAllergene: doc["listAllergene"] as? [String] ?? []))
            }
        }

    }
    
    func updateIngredient(ingredient : Ingredient){
        let ref = firestore.collection("ingredients").document(ingredient.id!)
        ref.updateData(IngredientDTO.transformToDTO(ingredient)) {
            (error) in
            if let _ = error {
                self.sendResultElement(result: .failure(.updateError))
            } else {
                self.sendResultElement(result: .success("Mise a jour effectué"))
            }
        }
    }
    
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
    }
    
    // Link ingredient with allergène
    
    func getIngredientsByAllergène(allergène : String, action : (([Ingredient]) -> Void)?) {
            firestore.collection("ingredients").whereField("listAllergene", arrayContains: allergène)
            .getDocuments(){
                (querySnapshot, err) in
                if let err = err {
                    print("Error getting document : \(err)")
                }
                else{
                    let ingredients = querySnapshot!.documents.map{
                        (doc) -> Ingredient in
                        return IngredientDTO.transformDTO(
                            IngredientDTO(id: doc.documentID,
                                          nomIngredient: doc["nomIngredient"] as? String ?? "",
                                          prixUnitaire: doc["prixUnitaire"] as? Double ?? 0,
                                          qteIngredient: doc["qteIngredient"] as? Double ?? 0,
                                          unite: doc["unite"] as? String ?? "",
                                          categorie: doc["categorie"] as? String ?? "",
                                          listAllergene: doc["listAllergene"] as? [String] ?? []))
                    }
                    action?(ingredients)
                }
            }
    }
    
    // Récupère un ingrédient par son id ou retourn nil si il ne le trouve pas 
    func getIngredient(id : String) -> Ingredient?{
        let ingredients : [Ingredient] = tabIngredient.filter{ (ingredient) -> Bool in
            ingredient.id == id
        }
        if ingredients.count == 1 {
            return ingredients[0]
        }
        else {
            return nil
        }
    }
    
    // Result to observer
    
    private func sendResultElement(result : Result<String,IngredientViewModelError>){
        for observer in self.tabObserver {
            observer.emit(to: result)
        }
    }
    
    private func sendResultList(result : Result<String,IngredientListViewModelError>){
        for observer in self.tabListObserver {
            observer.emit(to: result)
        }
    }
}
