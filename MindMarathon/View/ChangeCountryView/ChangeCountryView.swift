//
//  ChangeCountryView.swift
//  MindMarathon
//
//  Created by Алексей Шамрей on 26.01.24.
//

import SwiftUI
import FlagKit

struct Countries: Identifiable, Hashable {
    let id = UUID()
    let image: String
    let countryName: String
    var showMark: Bool
}

struct CountriesRaw: View {
    @State var country: Countries
    
    var body: some View {
        HStack(spacing: 20) {
            let image = Flag(countryCode: country.image)
            let originalImage = image!.originalImage
            Image(uiImage: originalImage)
                .padding(.leading, 10)
            Text("\(country.countryName)")
                .tint(Color.blue)
            Spacer()
            Spacer()
            if country.showMark {
                Image(systemName: "checkmark")
                    .colorMultiply(.green)
            }
        }
    }
}

struct ChangeCountryView: View {
    @State var countries = CountryManager().country
    @State var countriesLists: [Countries] = []
    @State var selectedCountry: Countries?
    var dismisAction: (() -> Void)
    
    var body: some View {
        NavigationView {
            List(countriesLists, id: \.self) { country in
                CountriesRaw(country: country)
                    .background(self.selectedCountry == country ? Color.green : Color.clear)
                    .onTapGesture {
                        self.selectedCountry = country
                        self.countriesLists = self.countriesLists.map {
                            if $0.countryName == country.countryName {
                                return Countries(image: $0.image, countryName: $0.countryName, showMark: true)
                            } else {
                                return Countries(image: $0.image, countryName: $0.countryName, showMark: false)
                            }
                        }
                    }
                    .background(Color.clear)
            }
            .navigationTitle("changeCountry".localized()!)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear() {
                self.countriesLists = self.countries.map { Countries(image: $0[0], countryName: $0[1], showMark: false) }
            }
            .navigationBarItems(trailing:
            Button("Сохранить") {
                if selectedCountry != nil {
                    RealmManager.shared.changeUserNationality(country: selectedCountry?.image ?? "")
                    self.dismisAction()
                }
            }
                .disabled(selectedCountry == nil)
            )
        }
    }
}






