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
    
    
    var body : some View {
        VStack{
           List {
               
               HStack(spacing:0){
                   Text("Nom").frame(maxWidth:.infinity)
                   Text("Prénom").bold().frame(maxWidth:.infinity)
                   Text("Type").italic().frame(maxWidth:.infinity)
               }.frame(minWidth : 0, maxWidth: .infinity)
               
               ForEach(utilisateurModel.utilisateurs.indices, id: \.self){ indice in
                   HStack(spacing:0){
                       Text(self.utilisateurModel.utilisateurs[indice].nom).frame(maxWidth:.infinity)
                       Text("\(self.utilisateurModel.utilisateurs[indice].prenom)").bold().frame(maxWidth:.infinity)
                       Text("\(self.utilisateurModel.utilisateurs[indice].estAdmin ? "Admin" : "User")").italic().frame(maxWidth:.infinity)
                       NavigationLink(destination: UtilisateurDetailView()){
                       }.navigationTitle("Détails de l'utilisateur").frame(maxWidth:0)
                   
                   }.frame(minWidth : 0, maxWidth: .infinity)
               }
               .onDelete{ indexSet in
                   utilisateurModel.utilisateurs.remove(atOffsets: indexSet)
               }
               .onMove{ indexSet, index in
                   utilisateurModel.utilisateurs.move(fromOffsets: indexSet, toOffset: index)
               } }
           EditButton()
       }.padding()
    }
    
}
