//
//  GRShoppingListMenuViewController.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 09/06/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import UIKit


struct MenuActions{
    static let Manage = "Gestisci lista"
    static let Reset = "Resetta lista"
    static let Duplicate = "Duplica lista"
    static let Delete = "Elimina lista"
    static let Info = "Info Lista"
    static let Abandon = "Abbandona lista"
}


// This are index dependent reorder will afect other behaviors
enum ActionsOwner{
    case manage 
    case reset
    case duplicate
    case delete
}

enum ActionsCollaborator{
    case info
    case duplicate
    case abandon
}



class GRShoppingListMenuViewController: UIViewController {
    
    var owner : Bool = false
    
    var tapGesture = UITapGestureRecognizer()
    var tableView = UITableView()
    
    var dataSource:[String] = []
    
    var shoppingList : JSON?
    
    var dataDelegate = GRShoppingListViewController()

    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startSlideViewAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    fileprivate var managedView: GRShoppingListMenuView {
        return self.view as! GRShoppingListMenuView
    }
    
    override func loadView() {
        super.loadView()
        view = GRShoppingListMenuView()
        managedView.delegate = self
    }
    
    func setupViews() {
        

        
        
        tableView = UITableView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.register(GRShoppingListMenuTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 150 / masterRatio
        tableView.tableFooterView = UIView()
        
        
        
        self.managedView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.height.equalTo(4 * 150 / masterRatio)
            make.left.equalTo(0)
            make.width.equalTo(self.managedView.snp.width)
            make.top.equalTo(900)
        }
        
        let tapView = UIView()
        self.managedView.addSubview(tapView)
        tapView.snp.makeConstraints { (make) in
            make.width.equalTo(self.managedView.snp.width)
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(tableView.snp.top)
        }
        
        tapView.addGestureRecognizer(tapGesture)
        tapGesture.numberOfTapsRequired = 1
        tapGesture.addTarget(self, action: #selector(GRShoppingListMenuViewController.tapped(_:)))
        
        self.view.bringSubview(toFront: tableView)
        setDataSource()
        
        
    }
    
    func tapped(_ sender:UITapGestureRecognizer) {
        
        removeSlideViewAnimation()
    }
    
    func setDataSource(){
        
        if owner {
            self.dataSource = [MenuActions.Manage, MenuActions.Reset, MenuActions.Duplicate, MenuActions.Delete]
            tableView.snp.remakeConstraints { (make) in
                make.height.equalTo(CGFloat(self.dataSource.count) * 150 / masterRatio)
                make.left.equalTo(0)
                make.width.equalTo(self.managedView.snp.width)
                make.bottom.equalTo(600 / masterRatio)
            }
        } else {
            self.dataSource = [MenuActions.Info, MenuActions.Duplicate, MenuActions.Abandon]
            tableView.snp.remakeConstraints { (make) in
                make.height.equalTo(CGFloat(self.dataSource.count) * 150 / masterRatio)
                make.left.equalTo(0)
                make.width.equalTo(self.managedView.snp.width)
                make.bottom.equalTo(450 / masterRatio)
            }
        }
        
        self.tableView.reloadData()
        
    }
    
    
    func startSlideViewAnimation () {
        
        var transitionDistance: CGFloat {
            if owner {
                return -600.00
            } else {
                return -450.00
            }
        }
        
        self.managedView.backView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        
        UIView.animate(withDuration: 0.30, delay: 0, options: .curveEaseOut, animations: {
            self.managedView.backView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            self.tableView.transform = CGAffineTransform(translationX: 0, y: transitionDistance / masterRatio)
        }, completion: nil)
        
    }
    
    
    func removeSlideViewAnimation () {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
           self.managedView.backView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.tableView.transform = CGAffineTransform(translationX: 0, y: 0 / masterRatio)
        }) { (done:Bool) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    

    
}
