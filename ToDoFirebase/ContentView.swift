//Created by Halbus Development

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        AuthenticationView(showSignInView: .constant(false))
    }
}

#Preview {
    ContentView()
}
