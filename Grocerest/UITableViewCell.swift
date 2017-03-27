//
//  extension UITableViewCell.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 14/06/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

public extension UITableViewCell
{
    func addSeparator(_ y: CGFloat, margin: CGFloat, color: UIColor)
    {
        let sepFrame = CGRect(x: margin, y: y, width: self.frame.width - margin, height: 0.7);
        let seperatorView = UIView(frame: sepFrame);
        seperatorView.backgroundColor = color;
        self.addSubview(seperatorView);
    }
    
    public func addTopSeparator(_ tableView: UITableView)
    {
        let margin = tableView.separatorInset.left;
        
        self.addSeparator(0, margin: margin, color: tableView.separatorColor!);
    }
    
    public func addBottomSeparator(_ tableView: UITableView, cellHeight: CGFloat)
    {
        let margin = tableView.separatorInset.left;
        
        self.addSeparator(cellHeight-2, margin: margin, color: tableView.separatorColor!);
    }
    
    public func removeSeparator(_ width: CGFloat)
    {
        self.separatorInset = UIEdgeInsetsMake(0.0, width, 0.0, 0.0);
    }
    
    func removeMargins() {
        
        if self.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            self.separatorInset = UIEdgeInsets.zero
        }
        
        if self.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)) {
            self.preservesSuperviewLayoutMargins = false
        }
        
        if self.responds(to: #selector(setter: UIView.layoutMargins)) {
            self.layoutMargins = UIEdgeInsets.zero
        }
    }
    
    
}
