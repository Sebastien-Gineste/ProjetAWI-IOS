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
            FicheTechniqueListView().tabItem {
                Image(systemName: "list.bullet.below.rectangle")
                Text("Fiche")
            }

            
            if user.currentUtilisateur.estConnecte() {
                
                IngredientListView(vm:IngredientListViewModel(), vmCategorie: CategorieIngredientViewModel())
                    .tabItem {
                        Image(systemName: "list.bullet.rectangle.portrait.fill")
                        Text("Ingrédient")
                    }
                
                AllergèneListView(vm: AllergèneListViewModel())
                    .tabItem {
                        Image(systemName: "list.bullet.rectangle.portrait.fill")
                        Text("Allergènes")
                    }
                if !user.currentUtilisateur.estAdmin() {
                    
                        GestionCompteView()
                        .tabItem{
                           Image(systemName: "person.fill")
                           Text("Compte")
                        }
                    
                }
                
                else {
                    UtilisateurListView(vm : UtilisateurListViewModel())
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("Comptes")
                        }
                    
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
