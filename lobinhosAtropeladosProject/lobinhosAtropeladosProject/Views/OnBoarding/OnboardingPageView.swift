import SwiftUI

struct OnboardingPageInfo {
    let id = UUID()
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPageInfo

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
                .frame(height: 300)
            
            Text(page.title)
                .font(.secularOne(size: 26.8))
//                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Text(page.description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            Spacer()
        }
    }
}
