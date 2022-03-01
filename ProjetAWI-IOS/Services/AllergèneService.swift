//
//  AllergèneService.swift
//  ProjetAWI-IOS
//
//  Created by etud on 23/02/2022.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol AllergèneListServiceObserver {
    func emit(to: [Allergène])
    func emit(to: [String:[String]])
    func emit(to: Result<String,AllergèneListViewModelError>)
}

protocol AllergèneServiceObserver {
    func emit(to: Result<String,AllergèneViewModelError>)
}

class AllergèneService {
    
    private let firestore = Firestore.firestore()
    private var tabListObserver : [AllergèneListServiceObserver] = []
    private var tabObserver : [AllergèneServiceObserver] = []
    private var tabAllergène : [Allergène] {
        didSet {
            for observer in tabListObserver {
                observer.emit(to: tabAllergène)
            }
        }
    }
    private var tabIngredientFromAllergène : [String : [String]] {
        didSet {
            for observer in tabListObserver {
                observer.emit(to: tabIngredientFromAllergène)
            }
        }
    }
    private var ingredientService : IngredientService = IngredientService()
    init(){
        self.tabAllergène = []
        self.tabIngredientFromAllergène = [:]
    }
    
    func addObserver(observer : AllergèneListServiceObserver){
        self.tabListObserver.append(observer)
        observer.emit(to: tabAllergène)
    }
    
    func addObserver(observer : AllergèneServiceObserver){
        self.tabObserver.append(observer)
    }
    
    func getAllAllergène(){
        firestore.collection("allergenes").addSnapshotListener {
            (data, error) in
            guard let documents = data?.documents else {
                return
            }
            self.tabIngredientFromAllergène = [:]
            self.tabAllergène = documents.map{
                (doc) -> Allergène in
                
                return AllergèneDTO.transformDTO(
                    AllergèneDTO(id: doc.documentID,
                                 nom: doc["nom"] as? String ?? "" ,
                                listIngredient: []))
            }
            self.getIngredientsByAllergène()
        }
    }
    
    func updateAllergène(allergène : Allergène){
        let ref = firestore.collection("allergenes").document(allergène.id!)
        ref.updateData(AllergèneDTO.transformToDTO(allergène)) {
            (error) in
            if let _ = error {
                self.sendResultElement(result: .failure(.updateError))
            } else {
                self.sendResultElement(result: .success("Mise a jour effectué"))
            }
        }
    }
    
    func deleteAllergène(allergène : Allergène){
        for ingredientName in allergène.listIngredient {
            self.deleteAllergèneIntoIngredient(allergèneName: allergène.nom, ingredientName: ingredientName)
        }
        firestore.collection("allergenes").document(allergène.id!).delete() {
            (error) in if let _ = error {
                self.sendResultList(result: .failure(.deleteError))
            } else{
                self.sendResultList(result: .success("Suppresion effectué !"))
            }
        }
    }
    
    func addAllergène(allergène : Allergène){
        for ingredientName in allergène.listIngredient {
            self.addAllergèneIntoIngredient(allergèneName: allergène.nom, ingredientName: ingredientName)
        }
        firestore.collection("allergenes").addDocument(data: AllergèneDTO.transformToDTO(allergène)){
            (error) in if let _ = error {
                self.sendResultElement(result: .failure(.createError))
            } else {
                self.sendResultElement(result: .success("Création effectué"))
            }
        }
    }
    
    // Link allergène with ingredient
    
    private func getIngredientsByAllergène(){
        for allergène in self.tabAllergène {
            self.ingredientService.getIngredientByAllergène(allergène: allergène.nom) { ingredient in
                if self.tabIngredientFromAllergène[allergène.nom] != nil {
                    if !self.tabIngredientFromAllergène[allergène.nom]!.contains(ingredient) {
                        self.tabIngredientFromAllergène[allergène.nom]!.append(ingredient)
                    }
                } else {
                    self.tabIngredientFromAllergène[allergène.nom] = [ingredient]
                }
            }
        }
    }
    
    private func addAllergèneIntoIngredient(allergèneName : String, ingredientName : String){
        self.ingredientService.getIngredientByName(ingredient: ingredientName){
            ingredient in
            ingredient.listAllergene.append(allergèneName)
            self.ingredientService.updateIngredient(ingredient: ingredient)
        }
    }
    
    private func deleteAllergèneIntoIngredient(allergèneName : String, ingredientName : String){
        self.ingredientService.getIngredientByName(ingredient: ingredientName){
            ingredient in
            if let index = ingredient.listAllergene.firstIndex(of: allergèneName) {
                ingredient.listAllergene.remove(at: index)
            }
            self.ingredientService.updateIngredient(ingredient: ingredient)
        }
    }
    
    // get by Id + update + check valid form
    
    // update
    // if name !=
    //  if exist always
    //     if contains
    //           update change old by new
    //     else
    //           add new name
    //  else
    //    remove old name
    // else
    //   if not exists always
    //         remove name
    
    // check
    // func in view Model
    
    
    
    // Result to observer

    private func sendResultElement(result : Result<String,AllergèneViewModelError>){
        for observer in self.tabObserver {
            observer.emit(to: result)
        }
    }
    
    private func sendResultList(result : Result<String,AllergèneListViewModelError>){
        for observer in self.tabListObserver {
            observer.emit(to: result)
        }
    }
}
