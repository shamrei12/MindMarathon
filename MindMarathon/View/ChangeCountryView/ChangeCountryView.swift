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
                .frame(width: UIScreen.main.bounds.width * 0.6, alignment: .leading)
                .frame(alignment: .leading)
                .background(.clear)
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
        VStack {
            TopBarView()
            CountriesListView()
        }
    }
    
    private func TopBarView() -> some View {
        HStack {
            Spacer()
            Text("changeCountry".localize())
                .font(.init(UIFont.sfProText(ofSize: 15, weight: .bold)))
            Spacer()
            SaveButton()
        }
        .padding(.top, 10)
        .padding(.trailing, 10)
    }
    
    private func SaveButton() -> some View {
        Button("Save") {
            if let selectedCountry = selectedCountry {
                RealmManager.shared.changeUserNationality(country: selectedCountry.image)
                self.dismisAction()
            }
        }
        .disabled(selectedCountry == nil)
    }
    
    private func CountriesListView() -> some View {
        List(countriesLists, id: \.self) { country in
            CountryRowView(country: country)
        }
        .onAppear {
            self.countriesLists = self.countries.map { Countries(image: $0[0], countryName: $0[1], showMark: false) }
        }
    }
    
    private func CountryRowView(country: Countries) -> some View {
        CountriesRaw(country: country)
            .background(self.selectedCountry == country ? Color.green : Color.clear)
            .contentShape(Rectangle()) 
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

}
