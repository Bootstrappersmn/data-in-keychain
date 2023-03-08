//
//  data_in_keychain.swift
//  
//
//  Created by Jeremy Bannister on 3/8/23.
//

///
@_exported import OSErrorModule
@_exported import LocalAuthentication


///
public extension Data {
    
    ///
    @MainActor
    static func fetchedFromKeychain
        (uniqueKey: String,
         authenticationContext: LAContext? = nil)
    throws -> Self? {
        
        ///
        var query = [kSecClass: kSecClassGenericPassword,
                     kSecAttrAccount: uniqueKey,
                     kSecReturnData: true] as [String: Any]
        
        ///
        #if os(iOS)
        query[kSecUseDataProtectionKeychain as String] = true
        #endif
        
        ///
        if let authenticationContext = authenticationContext {
            query[kSecUseAuthenticationContext as String] = authenticationContext
        }

        ///
        var item: CFTypeRef?
        
        ///
        let error: OSError? =
            SecItemCopyMatching(
                query as CFDictionary,
                &item
            )
                .asOSError
        
        ///
        if let error {
            
            ///
            if case .errSecItemNotFound = error {
                
                ///
                return nil
                
            } else {
                
                ///
                throw error
            }
            
        /// Nil error means success
        } else {
            
            ///
            return item as? Data
        }
    }
    
    ///
    @MainActor
    func saveToKeychain
        (uniqueKey: String,
         accessGroup: String,
         requireBiometry: Bool)
    throws {
        
        ///
        var query: [String: Any] =
            [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: uniqueKey,
                kSecUseDataProtectionKeychain: true,
                kSecAttrAccessGroup: accessGroup,
                kSecValueData: self
            ] as [String: Any]
        
        ///
        if requireBiometry {
            
            ///
            query[kSecAttrAccessControl as String] =
                SecAccessControlCreateWithFlags(
                    nil,
                    kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
                    .biometryCurrentSet,
                    nil
                )
        } else {
            
            ///
            query[kSecAttrAccessible as String] = kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
        }

        ///
        let error: OSError? =
            SecItemAdd(
                query as CFDictionary,
                nil
            )
                .asOSError
        
        ///
        if let error { throw error }
    }
    
    ///
    @MainActor
    static func deleteFromKeychain (uniqueKey: String) throws {
        
        ///
        var query = [kSecClass: kSecClassGenericPassword,
                     kSecAttrAccount: uniqueKey] as [String: Any]
        
        ///
        #if os(iOS)
        query[kSecUseDataProtectionKeychain as String] = true
        #endif
        
        ///
        let error: OSError? =
            SecItemDelete(
                query as CFDictionary
            )
                .asOSError
        
        ///
        if let error { throw error }
    }
}
