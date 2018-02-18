//: Playground - noun: a place where people can play

import UIKit

// MARK: - Decode

// MARK: plist
struct Person: Codable {
    let name: String
    let age: Int
}

extension Person {

    static func makePerson() -> Person {
        guard
            let url = Bundle.main.url(forResource: "person", withExtension: "plist"),
            let data = try? Data(contentsOf: url) else {
                fatalError("unwrap failed")
        }

        let decoder = PropertyListDecoder()
        do {
            let person = try decoder.decode(Person.self, from: data)
            return person
        } catch {
            print("plist decode failed", error.localizedDescription)
            fatalError()
        }
    }
}

let person = Person.makePerson()
print(person)

// MARK: plist（配列）
struct Prefecture: Codable {
    let code: String
    let name: String
}

extension Prefecture {

    static func makePrefectures() -> [Prefecture] {
        guard
            let url = Bundle.main.url(forResource: "prefectures", withExtension: "plist"),
            let data = try? Data(contentsOf: url) else {
                fatalError("unwrap failed")
        }

        let decoder = PropertyListDecoder()
        do {
            let prefectures = try decoder.decode([Prefecture].self, from: data)
            return prefectures
        } catch {
            print("plist decode failed", error.localizedDescription)
            fatalError()
        }
    }
}

let prefectures = Prefecture.makePrefectures()
prefectures.forEach { print($0) }

// MARK: json
struct Child: Codable {
    let name: String
    let age: Double
    let parents: Parents

    // ネストも可能
    struct Parents: Codable {
        let father: String
        let mother: String
    }
}

extension Child {

    static func makeChild() -> Child {
        guard
            let url = Bundle.main.url(forResource: "child", withExtension: "json"),
            let data = try? Data(contentsOf: url) else {
                fatalError("unwrap failed")
        }

        let decoder = JSONDecoder()
        do {
            let child = try decoder.decode(Child.self, from: data)
            return child
        } catch {
            print("json decode failed", error.localizedDescription)
            fatalError()
        }
    }
}

let child = Child.makeChild()
print(child)

// MARK: json（配列）
struct City: Codable {
    let cityCode: Int
    let name: String
    let url: URL


    /// キーとプロパティ名が一致しない場合はCodingKeyを利用する
    /// - case名: プロパティ名
    /// - rawValue: キー名
    ///
    /// - cityCode: プロパティ: キャメルケース, キー: スネークケース
    /// - name: 一致しているのでrawValueの定義不要
    /// - url: 一致しているのでrawValueの定義不要
    private enum CodingKeys: String, CodingKey {
        case cityCode = "city_code"
        case name
        case url
    }
}

extension City {

    static func makeCities() -> [City] {
        guard
            let url = Bundle.main.url(forResource: "cities", withExtension: "json"),
            let data = try? Data(contentsOf: url) else {
                fatalError("unwrap failed")
        }

        let decoder = JSONDecoder()
        do {
            let cities = try decoder.decode([City].self, from: data)
            return cities
        } catch {
            print("json decode failed", error.localizedDescription)
            fatalError()
        }
    }
}

let cities = City.makeCities()
cities.forEach { print($0) }

// MARK: - Encode

// MARK: plist
let encodePerson = Person(name: "名前", age: 20)

let plistEncoder = PropertyListEncoder()
// .xmlを指定するとxml形式に整形される
plistEncoder.outputFormat = .xml

let personData = try? plistEncoder.encode(encodePerson)
let personString = String(data: personData!, encoding: .utf8)
print(personString!)

// MARK: json
let parents = Child.Parents(father: "父", mother: "母")
let encodeChild = Child(name: "こども", age: 1.2, parents: parents)

let jsonEncoder = JSONEncoder()
// .prettyPrintedを指定すると読みやすい形に整形される
jsonEncoder.outputFormatting = .prettyPrinted
// .sortedKeysを指定するとキー順にソートされる
//jsonEncoder.outputFormatting = .sortedKeys

let jsonData = try? jsonEncoder.encode(encodeChild)
let jsonStirng = String(data: jsonData!, encoding: .utf8)
print(jsonStirng!)
