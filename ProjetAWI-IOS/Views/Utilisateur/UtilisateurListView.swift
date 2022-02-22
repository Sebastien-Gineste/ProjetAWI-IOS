//
//  UtilisateurListView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 19/02/2022.
//

import Foundation
import SwiftUI


struct UtilisateurListView : View {
    
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
        VStack{
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
                       Text("\(utilisateur.estAdmin.rawValue)").italic().frame(maxWidth:.infinity)
                       NavigationLink(destination: UtilisateurDetailView(vm: utilisateurModel, indice: index)){
                           
                       }.frame(maxWidth:0)
                   
                   }.frame(minWidth : 0, maxWidth: .infinity)
               }
               .onDelete{ indexSet in
                   utilisateurModel.utilisateurs.remove(atOffsets: indexSet)
               }
               .onMove{ indexSet, index in
                   utilisateurModel.utilisateurs.move(fromOffsets: indexSet, toOffset: index)
               }
            }.searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
                .navigationTitle("Liste des utilisateurs")
            
           EditButton()
       }.padding()
    }
    
}