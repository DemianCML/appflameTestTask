import SwiftUI
import ComposableArchitecture

struct AccountDetailsView: View {
    
    let store: StoreOf<AccountDetailsFeature>

    var body: some View {
        VStack {
            Text("\(store.state.data.accountName.replacingUnderscoresWithSpaces())")
                .font(.largeTitle)
                .padding()
            Spacer()
        }
        .navigationTitle("Детали")
        .navigationBarTitleDisplayMode(.inline)
    }
}
