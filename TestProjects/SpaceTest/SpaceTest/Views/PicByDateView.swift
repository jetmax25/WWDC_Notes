//
//  PicByDateView.swift
//  SpaceTest
//
//  Created by Michael Isasi on 8/1/23.
//

import SwiftUI

struct PicByDateView: View {
    @StateObject var viewModel = ViewModel()

    var body: some View {
        VStack {
            Spacer()
            if let photo = viewModel.photo {
                PhotoView(photo: photo)
            } else {
                ProgressView()
            }
            Button("Next") {
                Task {
                    await viewModel.updatePhoto()
                }
            }
            Spacer()
        }.task {
            await viewModel.updatePhoto()
        }
    }
    
    class ViewModel: ObservableObject {
        @Published var photo: AstronomyPicOfTheDay?
        
        var iterator = AsyncPhotoOfTheDaySequence().makeAsyncIterator()
        
        func updatePhoto() async {
            self.photo = nil
            self.photo = await iterator.next()
        }
    }
}

struct PicByDateView_Previews: PreviewProvider {
    static var previews: some View {
        PicByDateView()
    }
}


