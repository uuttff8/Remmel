//
//  LMModels+Others.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

typealias LMMUserOperation = RMModels.Others.UserOperation

extension RMModels {
    enum Others {
        
        enum UserOperation: String {
            case
                Login,
                Register,
                GetCaptcha,
                CreateCommunity,
                CreatePost,
                ListCommunities,
                ListCategories,
                GetPost,
                GetCommunity,
                CreateComment,
                EditComment,
                DeleteComment,
                RemoveComment,
                MarkCommentAsRead,
                SaveComment,
                CreateCommentLike,
                GetPosts,
                CreatePostLike,
                EditPost,
                DeletePost,
                RemovePost,
                LockPost,
                StickyPost,
                SavePost,
                EditCommunity,
                DeleteCommunity,
                RemoveCommunity,
                FollowCommunity,
                GetFollowedCommunities,
                GetPersonDetails,
                GetReplies,
                GetPersonMentions,
                MarkPersonMentionAsRead,
                GetModlog,
                BanFromCommunity,
                AddModToCommunity,
                CreateSite,
                EditSite,
                GetSite,
                AddAdmin,
                BanPerson,
                Search,
                MarkAllAsRead,
                SaveUserSettings,
                TransferCommunity,
                TransferSite,
                DeleteAccount,
                PasswordReset,
                PasswordChange,
                CreatePrivateMessage,
                EditPrivateMessage,
                DeletePrivateMessage,
                MarkPrivateMessageAsRead,
                GetPrivateMessages,
                UserJoin,
                GetComments,
                GetSiteConfig,
                SaveSiteConfig,
                PostJoin,
                CommunityJoin,
                ChangePassword
        }
        
        enum SortType: String, Codable, CaseIterable, LemmyTypePickable {
            case active = "Active"
            case hot = "Hot"
            case new = "New"
            case topDay = "TopDay"
            case topWeek = "TopWeek"
            case topMonth = "TopMonth"
            case topYear = "TopYear"
            case topAll = "TopAll"
            case mostComments = "MostComments"
            case newComments = "NewComments"
            
            var label: String {
                switch self {
                case .active: return "sort-active".localized
                case .hot: return "sort-hot".localized
                case .new: return "sort-new".localized
                case .topDay: return "sort-day".localized
                case .topWeek: return "sort-week".localized
                case .topMonth: return "sort-month".localized
                case .topYear: return "sort-year".localized
                case .topAll: return "sort-all".localized
                case .mostComments: return "sort-most-comments".localized
                case .newComments: return "sort-new-comments".localized
                }
            }
            
            var index: Int {
                switch self {
                case .active: return 0
                case .hot: return 1
                case .new: return 2
                case .topDay: return 3
                case .topWeek: return 4
                case .topMonth: return 5
                case .topYear: return 6
                case .topAll: return 7
                case .mostComments: return 8
                case .newComments: return 9
                }
            }
            
            init?(fromStr: String) {
                switch fromStr {
                case "Active": self = .active
                case "Hot": self = .hot
                case "New": self = .new
                case "TopDay": self = .topDay
                case "TopWeek": self = .topWeek
                case "TopMonth": self = .topMonth
                case "TopYear": self = .topYear
                case "TopAll": self = .topAll
                case "MostComments": self = .mostComments
                case "NewComments": self = .newComments
                default:
                    return nil
                }
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                let rawValueInt = try? container.decode(Int.self)
                let rawValueString = try? container.decode(String.self)
                
                switch (rawValueInt, rawValueString) {
                case (0, nil): self = .active
                case (nil, "Active"): self = .active
                case (1, nil): self = .hot
                case (nil, "Hot"): self = .hot
                case (2, nil): self = .new
                case (nil, "New"): self = .new
                case (3, nil): self = .topDay
                case (nil, "TopDay"): self = .topDay
                case (4, nil): self = .topWeek
                case (nil, "TopWeek"): self = .topWeek
                case (5, nil): self = .topMonth
                case (nil, "TopMonth"): self = .topMonth
                case (6, nil): self = .topYear
                case (nil, "TopYear"): self = .topYear
                case (7, nil): self = .topAll
                case (nil, "TopAll"): self = .topAll
                case (8, nil): self = .mostComments
                case (nil, "MostComments"): self = .mostComments
                case (9, nil): self = .newComments
                case (nil, "NewComments"): self = .newComments
                default:
                    throw CodingError.unknownValue
                }
            }
            
