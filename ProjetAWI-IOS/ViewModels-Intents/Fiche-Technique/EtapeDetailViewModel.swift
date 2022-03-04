//
//  EtapeDetailViewModel.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 04/03/2022.
//

import Foundation
import Combine
import SwiftUI

enum EtapeViewModelError : Error, Equatable, CustomStringConvertible {
    case noError
    case inputError
    case addDenreeError
    var description: String {
        switch self {
        case .noError : return "Aucune erreur"
        case .inputError : return "Input non valide"
        case .addDenreeError : return "L'ajout de l'ingrédient a été refusé (duplication)"
        }
    }
}

class EtapeViewModel : ObservableObject, Subscriber, DescriptionObserver {

    private var etape : Etape
    private var indice : Int
    private var indiceSousFicheTechnique : Int? = nil
    
    var estEtapeSousFicheTechnique : Bool = false
    
    @Published var nomEtape : String
    @Published var dureeEtape : Double
    @Published var descriptionEtape : String
    
    @Published var contenu : [Denree]
    
    @Published var result : Result<String, EtapeViewModelError> = .failure(.noError)
    
    init(ficheTechViewModel : FicheTechniqueViewModel, indice : Int, indiceSousFiche : Int?  = nil){
        
        if let indiceSousFiche = indiceSousFiche {
            self.etape = ficheTechViewModel.progression[indice].etapes[indiceSousFiche]
            self.estEtapeSousFicheTechnique = true
        }
        else{
            self.etape = ficheTechViewModel.progression[indice].etapes[0]
        }
        
        self.indice = indice
        
        self.nomEtape = self.etape.description.nom
        self.dureeEtape = self.etape.description.tempsPreparation
        self.descriptionEtape = self.etape.description.description
        
        self.contenu = self.etape.contenu
        
    }
    
    
    typealias Input = EtapeIntentState
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    func receive(_ input: EtapeIntentState) -> Subscribers.Demand {
        switch input {
        case .ready:
            break
            
        case .changingNom(let nom):
            break
            
        case .changingDuree(let duree):
            break
            
        case .changingDescription(let desc):
            break
            
        case .addDenree(let idIngredient):
            break
            
        case .deleteDenree(let idTab):
            break
            
        case .changingDenreeNumber(let idTab, let nombre):
            break
        }
        
        return .none
    }
    
    func changed(nom: String) {
        self.nomEtape = nom
    }
    
    func changed(description: String) {
        self.descriptionEtape = description
    }
    
    func changed(tempsPreparation: Double) {
        self.dureeEtape = tempsPreparation
    }
    
    
}
