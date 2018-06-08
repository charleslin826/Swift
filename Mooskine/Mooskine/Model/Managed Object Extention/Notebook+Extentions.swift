//
//  Notebook+Extentions.swift
//  Mooskine
//
//  Created by user on 2018/5/17.
//  Copyright © 2018年 Udacity. All rights reserved.
//

import Foundation
import CoreData

extension Notebook {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
