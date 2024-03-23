//Created by Halbus Development

import Foundation

@MainActor
final class AuthenticationViewModel: ObservableObject {

    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        try await UserManager.share.createNewUser(auth: authDataResult)
    }
    
    func signInApple() async throws {
        let helper = SignInWithAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        let authDataResult = try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
        try await UserManager.share.createNewUser(auth: authDataResult)
    }
    
    func signInAnonymously() async throws {
        let authDataResult = try await AuthenticationManager.shared.signInAnonymously()
        try await UserManager.share.createNewUser(auth: authDataResult)
    }

}


