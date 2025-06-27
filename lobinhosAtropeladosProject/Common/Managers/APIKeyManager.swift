import Foundation

enum APIKeyManager {
    static var geminiKey: String {
        guard let url = Bundle.main.url(forResource: "API_KEY", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any],
              let key = plist["keygemini"] as? String else {
            fatalError("Não foi possível encontrar a chave 'keygemini' no arquivo API_KEY.plist. Verifique se o arquivo e a chave existem.")
        }
        return key
    }
}
