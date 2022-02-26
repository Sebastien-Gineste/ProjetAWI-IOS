//
//  UtilisateurListView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 19/02/2022.
//

import Foundation
import SwiftUI


struct UtilisateurListView : View {
    
    @ObservedObject var utilisateurListViewModel : UtilisateurListViewModel
    @State private var searchText : String = ""
    @State var showingAlert : Bool = false
    @State var alertMessage = ""
    @State var isActiveCreateView = false
    
    private var intent : UtilisateurIntent
    
    
    var utilisateursFiltre: [Utilisateur] {
        if searchText.isEmpty {
            return utilisateurListViewModel.utilisateurs
        } else {
            return utilisateurListViewModel.utilisateurs.filter{ $0.nom.uppercased().contains(searchText.uppercased()) || $0.prenom.uppercased().contains(searchText.uppercased()) }
        }
    }
    
    init(vm : UtilisateurListViewModel){
        self.utilisateurListViewModel = vm
        self.intent = UtilisateurIntent()
        self.intent.addObserver(vm)
    }
    
    var body : some View {
        NavigationView{
            VStack{
                
                GestionCompteView()
                
                    List {
                        HStack(spacing:0){
                            Text("Nom").frame(maxWidth:.infinity)
                            Text("Prénom").bold().frame(maxWidth:.infinity)
                            Text("Type").italic().frame(maxWidth:.infinity)
                        }.frame(minWidth : 0, maxWidth: .infinity)
                        
                        ForEach(Array(utilisateursFiltre.enumerated()), id: \.offset){index,utilisateur in
                            HStack(spacing:0){
                                Text(utilisateur.nom).frame(maxWidth:.infinity)
                                Text("\(utilisateur.prenom)").bold().frame(maxWidth:.infinity)
                                Text("\(utilisateur.type.rawValue)").italic().frame(maxWidth:.infinity)
                                
                                NavigationLink(destination:UtilisateurDetailView(model:utilisateur)){
                                }.frame(maxWidth:0)
                            }.frame(minWidth : 0, maxWidth: .infinity)
                        }.onDelete{indexSet in
                            for index in indexSet {
                                intent.intentToDeleteUserFromList(id: index)
                            }
                        }
                    }
                    .searchable(text: $searchText,placement:.navigationBarDrawer(displayMode:.always))
                    .navigationTitle("Liste des utilisateurs")
                    
                    HStack(spacing : 20){
                        EditButton()
                        NavigationLink(destination:UtilisateurCreateUpdateView(), isActive: $isActiveCreateView){
                            Text("Créer un compte")
                        }
                    }
            }
            .onChange(of: utilisateurListViewModel.result){
                result in
                switch result {
                case let .success(msg):
                    self.alertMessage = msg
                    self.showingAlert = true
                case let .failure(error):
                    switch error {
                    case .noError :
                        return
                    case .deleteError:
                        self.alertMessage = "\(error)"
                        self.showingAlert = true
                    }
                }
            }
            .alert("\(alertMessage)", isPresented: $showingAlert){
                Button("OK", role: .cancel){
                    if (alertMessage == "Création effectué"){

                        self.isActiveCreateView = false
                    }
                    utilisateurListViewModel.result = .failure(.noError)
                }
            }
        }
    }
    
}
