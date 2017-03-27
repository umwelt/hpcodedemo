//
//  GRBrandDetailProductsListDataSource.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 07/02/2017.
//  Copyright © 2017 grocerest. All rights reserved.
//

import Foundation

class GRBrandDetailProductsListDataSource: NSObject, UITableViewDataSource {
    
    var cells: [GRProductsResultTableViewCell] = [GRProductsResultTableViewCell]()
    
    override init() {
        super.init()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
    
}
