import SwiftUI

struct OnboardingPageInfo {
    let id = UUID()
    let image: String
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPageInfo

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Image(page.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 260, height: 260)
            
            Text(page.title)
                .font(.system(size: 26.05, weight: .bold))
                .foregroundColor(Color("corPrimaria"))
                .multilineTextAlignment(.center)

            Text(page.description)
                .font(.system(size: 16))
                .foregroundColor(Color("corTextoSecundario"))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .padding(.horizontal, 40)
    }
}
