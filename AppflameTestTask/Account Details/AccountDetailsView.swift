import SwiftUI
import ComposableArchitecture

struct AccountDetailsView: View {
    
    let store: StoreOf<AccountDetailsFeature>
    
    var body: some View {
        VStack(spacing: 24) {
            Image(.logo)
            
            VStack(alignment: .center, spacing: 4) {
                Text("\(store.state.data.accountName.replacingUnderscoresWithSpaces())")
                    .font(.system(size: 24, weight: .medium))
                Text("\(store.state.data.description.replacingUnderscoresWithSpaces())")
                    .font(.system(size: 22, weight: .regular))
                    .foregroundStyle(.gray)
            }
            
            Text((store.state.data.amount >= 0 ? "$" : "-$") + "\(abs(store.state.data.amount))")
                .font(.system(size: 40, weight: .regular))
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    store.send(.onBackButtonTapped)
                } label: {
                    Image(.backButton)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("Details")
                    .font(.system(size: 17, weight: .semibold))
            }
        }
    }
}
