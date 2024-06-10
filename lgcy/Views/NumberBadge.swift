import SwiftUI

struct NumberBadge: View {
    var number: Int
    var body: some View {
        Text("\(number)")
            .font(.caption)
            .padding(4)
            .background(Circle().fill(Color.blue))
            .overlay(
                Circle().stroke(Color.white, lineWidth: 1)
            )
    }
}

#Preview {
    NumberBadge(number: 1)
}
