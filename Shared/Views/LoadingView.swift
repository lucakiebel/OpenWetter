//
//  LoadingView.swift
//  OpenWetter
//
//  Created by Luca Kiebel on 05.12.21.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
		ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white)).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
