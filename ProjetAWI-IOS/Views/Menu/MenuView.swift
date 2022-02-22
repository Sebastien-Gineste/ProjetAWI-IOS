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
                    Image(systemName: "list.dash")
                    Text("Fiche")
                }
            
            if user.currentUtilisateur.estConnecte() {
                
                FicheTechniqueListView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Ingrédient")
                    }
                
                FicheTechniqueListView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Allergènes")
                    }
                
                UtilisateurListView()
                    .tabItem {
                        Image(systemName: "person")
                        Text("Comptes")
                    }
            }
            else{
                ConnexionView()
                    .tabItem{
                        Image(systemName: "house")
                        Text("Connexion")
                    }
                
            }
            
        }.accentColor(Color.green)
    }
}
