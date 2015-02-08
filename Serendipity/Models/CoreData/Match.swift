//
//  Match.swift
//  Serendipity
//
//  Created by Tony Xiao on 2/7/15.
//  Copyright (c) 2015 Serendipity. All rights reserved.
//

@objc(Match)
class Match: _Match {

    class func findByDocumentID(documentID: String) -> Match? {
        return Core.mainContext.objectInCollection("matches", documentID: documentID) as? Match
    }

}
