//
//  UtilisateurDetailView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 19/02/2022.
//


import Foundation
import SwiftUI


struct UtilisateurDetailView : View {
    
    @StateObject var user : UtilisateurService = UtilisateurService.instance
    var intent : UtilisateurIntent
    @ObservedObject var utilisateur : UtilisateurViewModel
    
    @State private var disabledTextField = true
    @State private var nomButton = "Modifier"
    @State var alertMessage = ""
    @State var showingAlert : Bool = false
    
    init(model : Utilisateur, modelList : UtilisateurListViewModel? = nil){
        self.intent = UtilisateurIntent()
        self.utilisateur = UtilisateurViewModel(from: model)
       /* if let mod = modelList {
            self.intent.addObserver(utilisateurViewModel: self.utilisateur, utilisateurListViewModel: mod)
        }
        else{*/
            self.intent.addObserver(utilisateurViewModel: self.utilisateur)
       /** }*/
       
    }
    
    func updateAccount(){
        print("modification")
    }
 
    var body : some View{
        VStack(alignment:.center){
            Spacer()
            HStack{
                Text("E-mail : \(utilisateur.email)")
            }
            
            HStack{
                Text("Nom : ")
                TextField("",text : $utilisateur.nom)
                    .disabled(disabledTextField)
                    .onSubmit {
                        intent.intentToChange(name: utilisateur.nom)
                    }
            }
            HStack{
                Text("Prénom : ")
                TextField("",text : $utilisateur.prenom)
                    .disabled(disabledTextField)
                    .onSubmit {
                        intent.intentToChange(firstName: utilisateur.prenom)
                    }
            }
            
            if user.currentUtilisateur.estAdmin(){
                HStack{
                    Text("Type : ")
                    Picker("Rôle", selection : $utilisateur.type){
                        Text("User").tag(TypeUtilisateur.User)
                        Text("Admin").tag(TypeUtilisateur.Admin)
                    }.disabled(disabledTextField)
                        .onChange(of: utilisateur.type, perform: {
                            value in
                            intent.intentToChange(type: value)
                        })
                }
            }
            
            HStack{
                Button("Supprimer"){
                    intent.intentToDeleteUser()
                    // retourner en arrière 
                }
                
                Button(nomButton){
                    disabledTextField = !disabledTextField
                    if nomButton == "Modifier" {
                        nomButton = "Valider"
                    }
                    else{
                        nomButton = "Modifier"
                        print("go udapte")
                        intent.intentToUpdateDatabase()
                    }
                }
                
                if !disabledTextField {
                    Button("Annuler"){
                        disabledTextField = true
                        nomButton = "Modifier"
                    }
                }
            }
           
            Spacer()
        }.navigationTitle("Détail \(utilisateur.nom)")
            .padding()
            .onChange(of: utilisateur.result){
                result in
                switch result {
                case let .success(msg):
                    self.alertMessage = msg
                    self.showingAlert = true
                case let .failure(error):
                    switch error {
                    case .updateError, .createError, .deleteError, .emailError, .errorName, .mdpError, .errorFirstName:
                        self.alertMessage = "\(error)"
                        self.showingAlert = true
                    case .noError :
                        return
                    }
                }
            }
            .alert("\(alertMessage)", isPresented: $showingAlert){

                Button("OK", role: .cancel){
                    utilisateur.result = .failure(.noError)
                }
            }
        
    }
}
