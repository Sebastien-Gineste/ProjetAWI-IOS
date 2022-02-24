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
                
                IngredientListView(vm:IngredientListViewModel())
                    .tabItem {
                        Image(systemName: "list.bullet.rectangle.portrait.fill")
                        Text("Ingrédient")
                    }
                
                AllergèneListView(vm: AllergèneListViewModel())
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
                    PreferenceView(vm:StoreViewModel())
                        .tabItem{
                            Image(systemName: "gearshape.2.fill")
                            Text("Préférences")
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
