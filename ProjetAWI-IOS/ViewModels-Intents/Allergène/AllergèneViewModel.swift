//
//  AllergèneViewModel.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 24/02/2022.
//

import Foundation
import SwiftUI
import Combine

enum AllergèneViewModelError : Error, Equatable, CustomStringConvertible {
    case noError
    case updateError
    var description: String {
        switch self {
        case .noError : return "Aucune erreur"
        case .updateError : return "Erreur de mise à jour"
        }
    }
}

class AllergèneViewModel : ObservableObject, Subscriber, AllergèneServiceObserver, AllergèneObserver {

    private var allergèneService : AllergèneService = AllergèneService.instance
    private var allergèneListViewModel : AllergèneListViewModel
    private var indice : Int
    @Published var nom : String
    @Published var result : Result<String, AllergèneViewModelError> = .success("")
    
    init(allergèneListViewModel : AllergèneListViewModel, indice : Int) {
        self.allergèneListViewModel = allergèneListViewModel
        self.indice = indice
        self.nom = allergèneListViewModel.tabAllergène[indice].nom
        self.allergèneService.addObserver(observer: self)
    }
    
    func emit(to: Result<String, AllergèneViewModelError>) {
        self.result = to
    }
    
    typealias Input = AllergèneIntentState
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    func receive(_ input: AllergèneIntentState) -> Subscribers.Demand {
        switch input {
        case .ready:
            break
        case .changingNom(let string):
            self.allergèneListViewModel.tabAllergène[indice].nom = string
            if self.allergèneListViewModel.tabAllergène[indice].nom != string {
                self.nom = self.allergèneListViewModel.tabAllergène[indice].nom
            }
        case .updateDatabase:
           self.allergèneService.updateAllergène(allergène: self.allergèneListViewModel.tabAllergène[indice])
        }
        return .none
    }
    
    func changed(nom: String) {
        self.nom = nom
    }
    
}
