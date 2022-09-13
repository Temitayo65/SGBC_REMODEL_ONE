//
//  Sermons.swift
//  SGBC_REMODEL
//
//  Created by ADMIN on 13/09/2022.
//

import Foundation

struct Sermons: Codable{
    let title: String
    let date_preached: String
    let pastor_id: String
    let audio_id: String
    let video_id: String?
    let created_at: String
    let updated_at: String
    let slug: String
    let image_id: String?
    let period_of_day: String?
    let sermonAudio: SermonAudio
    let sermonPastor: SermonPastor
    let sermonImage: SermonImage?
    let sermonVideo: SermonVideo?
}

struct SermonAudio: Codable{
    let id: String
    let audio_url: String
    let pastor_id: String
    let created_at: String
    let updated_at: String
    let file_name: String
    let last_updated: String
    let is_deleted: Bool
    
}

struct SermonImage: Codable{
    let id: String
    let image_url: String?
    let sermon_id: String?
    let file_name: String?
    let last_updated: String?
    let is_deleted: Bool?
    let created_at: String?
    let updated_at: String?
}

struct SermonVideo:Codable{
    let id: String
    let video_url: String?
    let pastor_id: String?
    let created_at: String?
    let updated_at: String?
    let file_name: String?
    let last_updated: String?
    let is_deleted: Bool?
    
}

struct SermonPastor: Codable{
    let id: String
    let first_name: String
    let last_name: String
    let created_at: String
    let updated_at: String

}
