import Foundation
struct Recipe : Codable {

	let healthLabels : [String]?
	let image : String?
	let ingredientLines : [String]?
	let label : String?
	let shareAs : String?
	let source : String?
	let uri : String?
	let url : String?
	let yield : Float?
}
