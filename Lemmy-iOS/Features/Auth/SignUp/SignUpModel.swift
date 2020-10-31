//
//  SignUpModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/15/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import AVFoundation

class SignUpModel {

    var wavDataFile: Data?
    var uuid: String?

    var player: AVAudioPlayer?

    func getCaptcha(completion: @escaping ((Result<(UIImage), Error>) -> Void)) {
        ApiManager.requests
            .getCaptcha { (result: Result<LemmyApiStructs.Authentication.GetCaptchaResponse, LemmyGenericError>) in
            switch result {
            case let .success(response):
                if let wavString = response.ok?.wav {
                    if let wavData = Data(base64Encoded: wavString) {
                        self.wavDataFile = wavData
                    }
                }

                self.uuid = response.ok?.uuid

                if let image = response.ok?.png.base64ToImage() {
                    completion(.success(image))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func playWavSound() {
        guard let wavData = wavDataFile else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(data: wavData, fileTypeHint: AVFileType.wav.rawValue)

            guard let player = player else { return }

            player.play()

        } catch {
            print(error.localizedDescription)
        }
    }
}
