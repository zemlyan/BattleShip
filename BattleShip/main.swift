//
//  main.swift
//  BattleShip
//
//  Created by Alex on 03.05.18.
//  Copyright © 2018 Alex. All rights reserved.
//

import Foundation

typealias Move = (String, Int)

var horLineCount = 10
let alphabet = ["А", "Б", "В", "Г", "Д", "Е", "Ё", "Ж", "З", "И", "К", "Л", "М", "Н"]
var horLineString = String()
var coordinates = ["": Int()]
var signVar = ["  ", " *", " S", " X"]
var sign = signVar[0]
let ships = ["Ё": 3, "Д": 3, "Е": 3]

var moves = [Move]()

func printCmd() {

    print("Please enter command (type help for help): ")

    let line = readLine()
    var params = ""
    
    guard var cmd = line?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) else { return }
    
    if let match = findMatch(pattern: "(.*?) (.*)", in: cmd), match.count == 3 {
        cmd = match[1].lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        params = match[2].trimmingCharacters(in: .whitespacesAndNewlines)
    }

    switch cmd {
    case "help":
        printHelp()
    case "field":
        printField()
    case "shot":
        makeShot(params: params)
    case "moves":
        print(moves)
    case "quit":
        return
    default:
        print("Wrong command. Type help for help")
    }
    
    printCmd()
}

func makeShot(params: String) {
    guard
        let match = findMatch(pattern: "(\\w)(\\d+)", in: params), match.count == 3,
        let number = Int(match[2])
        else { return }
    
    let letter = match[1]
    let move = Move(letter, number)
    
    // TODO: не вносить дубликаты ходов
    // TODO: выводить сообщения о успешном внесении хода или о наличии хода в списке
    
    var hasDuplicate = false
    for m in moves {
        if m == move {
            hasDuplicate = true
            print("oh noooo. there is already this shot")
        }
    }
    
    if !hasDuplicate {
        print("adding...")
        moves.append(move)
    }
    
//    if moves.contains(where: { $0 == move }) { print("I'm sorry to say that, but you Olready added this item") }
//    else { print("Added") }
}

func printHelp() {
    print("List of commands:")
    print("- field: prints battleship field")
    print("- help: prints list of commands")
    print("- quit: quits the program")
}

func printField() {

    // legend
    print("\"", signVar[1], "\"", " - miss ")
    print("\"", signVar[2], "\"", " - ship")
    print("\"", signVar[3], "\"", " - hit")
    print()

    // draw first line
    for i in 0...horLineCount {
        switch i {
        case 0: print("    |", terminator: "")
        case horLineCount: print(" ", i, "|", separator: "")
        //    case i>(horLineCount-1): print(" ", i, "|", separator: "")
        default:
            if i > 9 {
                print(" ", i, "|", separator: "", terminator: "")
            } else {
                print("", i, "|", terminator: "")
            }
        }
    }
    // draw first underline
    for _ in 0...horLineCount {
        print("----", separator: "", terminator: "")
    }
    print("-")

    // draw horizontal cells
    for i in 0...horLineCount - 1 {
        print(" ", alphabet[i], "|", terminator: "")
        for p in 1...horLineCount {
            switch p {
            case horLineCount:
                if ships.keys.contains(alphabet[i]) && ships[alphabet[i]] == p {
                    sign = signVar[2]
                }else{
                    sign = signVar[0]
                }
                print(sign, "|")
                
            default:
                if ships.keys.contains(alphabet[i]) && ships[alphabet[i]] == p {
                    sign = signVar[2]
                }else{
                    sign = signVar[0]
                }
                print(sign, "|", terminator: "")
            }
        }
        for _ in 0...horLineCount {
            print("----", separator: "", terminator: "")
        }
        print("-")
    }
    
}

func findMatch(pattern: String, in content: String) -> [String]? {
    guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return nil }
    
    let matches = regex.matches(in: content, options: [], range: NSRange(location: 0, length: content.count))
    
    guard matches.count > 0 else { return nil }
    
    let match = matches[0]
    var foundMatch = [String]()
    for n in 0..<match.numberOfRanges {
        guard let r = Range<String.Index>(match.range(at: n), in: content) else { continue }
        let found = String(content[r])
        foundMatch.append(found.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    return foundMatch
}

printCmd()
