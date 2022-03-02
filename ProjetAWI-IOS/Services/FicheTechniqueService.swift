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
    
    

}
