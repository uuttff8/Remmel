//
//  RegisterViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/15/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import AVFoundation
import Combine

class RegisterViewModel {

    var wavDataFile: Data?
    var uuid: String?

    var player: AVAudioPlayer?
    
    private var cancellables = Set<AnyCancellable>()
    
    func getCaptcha(completion: @escaping ((Result<(UIImage), Error>) -> Void)) {
        ApiManager.requests.asyncGetCaptcha()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (combineCompletion) in
                if case let .failure(error) = combineCompletion {
                    completion(.failure(error))
                }
                
                Logger.logCombineCompletion(combineCompletion)
            }, receiveValue: { (response) in
                
                if let wavString = response.ok?.wav {
                    if let wavData = Data(base64Encoded: wavString) {
                        self.wavDataFile = wavData
                    }
                }

                self.uuid = response.ok?.uuid

                if let image = response.ok?.png.base64ToImage() {
                    completion(.success(image))
                }
                
            }).store(in: &cancellables)
        
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
            Logger.commonLog.error("Error while playing audio: \(error)")
        }
    }
}
