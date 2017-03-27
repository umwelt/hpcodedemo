//
//  GRShoppingListMenuViewController+UITableViewDataSource.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 13/06/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import UIKit


extension GRShoppingListMenuViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: GRShoppingListMenuTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GRShoppingListMenuTableViewCell
        
        cell.removeMargins()
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.lightGrayTextcolor().withAlphaComponent(0.03)
        cell.selectedBackgroundView = bgColorView
        
        
        let row = indexPath.row
        
        if (cell == nil) {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GRShoppingListMenuTableViewCell
        }
        
        let title = self.dataSource[row] as! String
        
        cell.setTextForLabel(title)
        
        if title == MenuActions.Abandon {
            cell.setImageForCell("abandona_lista")
        } else if title == MenuActions.Delete {
            cell.setImageForCell("elimina_lista")
        } else if title == MenuActions.Duplicate {
            cell.setImageForCell("duplica_lista")
        } else if title == MenuActions.Info {
            cell.setImageForCell("info_lista")
        } else if title == MenuActions.Manage {
            cell.setImageForCell("gestisci_lista")
        } else if title == MenuActions.Reset {
            cell.setImageForCell("resetta_lista")
        }
        
        return cell
    }
    
}
