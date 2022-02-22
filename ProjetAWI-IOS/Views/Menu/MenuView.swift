//
//  MenuView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 17/02/2022.
//

import SwiftUI

// TAB VIEW 

struct MenuView: View {
    
    @StateObject var user : UtilisateurService = UtilisateurService.instance
    
    var body: some View {
        TabView {
            FicheTechniqueListView()
                .tabItem {
                    Image(systemName: "list.bullet.below.rectangle")
                    Text("Fiche")
                }
            
            if user.currentUtilisateur.estConnecte() {
                
                FicheTechniqueListView()
                    .tabItem {
                        Image(systemName: "list.bullet.rectangle.portrait.fill")
                        Text("Ingrédient")
                    }
                
                FicheTechniqueListView()
                    .tabItem {
                        Image(systemName: "list.bullet.rectangle.portrait.fill")
                        Text("Allergènes")
                    }
                
                UtilisateurListView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Comptes")
                    }
                
                if user.currentUtilisateur.estAdmin() {
                    FicheTechniqueListView()
                        .tabItem{
                            Image(systemName: "gearshape.2.fill")
                            Text("Paramètre")
                        }
                }
            }
            else{
                ConnexionView()
                    .tabItem{
                        Image(systemName: "person.fill")
                        Text("Connexion")
                    }
                
            }
            
        }.accentColor(Color.specialGreen)
    }
}
