//
//  GRProductDetailReviewsListDataSource.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 04/07/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation

class GRProductDetailReviewsListDataSource: NSObject, UITableViewDataSource {
    
    var cells: [GRReviewTableViewCell] = [GRReviewTableViewCell]()
    
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
