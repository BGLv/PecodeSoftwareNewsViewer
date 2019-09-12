//
//  Source.swift
//  PecodeSoftwareNewsViewer
//
//  Created by Bogdan Lviv on 9/12/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

import Foundation

struct Source{
    let id:String?
    let name:String?
    
    init(byId id:String?, byName name:String){
        self.id = id
        self.name = name
    }
}
