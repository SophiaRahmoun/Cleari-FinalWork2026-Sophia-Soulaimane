import SwiftUI

struct AuthBirthdatePicker: View {
    @Binding var birthdate: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Birthdate")
                .font(AppFont.gillSwiftUI(.regular, size: 18))
                .foregroundColor(.black)

            DatePicker(
                "",
                selection: $birthdate,
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
            .labelsHidden()
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .frame(height: 65)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "E6DED6"))
                    .shadow(color: .black.opacity(0.08), radius: 6, y: 4)
            )
        }
    }
}

#Preview {
    ZStack {
        AuthBackground()

        AuthBirthdatePicker(birthdate: .constant(Date()))
            .padding(.horizontal, 32)
    }
}
