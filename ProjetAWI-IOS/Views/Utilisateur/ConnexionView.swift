//
//  Connexion.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 22/02/2022.
//@

import Foundation
import SwiftUI

struct ConnexionView : View{
    
    @State var email : String = ""
    @State var motDePasse : String = "" 
    
    
    var body: some View{
        
        VStack(alignment:.center){
            Spacer()
            Text("E-mail : ")
            TextField("test@gmail.com",text: $email).background(Color.pink).autocapitalization(.none).padding(10)
            Text("Mot de passe :")
            SecureField("Mot de passe", text: $motDePasse).background(Color.pink).autocapitalization(.none).padding(10)
            
            Button("Connexion"){
                UtilisateurService.instance.connexion(email: email, mdp: motDePasse)
            }.padding(10)
                .disabled(!email.isValidEmail() || !motDePasse.isValidPassword())
            Spacer()
        }.padding()
        
    }
    
}
