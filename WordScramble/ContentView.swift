//
//  ContentView.swift
//  WordScramble
//
//  Created by Kirill Baranov on 30/11/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var scoreWords = 0
    @State private var scoreLetters = 0
    
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @State private var showAlert = false
    
    var body: some View {
        
        NavigationStack {
            List {
                Section("Score") {
                    HStack {
                        Text("Words: \(scoreWords)")
                        Text("Letters: \(scoreLetters)")
                    }
                }

                Section {
                    TextField("Enter your word", text: $newWord)
                        .onSubmit(addNewWord)
                        .textInputAutocapitalization(.never)
                    
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                        .accessibilityElement()
                        .accessibilityLabel(word)
                        .accessibilityHint("\(word.count) letters") 
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button("New game") {
                        startGame()
                    }
                }
            }
            .navigationTitle(rootWord)
            .alert(alertTitle, isPresented: $showAlert) {
                Button("OK") {
                }
            } message: {
                Text(alertMessage)
            }
            
        }
    }
    
    func addNewWord() {
        withAnimation {
            
            let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            
            /// SWITCH
            switch false {
            case answer.count > 2:
                showAlert.toggle()
                alertTitle = "Word is too short"
                alertMessage = "Write a word with more then 2 letters"
            case answer != rootWord.lowercased():
                showAlert.toggle()
                alertTitle = "Main word"
                alertMessage = "You should write new word"
            case isOriginal(word: answer):
                showAlert.toggle()
                alertTitle = "Word used already"
                alertMessage = "Be more original"
            case isPossible(word: answer):
                showAlert.toggle()
                alertTitle = "Word not possible"
                alertMessage = "You can't spell that word from '\(rootWord)'!"
            case isReal(word: answer):
                showAlert.toggle()
                alertTitle = "Word not recognized"
                alertMessage =  "You can't just make them up, you know!"
            default:
                usedWords.insert(answer, at: 0)
                scoreWords += 1
                scoreLetters += answer.count
            }
            
            /// IF ELSE
//            if answer.count > 2 {
//                if answer != rootWord.lowercased() {
//                    
//                    if isOriginal(word: answer) {
//                        if isPossible(word: answer) {
//                            if isReal(word: answer) {
//                                usedWords.insert(answer, at: 0)
//                            } else {
//                                showAlert.toggle()
//                                alertTitle = "Word not recognized"
//                                alertMessage =  "You can't just make them up, you know!"
//                            }
//                        } else {
//                            showAlert.toggle()
//                            alertTitle = "Word not possible"
//                            alertMessage = "You can't spell that word from '\(rootWord)'!"
//                        }
//                    } else {
//                        showAlert.toggle()
//                        alertTitle = "Word used already"
//                        alertMessage = "Be more original"
//                    }
//                } else {
//                    showAlert.toggle()
//                    alertTitle = "Main word"
//                    alertMessage = "You should write new word"
//                }
//            } else {
//                showAlert.toggle()
//                alertTitle = "Word is too short"
//                alertMessage = "Write a word with more then 2 letters"
//            }

            /// GUARD
//            guard isOriginal(word: answer) else {
//                showAlert.toggle()
//                alertTitle = "Word used already"
//                alertMessage = "Be more original"
//                return
//            }
//            
//            guard isPossible(word: answer) else {
//                showAlert.toggle()
//                alertTitle = "Word not possible"
//                alertMessage = "You can't spell that word from '\(rootWord)'!"
//                return
//            }
//            
//            guard isReal(word: answer) else {
//                showAlert.toggle()
//                alertTitle = "Word not recognized"
//                alertMessage =  "You can't just make them up, you know!"
//                return
//            }
//            usedWords.insert(answer, at: 0)
        
            newWord = ""

        }
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                
            }
        } else {
            fatalError("Cannot load file")
        }
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
}



#Preview {
    ContentView()
}
