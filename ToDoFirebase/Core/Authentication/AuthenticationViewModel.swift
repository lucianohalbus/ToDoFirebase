//Created by Halbus Development

import Foundation

@MainActor
final class AuthenticationViewModel: ObservableObject {

    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        let user: DBUser = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(dbUser: user)
    }
    
    func signInApple() async throws {
        let helper = SignInWithAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        let authDataResult = try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
        let user: DBUser = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(dbUser: user)
    }
    
    func signInAnonymously() async throws {
        let authDataResult = try await AuthenticationManager.shared.signInAnonymously()
        let user: DBUser = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(dbUser: user)
    }

}


