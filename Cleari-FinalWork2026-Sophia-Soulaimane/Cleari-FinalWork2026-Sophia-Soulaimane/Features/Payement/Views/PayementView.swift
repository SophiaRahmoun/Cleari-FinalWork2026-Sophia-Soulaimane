//
//  PayementView.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 25/05/2026.
//

import SwiftUI

struct PayementView: View {

    @Environment(\.dismiss) private var dismiss

    var body: some View {

        ZStack {

            LinearGradientBackground(
                startHex: "C66F8C",
                endHex: "F9BDB9"
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {

                VStack(spacing: 28) {

                    header

                    VStack(spacing: 12) {

                        Text("Unlock full access")
                            .font(AppFont.gillSwiftUI(.regular, size: 34))
                            .foregroundColor(Color(hex: "1A1018"))

                        Text("Subscribe to access certified dermatologists for private consultations")
                            .font(AppFont.gillSwiftUI(.regular, size: 20))
                            .foregroundColor(Color(hex: "1A1018"))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 28)
                    }

                    freePlanCard

                    VStack(spacing: 10) {

                        Text("Go Premium")
                            .font(AppFont.gillSwiftUI(.regular, size: 30))
                            .foregroundColor(Color(hex: "1A1018"))

                        Text("Get priority access to certified dermatologists plus exclusive community features.")
                            .font(AppFont.gillSwiftUI(.regular, size: 17))
                            .foregroundColor(Color(hex: "1A1018"))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 28)
                    }
                    .padding(.top, 12)

                    premiumPlanCard(
                        title: "Monthly plan",
                        subtitle: "Billed $11 every month",
                        price: "$11",
                        period: "/month"
                    )

                    premiumPlanCard(
                        title: "Annual plan",
                        subtitle: "Billed $132 every year",
                        price: "$132",
                        period: "/year"
                    )

                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 55)
                .padding(.bottom, 40)
            }
        }
    }

    private var header: some View {

        HStack {

            Button {
                dismiss()

            } label: {

                Image(systemName: "chevron.left")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(hex: "1A1018"))
            }

            Spacer()
        }
    }

    private var freePlanCard: some View {

        HStack(spacing: 18) {

            Circle()
                .fill(Color(hex: "3A1718"))
                .frame(width: 64, height: 64)

            VStack(alignment: .leading, spacing: 10) {

                Text("Free plan")
                    .font(AppFont.gillSwiftUI(.regular, size: 24))
                    .foregroundColor(Color(hex: "1A1018"))

                Text("Access the community form & join discussions.")
                    .font(AppFont.gillSwiftUI(.regular, size: 16))
                    .foregroundColor(Color(hex: "1A1018"))

                Text("No direct consultation with dermatologist")
                    .font(AppFont.gillSwiftUI(.regular, size: 15))
                    .foregroundColor(Color(hex: "1A1018"))
            }

            Spacer()

            Text("Current plan")
                .font(AppFont.gillSwiftUI(.regular, size: 15))
                .foregroundColor(Color(hex: "1A1018"))
        }
        .padding(22)
        .background(Color("AccentColor").opacity(0.35))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private func premiumPlanCard(
        title: String,
        subtitle: String,
        price: String,
        period: String
    ) -> some View {

        Button {

            // Start async Stripe request
            Task {

                do {

                    // Ask backend to create Stripe checkout
                    let checkoutUrl = try await PayementService.shared
                        .createCheckoutSession(planType: "monthly")

                    // Open Stripe checkout page
                    if let url = URL(string: checkoutUrl) {

                        await MainActor.run {
                            UIApplication.shared.open(url)
                        }
                    }

                } catch {

                    // Print Stripe errors in console
                    print(
                        "STRIPE CHECKOUT ERROR:",
                        error.localizedDescription
                    )
                }
            }

        } label: {

            HStack {

                VStack(alignment: .leading, spacing: 18) {

                    Text(title)
                        .font(AppFont.gillSwiftUI(.regular, size: 23))
                        .foregroundColor(Color(hex: "1A1018"))

                    Text(subtitle)
                        .font(AppFont.gillSwiftUI(.regular, size: 14))
                        .foregroundColor(Color(hex: "1A1018"))
                }

                Spacer()

                HStack(alignment: .firstTextBaseline, spacing: 2) {

                    Text(price)
                        .font(AppFont.gillSwiftUI(.bold, size: 28))
                        .foregroundColor(Color(hex: "1A1018"))

                    Text(period)
                        .font(AppFont.gillSwiftUI(.regular, size: 24))
                        .foregroundColor(Color(hex: "1A1018"))
                }
            }
            .padding(24)
            .frame(height: 120)
            .background(Color("AccentColor").opacity(0.35))
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .buttonStyle(.plain)
    }
}
