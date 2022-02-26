//
//  UtilisateurDetailView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 19/02/2022.
//


import Foundation
import SwiftUI


struct UtilisateurDetailView : View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var user : UtilisateurService = UtilisateurService.instance
    @State private var isCreate : Bool
    var model : Utilisateur
    var intent : UtilisateurIntent
    
        
    init(model : Utilisateur = Utilisateur(email: "", nom: "", prenom: "", type: .User, id: "")){
        self.model = model
        self.intent = UtilisateurIntent()
        self._isCreate = State(initialValue:  (model.email.count == 0))
    }
    
 
    var body : some View{
        VStack(alignment:.center){
            Spacer()
            HStack{
                Text("E-mail : \(model.email)")
            }.padding(10)
                
            HStack{
                Text("Nom : \(model.nom)")
            }.padding(10)
            
            HStack{
                Text("Prénom : \(model.prenom)")
            }.padding(10)
            
            if user.currentUtilisateur.estAdmin(){
                HStack{
                    Text("Type : \(model.type.rawValue)")
                }.padding(10)
            }
            
            Spacer()
            
            HStack(spacing:20){
                    Button("Supprimer"){
                        intent.intentToDeleteUser()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                NavigationLink(destination:UtilisateurCreateUpdateView(model:model, intent : intent, viewModel: UtilisateurViewModel(from: model))){
                        Text("Modifier")
                    }
            }
            
        }.navigationTitle("Détail \(model.nom)")
            .padding()
    }
}
