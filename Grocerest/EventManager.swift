//
//  EventManager.swift
//  Grocerest
//
//  Created by Davide Bertola on 16/03/2017.
//  Copyright © 2017 grocerest. All rights reserved.
//

import Foundation
import React


@objc(EventManager) class EventManager: RCTEventEmitter {
    
    static var instance:EventManager? = nil
    public var nc = NotificationCenter.default
    var supportedEventsList:[String] = []
    
    override init() {
        super.init()
        print("EventManager.init()")
        // this is a singleton, an every time the javascript
        // side initializes, we overwrite that instance
        EventManager.instance = self
    }
    
    // js events this module can trigger using sendEvent()
    override func supportedEvents() -> [String]! {
        print("EventManager.supportedEvents()")
        return supportedEventsList
    }
    
    // add event name to the list of supported events
    @objc(supportedEventsAdd:) func supportedEventsAdd(event: String) {
        print("EventManager.supportedEventsAdd('\(event)')")
        if (!supportedEventsList.contains(event)) {
            supportedEventsList.append(event)
        }
    }
    
    
    // triggers/fires/emits both
    // - a notification center notification
    // - a javascript event
    @objc(emit:data:) func emit(
        _ event: String!,
        data: [NSObject:AnyObject]
    )
        -> Void
    {
        print("EventManager.emit(\(event!), ...)")
        
        nc.post(
            name: Notification.Name(event!),
            object: self,
            userInfo: data
        )
        
        self.supportedEventsAdd(event:event)
        
        self.sendEvent(withName: event, body: data)
    }

    
    
    // Just an example of a complete callable method
    /*
    @objc(call:callback:) func call(
        _ data: [NSObject:AnyObject],
        callback: RCTResponseSenderBlock
        )
        -> Void
    {
        print("\(data.description)")
        
        let resultsDict = ["success" : true]
        
        sendEvent(withName: "event", body: ["sample": "data"])
        
        callback([NSNull() ,resultsDict])
    }
    */
}
