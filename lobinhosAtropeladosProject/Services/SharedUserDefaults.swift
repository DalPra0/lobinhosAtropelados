//
//  SharedUserDefaults.swift
//  lobinhosAtropeladosProject
//
//  Created by Lucas Dal Pra Brascher on 07/07/25.
//

import Foundation

struct AppGroup {
    // IMPORTANTE: Substitua "group.com.dalpra.GimoApp" pelo ID exato que você criou no Xcode.
    static let identifier = "group.com.dalpra.GimoApp"

    // Propriedade computada para acessar o UserDefaults compartilhado.
    static var userDefaults: UserDefaults {
        guard let defaults = UserDefaults(suiteName: identifier) else {
            // Este erro fatal acontecerá se o App Group não estiver configurado corretamente.
            fatalError("Não foi possível inicializar o UserDefaults compartilhado. Verifique o App Group ID em Signing & Capabilities.")
        }
        return defaults
    }
}
