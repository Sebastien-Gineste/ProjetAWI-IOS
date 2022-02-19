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
               ForEach(utilisateurModel.utilisateurs.indices, id: \.self){ indice in
                   HStack{
                       VStack(alignment: .leading){
                           Text(self.utilisateurModel.utilisateurs[indice].nom)
                           Text("\(self.utilisateurModel.utilisateurs[indice].prenom)").bold()
                           Text("\(self.utilisateurModel.utilisateurs[indice].estAdmin ? "Admin" : "User")").italic()
                           //NavigationLink(destination: TrackView(vm: self.items, indice: indice)){
                           //}.navigationTitle("Apple Music Tracks")
                       }
                   }
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
