
import Foundation

struct SearchModel : Codable {
	let count : Int?
	let from : Int?
	let hits : [Hit]?
	let more : Bool?
	let q : String?
	let to : Int?
}
