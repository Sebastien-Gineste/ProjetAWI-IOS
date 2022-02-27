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
    @ObservedObject var utilisateurViewModel : UtilisateurViewModel
    @State private var nomButton = "Modifier"
    @State var alertMessage = ""
    @State var showingAlert : Bool = false
    @State private var isCreate : Bool
    
    
    init(model : Utilisateur = Utilisateur(email: "", nom: "", prenom: "", type: .User, id: "")){
        self._isCreate = State(initialValue:  (model.email.count == 0))
        
        self.intent = UtilisateurIntent()
        self.utilisateurViewModel = UtilisateurViewModel(from: model)
    
        self.intent.addObserver(self.utilisateurViewModel)
    }
    
    var disabledTextField : Bool {
        return !isCreate && nomButton == "Modifier"
    }
 
    var body : some View{
        VStack(alignment:.center){
            Spacer()
            Form {
                Section {
                    HStack{
                        Text("E-mail : ")
                        TextField("E-mail", text : $utilisateurViewModel.email).disabled(disabledTextField).onSubmit {
                            intent.intentToChange(email: utilisateurViewModel.email)
                        }
                    }.padding(10)
                    
                    if isCreate || nomButton == "Valider" {
                        HStack{
                            Text("Mot de passe : ")
                            TextField("Mot de passe", text : $utilisateurViewModel.motDePasse).disabled(disabledTextField)
                                .onSubmit {
                                    intent.intentToChange(password: utilisateurViewModel.motDePasse)
                                }
                        }.padding(10)
                    }
                }
                
                Section {
                    HStack{
                        Text("Nom : ")
                        TextField("Nom",text : $utilisateurViewModel.nom)
                            .disabled(disabledTextField)
                            .onSubmit {
                                intent.intentToChange(name: utilisateurViewModel.nom)
                            }
                    }.padding(10)
                    HStack{
                        Text("Prénom : ")
                        TextField("Prenom",text : $utilisateurViewModel.prenom)
                            .disabled(disabledTextField)
                            .onSubmit {
                                intent.intentToChange(firstName: utilisateurViewModel.prenom)
                            }
                    }.padding(10)
                    
                    if user.currentUtilisateur.estAdmin(){
                        HStack{
                            Picker("Rôle", selection : $utilisateurViewModel.type){
                                Text("User").tag(TypeUtilisateur.User)
                                Text("Admin").tag(TypeUtilisateur.Admin)
                            }.disabled(disabledTextField)
                                .onChange(of: utilisateurViewModel.type, perform: {
                                    value in
                                    intent.intentToChange(type: value)
                                })
                        }.padding(10)
                    }
                }
            }
                
                
            Spacer()
                
            HStack(spacing:10){
                
                if !isCreate {
                    Button("Supprimer"){
                        intent.intentToDeleteUser()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                    
                    Button(nomButton){
                        if nomButton == "Modifier" {
                            nomButton = "Valider"
                        }
                        else{
                            nomButton = "Modifier"
                            print("go udapte")
                            intent.intentToUpdateDatabase()
                        }
                    }.disabled(nomButton == "Valider" && !utilisateurViewModel.isValid)
                    
                    if !disabledTextField {
                        Button("Annuler"){
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
        
            
        }.navigationTitle("Détail \(utilisateurViewModel.nom)")
            .padding()
            .onChange(of: utilisateurViewModel.result){
                result in
                print("result : \(result)")
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
                    utilisateurViewModel.result = .failure(.noError)
                }
            }.onAppear(){
                self.utilisateurViewModel.addObserverResult()
            }.onDisappear(){
                self.utilisateurViewModel.removeObserverResult()
                print("je disapear")
            }
        
    }
}
