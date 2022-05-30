//
//  ContentView.swift
//  MultiPliGame
//
//  Created by Moe Steinmueller on 11.02.22.
//

import SwiftUI

struct GradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .font(.custom("Farah", size: 30))
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.green]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(15.0)
            .scaleEffect(configuration.isPressed ? 1.3 : 1.0)
    }
}

struct SettingsView: View {
    @State private var rootPresenting: Bool = false
    
    @State private var multiplicationsNum = 4
    @State private var outOfRangeMinus = false
    @State private var outOfRangePlus = false
    @State private var firstNumber = 1
    @State private var secondNumber = 1
    
    @State private var numberOfQuestionsArray = [5, 10, 20]
    @State private var numberOfQuestions = 5
    
    
    var body: some View {
        NavigationView {
            ZStack {
                
                Image("settingsViewBG")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("MultiPli")
                        .font(.custom("Arial Rounded MT Bold", size: 50))
                        .fontWeight(.bold)
                        .padding(.bottom, 30)
                        .foregroundColor(.green)
                    
                    Spacer()
                    
                    Text("Which number of table?")
                        .font(.custom("Arial Rounded MT Bold", size: 25))
                        .foregroundColor(.orange)
                        .padding(.bottom, 20)
                    
                    HStack {
                        Button {
                            setTableNumber(sign: "minus")
                        } label: {
                            Image("minusButton")
                                .resizable()
                                .clipShape(Circle())
                                .shadow(radius: 10)
                                .overlay(Circle().stroke(Color.orange, lineWidth: 5))
                                .frame(width: 50, height: 50)
                            
                        }
                        .disabled(outOfRangeMinus ? true : false)
                        .blur(radius: outOfRangeMinus ? 10 : 0)
                        
                        Text(String("\(multiplicationsNum)"))
                            .font(.largeTitle)
                            .padding(.horizontal, 80)
                            .foregroundColor(.orange)
                        
                        Button {
                            setTableNumber(sign: "plus")
                        } label: {
                            Image("plusButton")
                                .resizable()
                                .clipShape(Circle())
                                .shadow(radius: 10)
                                .overlay(Circle().stroke(Color.orange, lineWidth: 5))
                                .frame(width: 50, height: 50)
                            
                        }
                        .disabled(outOfRangePlus ? true : false)
                        .blur(radius: outOfRangePlus ? 10 : 0)
                    }
                    .padding(.bottom, 100)
                    
                    
                    Text("How many questions?")
                        .font(.custom("Arial Rounded MT Bold", size: 25))
                        .foregroundColor(.orange)
                        .padding(.bottom, 20)
                    
                    Picker("How many questions?", selection: $numberOfQuestions) {
                        ForEach(numberOfQuestionsArray, id: \.self) {
                            Text("\(String($0))")
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 60)
                    .colorMultiply(.orange)
                
                    
//                    Spacer()
                    
                    NavigationLink(destination: GameView(rootPresenting: $rootPresenting, multiplicationsNum: multiplicationsNum, numberOfQuestions: numberOfQuestions,firstNumber: $firstNumber, secondNumber: $secondNumber), isActive: $rootPresenting) { EmptyView() }
                    Button("START") {
                        rootPresenting = true
                        firstNumber = Int.random(in: 1...multiplicationsNum)
                        secondNumber = Int.random(in: 1...multiplicationsNum)
                    }
                    .buttonStyle(GradientButtonStyle())
//                    .padding(.bottom, 140)
                    
                    Spacer()
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarTitle("")
                .navigationBarBackButtonHidden(true)
            }
            .onAppear {
                reset()
            }
            
        }
        .navigationViewStyle(.stack)
    }
    
    func setTableNumber(sign: String) {
        if sign == "plus" {
            outOfRangeMinus = false
            
            if multiplicationsNum == 11 {
                multiplicationsNum += 1
                outOfRangePlus = true
                
            } else {
                multiplicationsNum += 1
            }
        } else {
            outOfRangePlus = false
            
            if multiplicationsNum == 3 {
                multiplicationsNum -= 1
                outOfRangeMinus = true
            } else {
                multiplicationsNum -= 1
            }
        }
    }
    
    func reset() {
        multiplicationsNum = 4
        outOfRangeMinus = false
        outOfRangePlus = false
        numberOfQuestions = 5
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .previewInterfaceOrientation(.portrait)
    }
}
