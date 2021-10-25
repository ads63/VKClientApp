//
//  RealmService.swift
//  VKClientApp
//
//  Created by Алексей Шинкарев on 18.10.2021.
//

import Foundation
import RealmSwift

final class RealmService {
    static let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    func dropDB() {
        do {
            let realm = try Realm(configuration: RealmService.config)
            print(realm.configuration.fileURL)
            realm.beginWrite()
            realm.deleteAll()
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }

    func selectUsers() -> Results<User>? {
        var data: Results<User>?
        do {
            let realm = try Realm(configuration: RealmService.config)
            data = realm.objects(User.self)
        } catch {
            print(error)
        }
        return data
    }

    func insertUsers(users: [User], deleteOthers: Bool = true) {
        do {
            let realm = try Realm(configuration: RealmService.config)
            if deleteOthers {
                deleteUsersAll()
            }
            realm.beginWrite()
            realm.add(users, update: .all)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }

    func deleteUsers(users: [User]) {
        do {
            let realm = try Realm(configuration: RealmService.config)
            realm.beginWrite()
            realm.delete(users)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }

    func deleteUsersAll() {
        do {
            let realm = try Realm(configuration: RealmService.config)
            deleteUsers(users: [User](realm.objects(User.self)))
        } catch {
            print(error)
        }
    }

    func selectMyGroups() -> Results<Group>? {
        var data: Results<Group>?
        do {
            let realm = try Realm(configuration: RealmService.config)
            data = realm.objects(Group.self)
                .filter("memberValue == 1 OR adminValue == 1")
        } catch {
            print(error)
        }
        return data
    }

    func selectNotMineGroups() -> Results<Group>? {
        var data: Results<Group>?
        do {
            let realm = try Realm(configuration: RealmService.config)
            data = realm.objects(Group.self)
                .filter("memberValue == 0 AND adminValue == 0")
        } catch {
            print(error)
        }
        return data
    }

    func insertGroups(groups: [Group]) {
        do {
            let realm = try Realm(configuration: RealmService.config)
            realm.beginWrite()
            realm.add(groups, update: .all)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }

    func deleteGroup(groupID: Int) {
        do {
            let realm = try Realm(configuration: RealmService.config)
            realm.beginWrite()
            realm.delete(realm.objects(Group.self).filter("id == %@", groupID))
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }

    func deleteGroups(groups: [Group]) {
        do {
            let realm = try Realm(configuration: RealmService.config)
            realm.beginWrite()
            realm.delete(groups)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }

    func selectPhotos() -> Results<Photo>? {
        var photos: Results<Photo>?
        do {
            let realm = try Realm(configuration: RealmService.config)
            photos = realm.objects(Photo.self)
        } catch {
            print(error)
        }
        return photos
    }

    func insertPhotos(photos: [Photo]) {
        do {
            deletePhotosAll()
            let realm = try Realm(configuration: RealmService.config)
            realm.beginWrite()
            realm.add(photos, update: .all)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }

    func deletePhotos(photos: [Photo]) {
        do {
            let realm = try Realm(configuration: RealmService.config)
            realm.beginWrite()
            for photo in photos {
                realm.delete(photo.images)
            }
            realm.delete(photos)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }

    func deletePhotosAll() {
        do {
            let realm = try Realm(configuration: RealmService.config)
            deletePhotos(photos: [Photo](realm.objects(Photo.self)))
        } catch {
            print(error)
        }
    }
}
