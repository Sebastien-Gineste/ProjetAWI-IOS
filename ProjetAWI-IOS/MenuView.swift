//
//  MenuView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 17/02/2022.
//

import SwiftUI

struct MenuView: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "person")
                    .foregroundColor(.white)
                    .imageScale(.large)
                Text("Profile")
                    .foregroundColor(.white)
                    .font(.headline)
                    
            
            
            } .padding(.top, 100)
        Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 76/255, green: 175/255, blue: 80/255))
        .edgesIgnoringSafeArea(.all)
    }
}
