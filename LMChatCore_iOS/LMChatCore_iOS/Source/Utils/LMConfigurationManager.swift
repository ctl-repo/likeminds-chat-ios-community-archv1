import Foundation
import LikeMindsChatData

public class LMConfigurationManager {
    private static let shared = LMConfigurationManager()
    
    private init() {}
    
    static func saveConfigurations(_ configurations: [Configuration]) {
        if let encodedData = try? JSONEncoder().encode(configurations) {
            LMSharedPreferences.setValue(
                encodedData,
                key: LMSharedPreferencesKeys.communityConfigurations.rawValue
            )
        }
        
        // Extract and save reply_privately configuration separately
        if let replyPrivatelyConfig = configurations.first(where: { $0.type == .replyPrivately }) {
            if let encodedConfig = try? JSONEncoder().encode(replyPrivatelyConfig) {
                LMSharedPreferences.setValue(
                    encodedConfig,
                    key: LMSharedPreferencesKeys.replyPrivatelyConfiguration.rawValue
                )
            }
        }
    }
    
    static func getReplyPrivatelyConfiguration() -> Configuration? {
        guard let data = LMSharedPreferences.getData(forKey: .replyPrivatelyConfiguration),
              let config = try? JSONDecoder().decode(Configuration.self, from: data)
        else {
            return nil
        }
        return config
    }
}
