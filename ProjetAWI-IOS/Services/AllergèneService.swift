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
            //self.getIngredientsByAllergène()
        }
    }
    
    func updateAllergène(allergène : Allergène, oldIngredient : [String]){
        //self.updateAllergèneIntoIngrédient(allergène: allergène, oldIngredient : oldIngredient)
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
    /*
    private func addAllergèneIntoIngredient(allergèneName : String, ingredientName : String, action : (() -> Void)? = nil){
        self.ingredientService.getIngredientByName(ingredient: ingredientName){
            ingredient in
            ingredient.listAllergene.append(allergèneName)
            self.ingredientService.updateIngredient(ingredient: ingredient){
                action?()
            }
        }
    }*/
    
    private func deleteAllergèneIntoIngredient(allergèneName : String, ingredientName : String, action: (() -> Void)? = nil){
        self.ingredientService.getIngredientByName(ingredient: ingredientName){
            ingredient in
            if let index = ingredient.listAllergene.firstIndex(of: allergèneName) {
                ingredient.listAllergene.remove(at: index)
            }
            self.ingredientService.updateIngredient(ingredient: ingredient)
            action?()
        }
    }
    
    /*private func updateAllergèneIntoIngrédient(allergène : Allergène, oldIngredient : [String]){
        print("1")
        self.getAllergèneById(id: allergène.id!){ allergèneOld in
            for ingredient in oldIngredient {
                print("2")
                print(allergène.nom)
                print(allergèneOld.nom)
                if allergène.nom == allergèneOld.nom {
                    print("8")
                    if !allergène.listIngredient.contains(ingredient) {
                        if oldIngredient.contains(ingredient) {
                            self.deleteAllergèneIntoIngredient(allergèneName: allergène.nom, ingredientName: ingredient){
                                self.getAllAllergène()
                            }
                            print("9")
                        }
                        
                    }
                    // add
                } else {
                    print("3")
                    print(ingredient)
                    if allergène.listIngredient.contains(ingredient) {
                        print("4")
                        self.ingredientService.getIngredientByName(ingredient: ingredient){
                            ingredientOld in
                            if let index = ingredientOld.listAllergene.firstIndex(of: allergèneOld.nom) {
                                ingredientOld.listAllergene.remove(at: index)
                                print("5")
                            }
                            print("6")
                            ingredientOld.listAllergene.append(allergène.nom)
                            self.ingredientService.updateIngredient(ingredient: ingredientOld)
                        }
                    } else if oldIngredient.contains(ingredient){
                        print("7")
                        self.deleteAllergèneIntoIngredient(allergèneName: allergène.nom, ingredientName: ingredient)
                    }
                }

            }
        }
    }
     */
    // update + check valid form
    
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
    func getAllergèneById(id : String, action : ((Allergène) -> Void)?){
        firestore.collection("allergenes").document(id).getDocument(){data,err in
            if let err = err {
                print("Error getting document : \(err)")
            }
            else{
                guard let doc = data else {
                    return
                }
                action?(AllergèneDTO.transformDTO(
                    AllergèneDTO(id: doc.documentID,
                                  nom: doc["nom"] as? String ?? "",
                                  listIngredient: []))
                )
                
            }
        }
    }
    
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
