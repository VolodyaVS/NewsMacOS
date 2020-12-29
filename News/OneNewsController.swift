//
//  OneNewsController.swift
//  News
//
//  Created by Vladimir Stepanchikov on 12.04.2020.
//  Copyright © 2020 Vladimir Stepanchikov. All rights reserved.
//

import Cocoa

class OneNewsController: NSViewController {
    
    var newsInController: OneNews!
    
    @IBOutlet weak var image: NSImageView!
    @IBOutlet weak var labelTitle: NSTextField!
    @IBOutlet weak var labelAuthor: NSTextField!
    @IBOutlet weak var labelSource: NSTextField!
    @IBOutlet weak var labelDescriction: NSTextField!
    @IBOutlet weak var labelContent: NSTextField!
    @IBOutlet weak var labelUrlNews: UrlLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let urlImage = URL(string: newsInController.urlToImage) {
            image.image = NSImage(contentsOf: urlImage)
        }
        labelTitle.stringValue = newsInController.title
        labelAuthor.stringValue = newsInController.author
        labelSource.stringValue = newsInController.sourceName
        labelDescriction.stringValue = newsInController.description
        labelContent.stringValue = newsInController.content
        labelUrlNews.stringValue = newsInController.url
        
        let gr = NSClickGestureRecognizer(target: self, action: #selector(clickOnURL))
        labelUrlNews.addGestureRecognizer(gr)
    }
    
    @objc
    func clickOnURL() {
        guard let url = URL(string: newsInController.url) else {
            return
        }
        NSWorkspace.shared.open(url)
    }
}

class UrlLabel: NSTextField {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addTrackingRect(self.bounds, owner: self, userData: nil, assumeInside: false)
        
    }
   
    override func mouseEntered(with event: NSEvent) {
        self.textColor = NSColor.blue
        let cursor = NSCursor.openHand
        cursor.set()
    }
    
    override func mouseExited(with event: NSEvent) {
        self.textColor = NSColor.labelColor
        let cursor = NSCursor.arrow
        cursor.set()
    }
    

}
