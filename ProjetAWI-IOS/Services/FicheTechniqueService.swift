//
//  FicheTechniqueService.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 28/02/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol FicheTechniqueListServiceObserver {
    func emit(to: [FicheTechnique])
    func emit(to: Result<String,FicheTechniqueListViewModelError>)
}

protocol FicheTechniqueServiceObserver {
    func emit(to : Result<String, FicheTechniqueViewModelError>)
}

class FicheTechniqueService {
    private let firestore = Firestore.firestore()
    private var tabFicheTechnique : [FicheTechnique] {
        didSet {
            self.observerList?.emit(to: tabFicheTechnique)
        }
    }
    
    
    private var observerList : FicheTechniqueListServiceObserver? = nil
    private var observerElement : FicheTechniqueServiceObserver? = nil
    
    
    
    init(){
        self.tabFicheTechnique = []
    }
    
    func setObserver(obs : FicheTechniqueListServiceObserver){
        self.observerList = obs
        obs.emit(to: tabFicheTechnique)
    }
    
    func setObserver(obs : FicheTechniqueServiceObserver){
        self.observerElement = obs
    }
    
    func removeObserver(obs : FicheTechniqueServiceObserver){
        self.observerElement = nil
    }
    
    private func sendResultElement(result : Result<String,FicheTechniqueViewModelError>){
        self.observerElement?.emit(to: result)
    }
    
    private func sendResultList(result : Result<String,FicheTechniqueListViewModelError>){
        self.observerList?.emit(to: result)
    }
    
    
    func getAllFicheTechnique(){
        firestore.collection("fiche-techniques").addSnapshotListener {
            (data, error) in
            guard let documents = data?.documents else {
                return
            }
            self.tabFicheTechnique = documents.map{
                (doc) -> FicheTechnique in
                return FicheTechniqueDTO.transformDTO(
                    FicheTechniqueDTO.docToDTO(doc: doc))
            }
        }
    }
    
    func addFicheTechnique(fiche : FicheTechnique){
        print("add Fiche")
        sendResultList(result: .success("Ajout effectuée : (nom : \(fiche.header.nomPlat)"))
    }
    
    func removeFicheTechnique(id : String){
        print("remove Fiche")
        sendResultList(result: .success("Supression effectuée (id : \(id)"))
    }
    
    func updateFicheTechnique(fiche : FicheTechnique){
        print("udpate fiche")
        sendResultList(result: .success("Modification enregistrée (nom : \(fiche.header.nomPlat)"))
    }
    
    // Récupère une fiche technique pour la mettre en étape d'une autre fiche
    // Elle ne doit pas contenir de sous-fiche technique
    func getFicheTechnique(id : String) -> FicheTechnique?{
        let fiches : [FicheTechnique] = tabFicheTechnique.filter{ (fiche) -> Bool in
            fiche.header.id == id && fiche.progression.filter { (etapeFiche) -> Bool in
                etapeFiche.estSousFicheTechnique
            }.count == 0 // on est sûr qu'elle ne contient pas de sous fiche technique
        }
        if fiches.count == 1 {
            return fiches[0]
        }
        else {
            return nil
        }
    }
    
    
    

}
