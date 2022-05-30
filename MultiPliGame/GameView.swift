//
//  GameView.swift
//  MultiPliGame
//
//  Created by Moe Steinmueller on 11.02.22.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct GameView: View {
    
    @Binding var rootPresenting: Bool
    var multiplicationsNum: Int = 1
    var numberOfQuestions: Int
    @Binding var firstNumber: Int
    @Binding var secondNumber: Int
    
    @State private var currentQuestion = 1
    @State private var givenAnswer = ""
    @State private var correctlyAnswered = 0
    @State private var correctAnimation = false
    @State private var wrongAnimation = false
    @State private var readyToFinish = false
    @State private var finished = false
    
    
    var correctAnswer : Int {
        return firstNumber * secondNumber
    }
    
    var firstNumString : String {
        return String(firstNumber)
    }
    
    var firstNumLetter : String {
        return giveLetter(num: firstNumber)
    }
    
    var secondNumLetter : String {
        return giveLetter(num: secondNumber)
    }
    
    func giveLetter(num: Int) -> String {
        switch num {
        case 1:
            return "one"
        case 2:
            return "two"
        case 3:
            return "three"
        case 4:
            return "four"
        case 5:
            return "five"
        case 6:
            return "six"
        case 7:
            return "seven"
        case 8:
            return "eight"
        case 9:
            return "nine"
        case 10:
            return "ten"
        case 11:
            return "eleven"
        case 12:
            return "twelve"
        default:
            return "one"
        }
    }
    
    var secondNumString: String {
        return String(secondNumber)
    }
    
    let rows = [
        ["7", "8", "9"],
        ["4", "5", "6"],
        ["1", "2", "3"],
        ["0", "🔙", "GO"]
    ]
    
    
    
    var body: some View {
        
        ZStack {
            Image("gameviewBG")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: 300)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                Button("QUIT"){
                    rootPresenting = false
                }
                .foregroundColor(.red)
                .padding(EdgeInsets(top: 20, leading: 280, bottom: 30, trailing: 0))
                
                
                ProgressView(value: Float(currentQuestion), total: Float(numberOfQuestions + 1))
                    .accentColor(Color.green)
                    .scaleEffect(x: 1, y: 4, anchor: .center)
                    .padding(.horizontal, 30)
                    .frame(minWidth: 0, maxWidth: 300)
                
                
                HStack {
                    
                    Image(firstNumLetter)
                        .resizable()
                        .frame(width:80, height: 80)
                        .cornerRadius(50)
                    
                    
                    Image("multiples")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding(.horizontal, 30)
                    
                    Image(secondNumLetter)
                        .resizable()
                        .frame(width: 80, height: 80)
                        .cornerRadius(50)
                    
                    
                }
                .padding(.top, 40)
                
                HStack {
                    Image("equal")
                        .resizable()
                        .frame(width: 50, height: 50)
                    
                    TextField("0", text: $givenAnswer) {
                        UIApplication.shared.endEditing()
                    }
                    .font(.largeTitle)
                    .frame(width: 200)
                    .multilineTextAlignment(.trailing)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .disabled(true)
                    
                }
                
                VStack(alignment: .center) {
                    ForEach(rows, id: \.self) { row in
                        HStack {
                            
                            VStack {
                                if readyToFinish {
                                    NavigationLink(destination: ResultView(rootPresenting: $rootPresenting, multiplicationsNum: multiplicationsNum ,correctlyAnswered: correctlyAnswered, totalNumOfQuestions: numberOfQuestions), isActive: $finished) { EmptyView() }
                                }
                            }.hidden()
                            
                            ForEach(row, id: \.self) { column in
                                Button(action: {
                                    typingAnswer(tappedNum: column)
                                }, label: {
                                    Text(column)
                                        .font(.system(size: 30))
                                        .frame(width: 70, height: 50)
                                })
                                    .foregroundColor(Color.white)
                                    .background(.green)
                                    .cornerRadius(10)
                                    .padding(3)
                                    .disabled(correctAnimation || wrongAnimation)
                            }
                        }
                    }
                }
                
                Spacer()
                
                
                if correctAnimation || wrongAnimation {
                    
                    VStack (alignment: .center, spacing: 3) {
                        Image(systemName: correctAnimation ? "checkmark" : "xmark")
                            .foregroundColor(.white)
                            .font(.system(size: 48, weight: .bold))
                            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                        Text(correctAnimation ? "CORRECT" : "WRONG")
                            .foregroundColor(.white)
                            .font(.callout)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10))
                        
                        if wrongAnimation {
                            Text("Answer: \(correctAnswer)")
                                .foregroundColor(.white)
                                .font(.system(size: 13, weight: .regular))
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10))
                        }
                    }
                    .background(Color.gray.opacity(0.75))
                    .frame(width: 130, height: 100)
                    .transition(.scale)
                    .onAppear(perform: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                            self.correctAnimation = false
                            self.wrongAnimation = false
                        })
                    })
                }
                
                Spacer()
                Spacer()
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
        }
    }
    
    func typingAnswer(tappedNum: String) {
        if tappedNum == "🔙"  {
            var numbers = givenAnswer.map(String.init)
            if !numbers.isEmpty {
                numbers.removeLast()
            }
            
            let result = numbers.joined(separator: "")
            givenAnswer = result
        } else if tappedNum == "GO" {
            checkAnswer(userAnswer: givenAnswer)
        } else if tappedNum == "0" && givenAnswer.isEmpty {
            givenAnswer = ""
        } else {
            givenAnswer += tappedNum
        }
        
    }
    
    func checkAnswer(userAnswer: String) {
        let answerInt = Int(userAnswer)
        if answerInt == correctAnswer {
            correctlyAnswered += 1
            correctAnimation = true
        } else {
            wrongAnimation = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            nextQuestion()
        })
        
    }
    
    func nextQuestion() {
        if currentQuestion == numberOfQuestions {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                finished = true
            }
        } else {
            if currentQuestion == (numberOfQuestions - 1) {
                readyToFinish = true
            }
            firstNumber = Int.random(in: 2...multiplicationsNum)
            secondNumber = Int.random(in: 2...multiplicationsNum)
            givenAnswer = ""
        }
        currentQuestion += 1
    }
    
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(rootPresenting: .constant(false), multiplicationsNum: 3, numberOfQuestions: 5, firstNumber: .constant(4), secondNumber: .constant(3))
    }
}
