//
//  VoteGettable.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

//import Foundation
//import RMModels
//
//protocol VoteGettable {
//    
//    var id: Int { get }
//    
//    var myVote: Int? { get }
//    
//    var post: RMModels.Source.Post { get }
//    
//    // optional
//    func getVoteType() -> LemmyVoteType
//    func getApIdRelatedToPost() -> String
//}
//
//extension VoteGettable {
//    func getVoteType() -> LemmyVoteType {
//        guard let myVote = self.myVote, myVote != 0 else {
//            return .none
//        }
//        return myVote == 1 ? .up : .down
//    }
//    
//    func getApIdRelatedToPost() -> String {
//        return "https://lemmy.ml/post/\(self.post.id)/comment/\(self.id)"
//    }
//}
