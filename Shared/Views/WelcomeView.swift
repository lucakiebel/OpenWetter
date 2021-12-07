//
//  WelcomeView.swift
//  OpenWetter
//
//  Created by Luca Kiebel on 05.12.21.
//

import SwiftUI
import CoreLocationUI


struct WelcomeView: View {
	@EnvironmentObject var locationManager: LocationManager
	
    var body: some View {
		VStack {
			VStack(spacing: 20) {
				Text("Willkommen in der OpenWetter App").bold().font(.title)
				
				Text("Bitte den Standort teilen, um das passsende Wetter zu bekommen").padding()
			}.multilineTextAlignment(.center).padding()
			
			LocationButton(.shareCurrentLocation) {
				locationManager.requestLocation()
			}.cornerRadius(10).symbolVariant(.fill).foregroundColor(.white)
			
			
		}.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
