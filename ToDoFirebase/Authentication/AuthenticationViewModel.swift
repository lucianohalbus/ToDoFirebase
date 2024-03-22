//Created by Halbus Development

import Foundation

@MainActor
final class AuthenticationViewModel: ObservableObject {

    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
    }
    
    func signInApple() async throws {
        let helper = SignInWithAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
    }
    
    func signInAnonymously() async throws {
        try await AuthenticationManager.shared.signInAnonymously()
    }

}


