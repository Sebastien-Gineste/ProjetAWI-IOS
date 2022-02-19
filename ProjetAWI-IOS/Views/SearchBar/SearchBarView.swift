//
//  SearchBar.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 19/02/2022.
//

import Foundation
import SwiftUI


struct SearchBarView : View{
    
    @State var searchText = ""
    
    init(_ search : String){ // je sais pas 
        self.searchText = search
    }

    var body : some View{
        HStack {
           TextField("Enter Search Text", text: $searchText)
               .padding(.horizontal, 40)
               .frame(width: UIScreen.main.bounds.width - 110, height: 45, alignment: .leading)
               .background(Color(#colorLiteral(red: 0.9294475317, green: 0.9239223003, blue: 0.9336946607, alpha: 1)))
               .clipped()
               .cornerRadius(10)
               .overlay(
                   HStack {
                       Image(systemName: "magnifyingglass")
                           .foregroundColor(.gray)
                           .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                           .padding(.leading, 16)
                   }
               )
           Spacer()
       }.padding().padding(.top, 30)
    }
    
}
