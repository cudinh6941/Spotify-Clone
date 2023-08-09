//
//  SettingsModels.swift
//  LuyenVoCong
//
//  Created by Dinh Pham Kha on 09/08/2023.
//

import Foundation

struct Section{
    let title : String
    let options : [Option]
}

struct Option{
    let title : String
    let handler : () -> Void
}
