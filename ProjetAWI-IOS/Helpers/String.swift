//
//  String.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 23/02/2022.
//

extension String
{
    func replaceComa() -> String
    {
        return self.replacingOccurrences(of: ".", with: ",", options: String.CompareOptions.literal, range: nil)
    }
}
