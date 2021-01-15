//
//  VoteGettable.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

protocol VoteGettable {
    
    var myVote: Int? { get }
    
    // optional
    func getVoteType() -> LemmyVoteType
}

extension VoteGettable {
    func getVoteType() -> LemmyVoteType {
        guard let myVote = self.myVote, myVote != 0 else { return LemmyVoteType.none }
        return myVote == 1 ? .up : .down
    }
}
