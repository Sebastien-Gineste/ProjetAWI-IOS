//
//  UtilisateurListView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 19/02/2022.
//

import Foundation
import SwiftUI


struct UtilisateurListView : View {
    
    @State private var action: Int? = 0
    
    @StateObject var utilisateurModel : UtilisateurListViewModel = UtilisateurListViewModel()
    @State private var searchText : String = ""
    
    var utilisateursFiltre: [Utilisateur] {
        if searchText.isEmpty {
            return utilisateurModel.utilisateurs
        } else {
            return utilisateurModel.utilisateurs.filter{ $0.nom.uppercased().contains(searchText.uppercased()) || $0.prenom.uppercased().contains(searchText.uppercased()) }
        }
    }
    
    var body : some View {
        NavigationView{
            VStack{
                /*NavigationLink(destination: UtilisateurDetailView(model:UtilisateurService.instance.currentUtilisateur), tag: 1, selection: $action) {
                    
                }
                NavigationLink(destination:UtilisateurDetailView(model: Utilisateur(email: "", nom: "", prenom: "", type: .User, id: "")), tag: 2, selection: $action) {
                    
                }
                
                Button("Mon compte"){
                        //perform some tasks if needed before opening Destination view
                        self.action = 1
                    }
                Button("Créer un compte"){
                        //perform some tasks if needed before opening Destination view
                        self.action = 2
                    }*/
                NavigationLink(destination:UtilisateurDetailView(model: Utilisateur(email: "", nom: "", prenom: "", type: .User, id: ""))){
                    Text("ttgvg")
                }
               /* Button("Mon compte"){}
                NavigationLink(
                    destination: UtilisateurDetailView(model:UtilisateurService.instance.currentUtilisateur)) {
                }*/
                
               /* Text("Ajoute un compte")
                NavigationLink(
                    destination: UtilisateurDetailView(model: Utilisateur(email: "", nom: "", prenom: "", type: .User, id: ""))) {
                    
                }*/
                
                
                
                
                List {
                   HStack(spacing:0){
                       Text("Nom").frame(maxWidth:.infinity)
                       Text("Prénom").bold().frame(maxWidth:.infinity)
                       Text("Type").italic().frame(maxWidth:.infinity)
                   }.frame(minWidth : 0, maxWidth: .infinity)
                   
                    ForEach(Array(utilisateursFiltre.enumerated()), id: \.offset){index,utilisateur in
                       HStack(spacing:0){
                           Text(utilisateur.nom).frame(maxWidth:.infinity)
                           Text("\(utilisateur.prenom)").bold().frame(maxWidth:.infinity)
                           Text("\(utilisateur.type.rawValue)").italic().frame(maxWidth:.infinity)
                           NavigationLink(destination: UtilisateurDetailView(model: utilisateur, modelList: utilisateurModel)){
                           }.frame(maxWidth:0)
                       
                       }.frame(minWidth : 0, maxWidth: .infinity)
                   }
                   .onDelete{ indexSet in
                       utilisateurModel.utilisateurs.remove(atOffsets: indexSet)
                   }
                }.searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
                    .navigationTitle("Liste des utilisateurs")
                
               EditButton()
            }.padding()
        }
    }
    
}
