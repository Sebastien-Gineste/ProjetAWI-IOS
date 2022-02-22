//
//  ContentView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 17/02/2022.
//

import SwiftUI

struct MainView: View {

    @ObservedObject var currentUser : Utilisateur = UtilisateurService.instance.currentUtilisateur
    
    
    var body: some View {
        TabView {
            FicheTechniqueListView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Fiche")
                }
            
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
                    Image(systemName: "house")
                    Text("compte")
                }
        }
        
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