            enum CodingError: Error {
                case unknownValue
            }
            
            func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                switch self {
                case .active: try container.encode("Active")
                case .hot: try container.encode("Hot")
                case .new: try container.encode("New")
                case .topDay: try container.encode("TopDay")
                case .topWeek: try container.encode("TopWeek")
                case .topMonth: try container.encode("TopMonth")
                case .topYear: try container.encode("TopYear")
                case .topAll: try container.encode("TopAll")
                case .mostComments: try container.encode("MostComments")
                case .newComments: try container.encode("NewComments")
                }
            }
        }
        
        enum ListingType: String, Codable, LemmyTypePickable {
            case all = "All"
            case local = "Local"
            case subscribed = "Subscribed"
            case community = "Community"
            
            var label: String {
                switch self {
                case .all: return "listing-all".localized
                case .local: return "listing-local".localized
                case .subscribed: return "listing-subscribed".localized
                case .community: return "listing-community".localized
                }
            }
            
            var index: Int {
                switch self {
                case .all: return 0
                case .local: return 1
                case .subscribed: return 2
                case .community: return 3
                }
            }
            
            init?(fromStr: String) {
                switch fromStr {
                case "All": self = .all
                case "Local": self = .local
                case "Subscribed": self = .subscribed
                case "Community": self = .community
                default:
                    return nil
                }
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                let rawValueInt = try? container.decode(Int.self)
                let rawValueString = try? container.decode(String.self)
                
                switch (rawValueInt, rawValueString) {
                case (0, nil): self = .all
                case (nil, "All"): self = .all
                case (1, nil): self = .local
                case (nil, "Local"): self = .local
                case (2, nil): self = .subscribed
                case (nil, "Subscribed"): self = .subscribed
                case (3, nil): self = .community
                case (nil, "Community"): self = .community
                default:
                    throw CodingError.unknownValue
                }
            }
            
            func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                switch self {
                case .all: try container.encode("All")
                case .local: try container.encode("Local")
                case .subscribed: try container.encode("Subscribed")
                case .community: try container.encode("Community")
                }
            }
            
            enum CodingError: Error {
                case unknownValue
            }
        }
        
        enum SearchType: String, CaseIterable, Codable {
            case all = "All"
            case comments = "Comments"
            case posts = "Posts"
            case communities = "Communities"
            case users = "Users"
            case url = "Url"
            
            var label: String {
                switch self {
                case .all: return "searchtype-all".localized
                case .comments: return "searchtype-comments".localized
                case .posts: return "searchtype-posts".localized
                case .communities: return "searchtype-communities".localized
                case .users: return "searchtype-users".localized
                case .url: return "searchtype-url".localized
                }
            }
        }
        
        /**
        * A websocket response. Includes the return type.
        * Can be used like:
        *
        * ```ts
        * if (op == UserOperation.Search) {
        *   let data = wsJsonToRes<SearchResponse>(msg).data;
        * }
        * ```
        */
        struct WebSocketResponse<ResponseType: Codable> {
            let op: String
            /**
            * This contains the data for a websocket response.
            *
            * The correct response type if given is in [[LemmyHttp]].
            */
            let data: ResponseType
        }
        
        /**
        * A websocket JSON response that includes the errors.
        */
        struct WebSocketJsonResponse<ResponseType: Codable> {
            let op: String?
            /**
            * This contains the data for a websocket response.
            *
            * The correct response type if given is in [[LemmyHttp]].
            */
            let data: ResponseType?
            let error: String?
            let reconnect: Bool?
        }
        
        /**
        * A holder for a site's metadata ( such as opengraph tags ), used for post links.
        */
        struct SiteMetadata: Codable {
            let title: String?
            let description: String?
            let image: String?
            let html: String?
       }
    }
}
