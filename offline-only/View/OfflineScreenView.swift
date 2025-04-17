//
//  OfflineScreenView.swift
//  offline-only
//
//  Created by marc on 17.04.25.
//

import SwiftUI

struct StrikeThroughWifi: View {
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.black, lineWidth: 16)
            Image(systemName: "wifi")
                .font(.system(size: 88))
                .foregroundColor(.black)
            Rectangle()
                .fill(Color.black)
                .frame(width: 172, height: 16)
                .rotationEffect(Angle(degrees: 45))
        }
        .frame(width: 172, height: 172)
    }
}

struct OfflineScreenView: View {
    var body: some View {
        VStack(spacing: 48) {
            StrikeThroughWifi()
            Text("GO OFFLINE\nTO ENTER")
                .font(.system(size: 54, weight: .bold))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.996, green: 0.004, blue: 0.0, opacity: 1.0))
        .edgesIgnoringSafeArea(.all)
    }
}

