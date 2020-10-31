//
//  LemmyApiStructs+Auth.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

extension LemmyApiStructs {
    enum Authentication {

        // MARK: - Login -
        struct LoginRequest: Codable, Equatable {
            let usernameOrEmail: String
            let password: String

            enum CodingKeys: String, CodingKey {
                case usernameOrEmail = "username_or_email"
                case password
            }
        }

        struct LoginResponse: Codable, Equatable {
            let jwt: String
        }

        // MARK: - Register -
        struct RegisterRequest: Codable, Equatable {
            let username: String
            let email: String?
            let password: String
            let passwordVerify: String
            let admin: Bool
            let showNsfw: Bool
            let captchaUuid: String?
            let captchaAnswer: String?

            enum CodingKeys: String, CodingKey {
                case username, email
                case password
                case passwordVerify = "password_verify"
                case admin
                case showNsfw = "show_nsfw"
                case captchaUuid = "captcha_uuid"
                case captchaAnswer = "captcha_answer"
            }
        }

        struct RegisterResponse: Codable, Equatable {
            let jwt: String
        }

        // MARK: - GetCaptcha -
        struct GetCaptchaRequest: Codable, Equatable {  }

        // Will be undefined if captchas are disabled
        struct GetCaptchaResponse: Codable, Equatable {
            let ok: GetCaptchaResponseOk?
        }

        struct GetCaptchaResponseOk: Codable, Equatable {
            let png: String // A Base64 encoded png
            let wav: String? //  A Base64 encoded wav audio file
            let uuid: String
        }
    }
}
