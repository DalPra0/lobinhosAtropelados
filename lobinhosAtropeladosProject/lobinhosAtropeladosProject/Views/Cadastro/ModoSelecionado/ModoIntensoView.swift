import SwiftUI

struct ModoIntensoView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image("gimoMascoteIntenso")
                .resizable()
                .scaledToFit()
                .frame(height: 150)

            Text("Tudo pronto!")
                .font(.title).bold()
                .foregroundColor(Color("corTextoPrincipal"))

            Text("Seu modo é **intenso**. Você tem muita energia e quer aproveitar cada minuto para ser super produtivo(a). Adora um dia cheio de desafios e deques!\n\nFique tranquilo(a), você pode mudar para outro modo sempre que quiser!")
                .font(.subheadline)
                .foregroundColor(Color("corTextoPrincipal"))
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

struct ModoIntensoView_Previews: PreviewProvider {
    static var previews: some View {
        ModoIntensoView()
    }
}
