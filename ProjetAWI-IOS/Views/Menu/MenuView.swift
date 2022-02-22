//
//  MenuView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 17/02/2022.
//

import SwiftUI

// TAB VIEW 

struct MenuView: View {
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(destination: TestView() ){
                HStack {
                    Text("Ingredients")
                        .foregroundColor(.black)
                        .font(.headline)
                }
            } .padding(.top, 70)
            NavigationLink(destination: TestView() ){
                HStack {
                    Text("Allergènes")
                        .foregroundColor(.black)
                        .font(.headline)
                }
            }.padding(.top, 5)
            NavigationLink(destination: TestView() ){
                HStack {
                    Text("Préférences de calculs")
                        .foregroundColor(.black)
                        .font(.headline)
                }
            }.padding(.top, 5)
            Divider().padding(.top,10)
            NavigationLink(destination: TestView() ){
                HStack {
                    Text("Connexion")
                        .foregroundColor(.black)
                        .font(.headline)
                }
            }.padding(.top, 10)
            NavigationLink(destination: TestView() ){
                HStack {
                    Text("Deconnexion")
                        .foregroundColor(.black)
                        .font(.headline)
                }
            }.padding(.top, 5)
            NavigationLink(destination: UtilisateurListView() ){
                HStack {
                    Text("Liste des utilisateurs")
                        .foregroundColor(.black)
                        .font(.headline)
                }
            }.padding(.top, 5)
            NavigationLink(destination: TestView() ){
                HStack {
                    Text("Mon Profil")
                        .foregroundColor(.black)
                        .font(.headline)
                }
            }.padding(.top, 5)
            NavigationLink(destination: TestView() ){
                HStack {
                    Text("Créer un compte")
                        .foregroundColor(.black)
                        .font(.headline)
                }
            }.padding(.top, 5)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.specialWhite)
        .edgesIgnoringSafeArea(.all)
    }
}
