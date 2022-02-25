//
//  GestionCompte.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 25/02/2022.
//

import Foundation
import SwiftUI

struct GestionCompteView : View {
    
    @StateObject var user : UtilisateurService = UtilisateurService.instance
    
    var body : some View{
        VStack{
            
        NavigationLink(destination:UtilisateurDetailView(model:user.currentUtilisateur)){
            Text("Mon compte")
        }
            
        Button("Déconnexion"){
            user.deconnexion()
            
        }
            
        }
    }
}
