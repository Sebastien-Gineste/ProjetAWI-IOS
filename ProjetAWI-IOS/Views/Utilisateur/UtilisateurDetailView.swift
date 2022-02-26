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

    @StateObject var user : UtilisateurService = UtilisateurService.instance
    var intent : UtilisateurIntent
    @ObservedObject var utilisateur : UtilisateurViewModel
    
    @State private var disabledTextField : Bool
    @State private var nomButton = "Modifier"
    @State var alertMessage = ""
    @State var showingAlert : Bool = false
    @State private var isCreate : Bool
    
    
    init(model : Utilisateur = Utilisateur(email: "", nom: "", prenom: "", type: .User, id: "")){
        self._disabledTextField = State(initialValue: (model.email.count > 0))
        self._isCreate = State(initialValue:  (model.email.count == 0))
        
        self.intent = UtilisateurIntent()
        self.utilisateur = UtilisateurViewModel(from: model)
    
        self.intent.addObserver(self.utilisateur)
    }
    
    func updateAccount(){
        print("modification")
    }
 
    var body : some View{
        VStack(alignment:.center){
            Spacer()
            HStack{
                Text("E-mail : ")
                TextField("", text : $utilisateur.email).disabled(!isCreate).onSubmit {
                    intent.intentToChange(email: utilisateur.email)
                }
            }.padding(10)
            
            if isCreate {
            HStack{
                Text("Mot de passe : ")
                TextField("", text : $utilisateur.motDePasse).disabled(!isCreate)
                    .onSubmit {
                        intent.intentToChange(password: utilisateur.motDePasse)
                    }
            }.padding(10)
            }
                
            HStack{
                Text("Nom : ")
                TextField("",text : $utilisateur.nom)
                    .disabled(disabledTextField)
                    .onSubmit {
                        intent.intentToChange(name: utilisateur.nom)
                    }
            }.padding(10)
            HStack{
                Text("Prénom : ")
                TextField("",text : $utilisateur.prenom)
                    .disabled(disabledTextField)
                    .onSubmit {
                        intent.intentToChange(firstName: utilisateur.prenom)
                    }
            }.padding(10)
            
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
                }.padding(10)
            }
            
            Spacer()
            
            HStack(spacing:10){
                
                
                if !isCreate {
                    Button("Supprimer"){
                        intent.intentToDeleteUser()
                        self.presentationMode.wrappedValue.dismiss()
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
                
                else {
                    Button("Créer le compte"){
                        intent.intentToCreateUser()
                    }
                }
            }
           
            
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
            }.onAppear(){
                self.utilisateur.addObserverResult()
            }.onDisappear(){
                self.utilisateur.removeObserverResult()
            }
        
    }
}
