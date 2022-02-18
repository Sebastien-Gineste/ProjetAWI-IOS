//
//  Theme.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 18/02/2022.
//

import Foundation
import SwiftUI

struct Theme {
    static func loadNavigationBarTitleStyle(){
        UINavigationBar.appearance().backgroundColor = .white
        if #available(iOS 13, *) {
          let appearance = UINavigationBarAppearance()
          // title color
          appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
          // large title color
          appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
          // background color
            appearance.backgroundColor = .specialGreen
          // bar button styling
          let barButtonItemApperance = UIBarButtonItemAppearance()
          barButtonItemApperance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
          appearance.backButtonAppearance = barButtonItemApperance
          // set the navigation bar appearance to the color we have set above
          UINavigationBar.appearance().standardAppearance = appearance
          // when the navigation bar has a neighbouring scroll view item (eg: scroll view, table view etc)
          UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        // the back icon color
        UINavigationBar.appearance().tintColor = .white
    }
}
