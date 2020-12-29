//
//  ViewController.swift
//  News
//
//  Created by Vladimir Stepanchikov on 05.04.2020.
//  Copyright © 2020 Vladimir Stepanchikov. All rights reserved.
//

import Cocoa

class MyCell: NSTableCellView {
    @IBOutlet weak var labelText: NSTextField!
    
}

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var labelError: NSTextField!
    
    @IBOutlet weak var searchField: NSSearchField!
    @IBAction func searchFieldAction(_ sender: Any) {
        indicatorDownload.startAnimation(self)
        loadNews(with: searchField.stringValue)
    }
    
    @IBOutlet weak var indicatorDownload: NSProgressIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.doubleAction = #selector(doubleClick)
        
        let menu = NSMenu(title: "menu")
        let menuItem1 = NSMenuItem(title: "Open news", action: #selector(doubleClick), keyEquivalent: "")
        let menuItem2 = NSMenuItem(title: "Open in Safari", action: #selector(safariClick) , keyEquivalent: "")
        
        menu.addItem(menuItem1)
        menu.addItem(menuItem2)
        
        tableView.menu = menu
        
        NotificationCenter.default.addObserver(forName: nDownloadCompleted, object: nil, queue: OperationQueue.main) { (Notification) in
            self.indicatorDownload.stopAnimation(self)
            self.labelError.stringValue = ""
            self.tableView.reloadData()
        }
        
        NotificationCenter.default.addObserver(forName: nDownloadWithError, object: nil, queue: OperationQueue.main) { (Notification) in
            self.indicatorDownload.stopAnimation(self)
            guard let error = Notification.userInfo?["error"] as? String else {
                return
            }
            self.labelError.stringValue = error
        }
        
        indicatorDownload.startAnimation(self)
        loadNews(with: "")
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier:NSUserInterfaceItemIdentifier("Cell"), owner: self) as? MyCell else {
            return nil
        }
        
        let newsInCell = news[row]
        
        switch tableColumn?.identifier {
        case NSUserInterfaceItemIdentifier("ColumnAuthor"):
            cell.labelText.stringValue = newsInCell.author
        case NSUserInterfaceItemIdentifier("ColumnTitle"):
            cell.labelText.stringValue = newsInCell.title
        case NSUserInterfaceItemIdentifier("ColumnSource"):
            cell.labelText.stringValue = newsInCell.sourceName
        default:
            return nil
        }
        return cell
    }
    
    @objc
    func doubleClick() {
        if tableView.clickedRow == -1 {
            return
        }
        guard let oneNewsVC = storyboard?.instantiateController(withIdentifier: "oneNewsSID") as? OneNewsController else {
            return
        }
        oneNewsVC.newsInController = news[tableView.clickedRow]
        presentAsModalWindow(oneNewsVC)
    }
    
    @objc func safariClick() {
        if tableView.clickedRow == -1 {
            return
        }
        
        guard let url = URL(string: news[tableView.clickedRow].url) else {
            return
        }
        NSWorkspace.shared.open(url)
    }
}

