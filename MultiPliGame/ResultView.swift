//
//  ResultView.swift
//  MultiPliGame
//
//  Created by Moe Steinmueller on 12.02.22.
//

import SwiftUI


struct ResultView: View {
    @Binding var rootPresenting: Bool
    
    var multiplicationsNum: Int
    var correctlyAnswered: Int
    var totalNumOfQuestions: Int
    
    
    
    
    var body: some View {
        ZStack {
            Image("resultViewBG")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity)
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Image("goodjob")
                        .resizable()
                        .frame(width:80, height: 80)
                        .padding(.horizontal, 10)
                    
                    Text("COMPLETED")
                        .tint(.brown)
                        .font(.custom("Menlo", size: 40))
                        .foregroundColor(.brown)
                }
                
                if correctlyAnswered == totalNumOfQuestions {
                    Text("You answered all the questions correct!!")
                        .padding(.horizontal, 30)
                        .font(.custom("Arial Rounded MT Bold", size: 30))
                        .foregroundColor(.brown)
                    
                } else {
                    Text("You got \(correctlyAnswered) out of \(totalNumOfQuestions) questions right!")
                        .padding(.horizontal, 30)
                        .font(.custom("Arial Rounded MT Bold", size: 30))
                        .foregroundColor(.brown)
                }
                
                HStack {
                    
                    Spacer()
                    
                    Image("monkey")
                        .resizable()
                        .frame(width: 230, height: 230)
                    
                }
                
                
                Group {
                    Button(action: {
                        rootPresenting = false
                    }) {
                        Text("RESTART")
                            .padding()
                    }
                    .foregroundColor(Color.white)
                    .font(.custom("Menlo", size: 30))
                    
                }
                .background(Color.green)
                .cornerRadius(20)
                
                HStack {
                    Image("deer")
                        .resizable()
                        .frame(width:230, height: 230)
                    
                    Spacer()
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(rootPresenting: .constant(false), multiplicationsNum: 5, correctlyAnswered: 3, totalNumOfQuestions: 10)
    }
}
