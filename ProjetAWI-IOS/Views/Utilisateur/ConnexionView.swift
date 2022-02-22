//
//  Connexion.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 22/02/2022.
//

import Foundation
import SwiftUI

struct ConnexionView : View{
    
    @State var email : String = ""
    @State var motDePasse : String = "" 
    
    
    var body: some View{
        
        VStack(alignment:.center){
            Spacer()
            Text("E-mail : ")
            TextField("",text: $email).background(Color.pink).autocapitalization(.none)
            Text("Mot de passe :")
            SecureField("", text: $motDePasse).background(Color.pink).autocapitalization(.none)
            
            Button("Connexion"){
                UtilisateurService.instance.connexion(email: email, mdp: motDePasse)
            }
            Spacer()
        }.padding()
        
    }
    
}
