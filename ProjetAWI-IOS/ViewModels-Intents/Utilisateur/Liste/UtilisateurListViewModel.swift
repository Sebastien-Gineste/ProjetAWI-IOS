//
//  UtilisateurListViewModel.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 19/02/2022.
//

import Foundation
import Combine


class UtilisateurListViewModel : ObservableObject, Subscriber, UserServiceObserver{
    @Published var utilisateurs : [Utilisateur]
    private var userService : UtilisateurService = UtilisateurService()
    
    func emit(to: [Utilisateur]){
        self.utilisateurs = to
    }
    
    init(){
        self.utilisateurs = []
        self.userService.setObserver(obs: self)

    }
    
    typealias Input = UtilisateurListIntentState
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
           subscription.request(.unlimited)
    }
       
    func receive(completion: Subscribers.Completion<Never>) {
       return
    }
   
    func receive(_ input: UtilisateurListIntentState) -> Subscribers.Demand {
       switch input {
       case .ready:
           break
       case .updateList:
           self.objectWillChange.send()
           break
       }
       return .none
    }
}
