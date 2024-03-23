//Created by Halbus Development

import Foundation

@MainActor
final class SignInEmailViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email and/or password found.")
            return
        }

        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        try await UserManager.share.createNewUser(auth: authDataResult)
 
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email and/or password found.")
            return
        }

        _ = try await AuthenticationManager.shared.signInUser(email: email, password: password)
 
    }
}
