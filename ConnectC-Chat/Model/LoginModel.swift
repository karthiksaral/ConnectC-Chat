//
//  LoginModel.swift
//  ConnectC-Chat
//
//  Created by Karthikeyan Anbu on 24/04/22.
//

import Foundation

//    let responseModel = try jsonDecoder.decode(LoginModel.self, from: data!)



struct LoginModel : Codable {
    let status: Int
        let message: String
        let data: Data
        let jwtToken: String

        enum CodingKeys: String, CodingKey {
            case status, message, data
            case jwtToken = "jwt_token"
        }

}

struct Ec_post : Codable {
    let id: Int
        let ecPostableType: String
        let ecPostableID: Int
        let code: String
        let clientName: JSONNull?
        let jobTitle: String
        let industryID: JSONNull?
        let designationID, noticePeriod: Int
        let academicQualificationID: String
        let certification: JSONNull?
        let salaryMinimum, salaryMaximum, experienceMinimum, experienceMaximum: Int
        let levelOfInterview: JSONNull?
        let jobLocation, employeeType: Int
        let cityIDS: [Int]
        let jobDecription, jobCode: String
        let numOfPositions: JSONNull?
        let autoFeedbackStatus: Int
        let skillPercentage, npPercentage, experiencePercentage, ctcPercentage: String
        let locationPercentage: JSONNull?
        let status: Int
        let createdAt, updatedAt: String
        let deletedAt: JSONNull?

        enum CodingKeys: String, CodingKey {
            case id
            case ecPostableType = "ec_postable_type"
            case ecPostableID = "ec_postable_id"
            case code
            case clientName = "client_name"
            case jobTitle = "job_title"
            case industryID = "industry_id"
            case designationID = "designation_id"
            case noticePeriod = "notice_period"
            case academicQualificationID = "academic_qualification_id"
            case certification
            case salaryMinimum = "salary_minimum"
            case salaryMaximum = "salary_maximum"
            case experienceMinimum = "experience_minimum"
            case experienceMaximum = "experience_maximum"
            case levelOfInterview = "level_of_interview"
            case jobLocation = "job_location"
            case employeeType = "employee_type"
            case cityIDS = "city_ids"
            case jobDecription = "job_decription"
            case jobCode = "job_code"
            case numOfPositions = "num_of_positions"
            case autoFeedbackStatus = "auto_feedback_status"
            case skillPercentage = "skill_percentage"
            case npPercentage = "np_percentage"
            case experiencePercentage = "experience_percentage"
            case ctcPercentage = "ctc_percentage"
            case locationPercentage = "location_percentage"
            case status
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case deletedAt = "deleted_at"
        }

}

struct Data : Codable {
    let userType, id: Int
       let code, name, email, mobile: String
       let dob: String
       let resume: String
       let profileImage: String
       let fcmToken: String
       let status, points, score, scores: Int
       let congratulatedOrNot, badge, position, positions: Int
       let signUpLevel: Int
       let designation: String
       let lastAppliedJob: Last_applied_job
       let scoreHistories: [Score_histories]

       enum CodingKeys: String, CodingKey {
           case userType = "user_type"
           case id, code, name, email, mobile, dob, resume
           case profileImage = "profile_image"
           case fcmToken = "fcm_token"
           case status, points, score, scores
           case congratulatedOrNot = "congratulated_or_not"
           case badge, position, positions
           case signUpLevel = "sign_up_level"
           case designation
           case lastAppliedJob = "last_applied_job"
           case scoreHistories = "score_histories"
       }

}

struct Score_histories : Codable {
    let id: Int
        let code: String
        let scoreableID: Int
        let scoreableType: String
        let points, year, score: Int

        enum CodingKeys: String, CodingKey {
            case id, code
            case scoreableID = "scoreable_id"
            case scoreableType = "scoreable_type"
            case points, year, score
        }

}

struct Last_applied_job : Codable {
    let ecPost: Ec_post
        let jobStatus: Int

        enum CodingKeys: String, CodingKey {
            case ecPost = "ec_post"
            case jobStatus = "job_status"
        }

}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
