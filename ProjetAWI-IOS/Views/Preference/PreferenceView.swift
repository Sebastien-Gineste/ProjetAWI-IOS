//
//  PreferenceView.swift
//  ProjetAWI-IOS
//
//  Created by etud on 22/02/2022.
//

import SwiftUI


struct PreferenceView : View {
    
    //@StateObject var utilisateurModel : UtilisateurListViewModel = UtilisateurListViewModel()
    
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
                   //utilisateurModel.utilisateurs.remove(atOffsets: indexSet)
               }
               .onMove{ indexSet, index in
                   //utilisateurModel.utilisateurs.move(fromOffsets: indexSet, toOffset: index)
               }
            }
            .navigationTitle("Préferences de calculs")
            
           EditButton()
       }.padding()
    }
    
}
