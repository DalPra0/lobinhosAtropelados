//
//  SharedUserDefaults.swift
//  lobinhosAtropeladosProject
//
//  Created by Lucas Dal Pra Brascher on 07/07/25.
//

import Foundation

struct AppGroup {
    static let identifier = "group.com.dalpra.GimoApp"

    static var userDefaults: UserDefaults {
        guard let defaults = UserDefaults(suiteName: identifier) else {
            fatalError("Não foi possível inicializar o UserDefaults compartilhado. Verifique o App Group ID em Signing & Capabilities.")
        }
        return defaults
    }
}
