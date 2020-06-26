import Foundation

class TrieNode {
    
    var children: [TrieNode?]
    var isEndOfWord: Bool
    
    init() {
        isEndOfWord = false
        children = [TrieNode?](repeating: nil, count: Trie.alphabetNumber)
    }
    
}

class Trie {
    static let alphabetNumber = 26
    let root: TrieNode?
    
    init() {
        root = TrieNode()
    }
    
    func insert(key: String) {
        let keyLength = key.count
        var index: Int
        
        var currentNode: TrieNode = self.root!
        
        for i in 0...(keyLength - 1) {
            let keyCharacter = key[key.index(key.startIndex, offsetBy: i)]
            index = Int(keyCharacter.asciiValue! - 97)
            if currentNode.children[index] === nil {
                currentNode.children[index] = TrieNode()
            }
            currentNode = currentNode.children[index]!
        }
        currentNode.isEndOfWord = true
        
    }
    
    func search(key: String) -> Bool {
        var myRoot = self.root
        let keyLength = key.count
        var myCharacter: Character
        var myIndex: Int
        
        for i in 0...(keyLength - 1) {
            myCharacter = key[key.index(key.startIndex, offsetBy: i)]
            myIndex = Int(myCharacter.asciiValue! - 97)
            
            if myRoot!.children[myIndex] === nil {
                return false
            }
            myRoot = myRoot!.children[myIndex]
        }
        
        return (myRoot !== nil) && myRoot!.isEndOfWord
    }
    
}


func spotIsSafe(n: Int, m: Int, i: Int, j: Int, visitedTable: [[Bool]]) -> Bool {
    if (i < m && i >= 0 && j < n && j >= 0 && !visitedTable[i][j]) {
        return true
    }
    return false
}

func searchWord(root: TrieNode, table: [[String]], myString: String, i: Int, j: Int, visitedTable: inout [[Bool]], n: Int, m: Int, stringsFound: inout [String]) {
    if root.isEndOfWord {
        if !stringsFound.contains(myString) {
            stringsFound.append(myString)
            print(myString)
        }
    }
    
    if (spotIsSafe(n: n, m: m, i: i, j: j, visitedTable: visitedTable)) {
        visitedTable[i][j] = true
        
        for k in 0...25 {
            if root.children[k] !== nil {
                let myChar = String(Character(UnicodeScalar(k + 97)!))
                if spotIsSafe(n: n, m: m, i: i+1, j: j+1, visitedTable: visitedTable) && table[i+1][j+1] == myChar {
                    searchWord(root: root.children[k]!, table: table, myString: myString+String(myChar), i: i+1, j: j+1, visitedTable: &visitedTable, n: n, m: m, stringsFound: &stringsFound)
                }
                if spotIsSafe(n: n, m: m, i: i+1, j: j, visitedTable: visitedTable) && table[i+1][j] == myChar {
                    searchWord(root: root.children[k]!, table: table, myString: myString+String(myChar), i: i+1, j: j, visitedTable: &visitedTable, n: n, m: m, stringsFound: &stringsFound)
                }
                if spotIsSafe(n: n, m: m, i: i+1, j: j-1, visitedTable: visitedTable) && table[i+1][j-1] == myChar {
                    searchWord(root: root.children[k]!, table: table, myString: myString+String(myChar), i: i+1, j: j-1, visitedTable: &visitedTable, n: n, m: m, stringsFound: &stringsFound)
                }
                if spotIsSafe(n: n, m: m, i: i, j: j+1, visitedTable: visitedTable) && table[i][j+1] == myChar {
                    searchWord(root: root.children[k]!, table: table, myString: myString+String(myChar), i: i, j: j+1, visitedTable: &visitedTable, n: n, m: m, stringsFound: &stringsFound)
                }
                if spotIsSafe(n: n, m: m, i: i, j: j-1, visitedTable: visitedTable) && table[i][j-1] == myChar {
                    searchWord(root: root.children[k]!, table: table, myString: myString+String(myChar), i: i, j: j-1, visitedTable: &visitedTable, n: n, m: m, stringsFound: &stringsFound)
                }
                if spotIsSafe(n: n, m: m, i: i-1, j: j+1, visitedTable: visitedTable) && table[i-1][j+1] == myChar {
                    searchWord(root: root.children[k]!, table: table, myString: myString+String(myChar), i: i-1, j: j+1, visitedTable: &visitedTable, n: n, m: m, stringsFound: &stringsFound)
                }
                if spotIsSafe(n: n, m: m, i: i-1, j: j, visitedTable: visitedTable) && table[i-1][j] == myChar {
                    searchWord(root: root.children[k]!, table: table, myString: myString+String(myChar), i: i-1, j: j, visitedTable: &visitedTable, n: n, m: m, stringsFound: &stringsFound)
                }
                if spotIsSafe(n: n, m: m, i: i-1, j: j-1, visitedTable: visitedTable) && table[i-1][j-1] == myChar {
                    searchWord(root: root.children[k]!, table: table, myString: myString+String(myChar), i: i-1, j: j-1, visitedTable: &visitedTable, n: n, m: m, stringsFound: &stringsFound)
                }
                
            }
        }
        visitedTable[i][j] = false
        
    }
}

func findWordsInTable(table: [[String]], n: Int, m: Int, myTrie: Trie, stringsFound: inout [String]) {
    
    var visitedTable = Array(repeating: Array(repeating: false, count: n), count: m)
    var checkString = ""
    
    for i in 0...(m-1) {
        for j in 0...(n-1) {
            
            let index = Int((Character(table[i][j])).asciiValue! - 97)
            if myTrie.root?.children[index] !== nil {
                checkString += table[i][j]
                searchWord(root: (myTrie.root?.children[index])!, table: table, myString: checkString, i: i, j: j, visitedTable: &visitedTable, n: n, m: m, stringsFound: &stringsFound)
                checkString = ""
            }
        }
    }
    
    
}



let words = readLine()?
    .split {$0 == " "}
    .map (String.init)

let wordsArray = words!

let myTrie = Trie()

for word in wordsArray {
    myTrie.insert(key: word)
}

let numbers = readLine()?
    .split {$0 == " "}
    .map (String.init)

let m = Int(numbers![0])!
let n = Int(numbers![1])!

var table = [[String]]()
for _ in 1...m {
    let row = (readLine()?
        .split {$0 == " "}
        .map (String.init))!
    table.append(row)
}

var stringsFound = [String]()
findWordsInTable(table: table, n: n, m: m, myTrie: myTrie, stringsFound: &stringsFound)
