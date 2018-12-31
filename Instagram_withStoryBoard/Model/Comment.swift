import Foundation

class Comments {
    var comment: String?
    var uid: String?
}

extension Comments {
    static func transformComments(dictionary: NSDictionary) -> Comments {
        let comment = Comments()
        comment.comment = dictionary["comment"] as? String
        comment.uid = dictionary["uid"] as? String
        return comment
    }
}
