//
//  MainView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 17/02/2022.
//

import SwiftUI

struct FicheTechniqueListView: View {
    
    @ObservedObject var ficheTechniqueListViewModel : FicheTechniqueListViewModel
    @ObservedObject var categorieRecetteViewModel : CategorieRecetteViewModel
    
    @State var alertMessage = ""
    @State var showingAlert : Bool = false
    @State private var searchText : String = ""
    @State private var selectedIndex : Int = 0
    
    let columns : [GridItem] = [GridItem(.flexible()),GridItem(.flexible())]
    var intent: FicheTechniqueIntent
    
    var ficheTechniqueFiltre : [FicheTechnique] {
        if searchText.isEmpty &&  selectedIndex <= 0 {
            return ficheTechniqueListViewModel.tabFicheTechnique
        } else {
            if selectedIndex <= 0 {
                return ficheTechniqueListViewModel.tabFicheTechnique.filter{ $0.header.nomPlat.uppercased().contains(searchText.uppercased()) }
            }else if searchText.isEmpty {
                return ficheTechniqueListViewModel.tabFicheTechnique.filter{ $0.header.categorie.uppercased().contains(categorieRecetteViewModel.tabCategorieRecette[selectedIndex].uppercased())}
            } else {
                return ficheTechniqueListViewModel.tabFicheTechnique.filter{
                    $0.header.nomPlat.uppercased().contains(searchText.uppercased()) &&
                    $0.header.categorie.uppercased().contains(categorieRecetteViewModel.tabCategorieRecette[selectedIndex].uppercased())
                }
            }
        }
    }
    
    init(vm : FicheTechniqueListViewModel, vmCategorie : CategorieRecetteViewModel){
        self.ficheTechniqueListViewModel = vm
        self.categorieRecetteViewModel = vmCategorie
        self.intent = FicheTechniqueIntent()
        // add Observer intent
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Picker(selection: $selectedIndex, label: Text("Categorie")) {
                        ForEach(Array(self.categorieRecetteViewModel.tabCategorieRecette.enumerated()), id: \.offset) { index,categorie in
                            Text(categorie)
                        }
                    }
                }.frame(height:100)
                
                List {
                    ForEach(Array(ficheTechniqueFiltre.enumerated()), id : \.offset) {
                        index, fiche in
                        HStack {
                            // navigationLink
                            VStack(alignment: .leading){
                                Text(fiche.header.nomPlat).bold()
                                HStack {
                                    Text(fiche.header.nomAuteur).italic()
                                    Text(" (\(fiche.header.nbrCouvert) couverts - ")
                                    Text("\(String(format: "%.2f",fiche.header.coutProduction).replaceComa())€ )")
                                }
                            }
                        }
                    }.onDelete{
                        IndexSet in
                        for index in IndexSet {
                            intent.intentToDeleteFicheTechnique(id: index)
                        }
                    }
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
                .navigationBarTitle(Text("Liste des fiche techniques"), displayMode: .inline)
                HStack{
                    LazyVGrid(columns: columns){
                        EditButton()
                        // navigationLink ajout
                        Button("Ajout"){}
                    }
                }.padding()
            }
            .onChange(of: ficheTechniqueListViewModel.result){
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
                    ficheTechniqueListViewModel.result = .failure(.noError)
                }
            }
        }
    }
}
