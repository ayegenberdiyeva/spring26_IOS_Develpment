//
//  OutfitGenerator.swift
//  RandomCardGenerator
//
//  Created by Amina Yegenberdiyeva on 18.02.2026.
//

import SwiftUI

struct OutfitGenerator: View {
    let dresses = ["dress1", "dress2", "dress3", "dress4", "dress5", "dress6"]
    let tops = ["top1", "top2", "top3", "top4", "top5", "top6", "top7", "top8", "top9", "top10", "top11", "top12", "top13", "top14"]
    let bottoms = ["bottom1", "bottom2", "bottom3", "bottom5", "bottom6", "bottom7", "bottom8", "bottom9", "bottom10", "bottom11", "bottom12", "bottom13", "bottom14", "bottom15"]
    let shoes = ["shoe1", "shoe2", "shoe3", "shoe4", "shoe5", "shoe6", "shoe7", "shoe8", "shoe9", "shoe10", "shoe11", "shoe12"]
    let bags = ["bag1", "bag2", "bag3", "bag4", "bag5", "bag6", "bag7", "bag8"]
    
    @State private var dressIndex: Int? = nil
    @State private var topIndex: Int? = nil
    @State private var bottomIndex: Int? = nil
    @State private var shoeIndex: Int? = nil
    @State private var bagIndex: Int? = nil
    
    private var hasGeneratedOutfit: Bool {
        dressIndex != nil || (topIndex != nil && bottomIndex != nil)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Outfit Generator")
                .font(.largeTitle.bold())
                .foregroundStyle(Color(.white))
            
            Spacer()
            
            if hasGeneratedOutfit {
                HStack() {
                    if let dressIndex {
                        VStack() {
                            Image(dresses[dressIndex])
                                .resizable()
                                .scaledToFit()
                                .frame(height: 480)
                            
                            Spacer(minLength: 80)
                        }
                        .frame(maxWidth: .infinity)
                        
                    } else if let topIndex, let bottomIndex {
                        VStack() {
                            
                            Image(tops[topIndex])
                                .resizable()
                                .scaledToFit()
                                .frame(height: 180)
                            Image(bottoms[bottomIndex])
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    VStack() {
                        Spacer()
                        if let bagIndex {
                            Image(bags[bagIndex])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 240)
                        }
                        
                        if let shoeIndex {
                            Image(shoes[shoeIndex])
                                .resizable()
                                .scaledToFit()
                                .frame(height: 140)
                        }
                    }
                }
                .frame(height: 500)
            }
            
            Spacer()
            
            Button(hasGeneratedOutfit ? "Generate Again" : "Generate Outfit") {
                generateOutfit()
            }
            .foregroundStyle(Color(.white))
            .underline(true)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 23/255, green: 23/255, blue: 23/255))
    }
    
    private func generateOutfit() {
        let wearDress = Bool.random()
        
        shoeIndex = Int.random(in: 0..<shoes.count)
        bagIndex = Int.random(in: 0..<bags.count)
        
        if wearDress {
            dressIndex = Int.random(in: 0..<dresses.count)
            topIndex = nil
            bottomIndex = nil
        } else {
            topIndex = Int.random(in: 0..<tops.count)
            bottomIndex = Int.random(in: 0..<bottoms.count)
            dressIndex = nil
        }
    }
}

#Preview {
    OutfitGenerator()
}
