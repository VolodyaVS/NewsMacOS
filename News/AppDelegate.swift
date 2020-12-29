//
//  AppDelegate.swift
//  News
//
//  Created by Vladimir Stepanchikov on 05.04.2020.
//  Copyright © 2020 Vladimir Stepanchikov. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print(urlToJson)
        loadNews(with: "today")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

