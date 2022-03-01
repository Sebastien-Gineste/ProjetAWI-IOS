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
    func emit(to: Result<String,FicheTechniqueViewModelError>)
}

class FicheTechniqueService {
    private let firestore = Firestore.firestore()
    private var tabFicheTechnique : [FicheTechnique] {
        didSet {
            self.observerList?.emit(to: tabFicheTechnique)
        }
    }
    
    
    private var observerList : FicheTechniqueListServiceObserver? = nil
    
    
    
    init(){
        self.tabFicheTechnique = []
    }
    
    func setObserverList(obs : FicheTechniqueListServiceObserver){
        self.observerList = obs
        obs.emit(to: tabFicheTechnique)
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
