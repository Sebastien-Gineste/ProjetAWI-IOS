//
//  FicheTechniqueListViewModel.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 01/03/2022.
//

import Foundation
import Combine

enum FicheTechniqueListViewModelError : Error, Equatable, CustomStringConvertible{
    case noError
    case deleteError
    var description: String {
        switch self {
        case .noError : return "Aucune erreur"
        case .deleteError : return "Erreur de supression"
        }
    }
}


class FicheTechniqueListViewModel : ObservableObject, Subscriber, FicheTechniqueListServiceObserver {
    
    private var ficheTechniqueService : FicheTechniqueService = FicheTechniqueService()
    @Published var tabFicheTechnique : [FicheTechnique]
    @Published var result : Result<String, FicheTechniqueListViewModelError> = .failure(.noError)
    
    init(){
        self.tabFicheTechnique = []
        self.ficheTechniqueService.getAllFicheTechnique()
        self.ficheTechniqueService.setObserver(obs: self)
    }
    
    func emit(to: [FicheTechnique]) {
        self.tabFicheTechnique = to
    }
    
    func emit(to: Result<String, FicheTechniqueListViewModelError>) {
        self.result = to
    }
    
    
    typealias Input = FicheTechniqueListIntentState
    
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
            subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    func receive(_ input: FicheTechniqueListIntentState) -> Subscribers.Demand {
        switch input {
        case .ready:
            break
        case .deleteFicheTechnique(let id):
            // faire action
            print("deleteFicheTechnique : \(id)")
        }
        return .none
    }
    
}
