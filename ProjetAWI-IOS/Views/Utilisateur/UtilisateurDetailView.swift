//
//  UtilisateurDetailView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 19/02/2022.
//


import Foundation
import SwiftUI


struct UtilisateurDetailView : View {
    
    @ObservedObject var utilisateurVM : UtilisateurListViewModel
    var indice : Int
    var intent : UtilisateurIntent
    @ObservedObject var utilisateur : UtilisateurViewModel
    
    init(vm: UtilisateurListViewModel, indice : Int){
        self.utilisateurVM = vm
        self.intent = UtilisateurIntent()
        self.indice = indice
        self.utilisateur = UtilisateurViewModel(model: vm, indice: indice)
        self.intent.addObserver(utilisateurViewModel: self.utilisateur , utilisateurListViewModel: vm )
    }
 
    var body : some View{
        VStack(alignment:.center){
            HStack{
                Text("Nom : ")
                TextField("",text : $utilisateur.nom).onSubmit {
                    intent.intentToChange(name: utilisateur.nom)
                }
            }
            HStack{
                Text("Prénom : ")
                TextField("",text : $utilisateurVM.utilisateurs[indice].prenom)
            }
            HStack{
                Text("Type : ")
                Picker("Rôle", selection : $utilisateurVM.utilisateurs[indice].type){
                    Text("User").tag(TypeUtilisateur.User)
                    Text("Admin").tag(TypeUtilisateur.Admin)
                }
            }
        }.navigationTitle("Détail \(utilisateur.nom)").padding()
        Spacer()
    }
}
