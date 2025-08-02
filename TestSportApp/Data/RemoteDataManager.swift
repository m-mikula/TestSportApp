//
//  RemoteDataManager.swift
//  TestSportApp
//
//  Created by Martin Mikula on 02/08/2025.
//

import FirebaseCore
import FirebaseFirestore

@MainActor final class RemoteDataManager {
    private let remoteDatabase = Firestore.firestore()
    private let sportActivitiesCollectionName = "sportActivities"
    
    func fetchAllSportActivities() async throws -> [SportActivity] {
        do {
            let snapshot = try await remoteDatabase.collection(sportActivitiesCollectionName).getDocuments()
            
            let sportActivities: [SportActivity] = try snapshot.documents.map { document in
                let firebaseSportActivity: FirebaseSportActivity = try document.data(as: FirebaseSportActivity.self)
               
                return SportActivity(from: firebaseSportActivity)
            }
            return sportActivities
        } catch {
            throw DataStorageManagerError.couldNotFetchRemoteData
        }
    }
    
    func saveSportActivity(sportActivity: SportActivity, isNewSportActivity: Bool = false) async throws {
        do {
            if isNewSportActivity {
                let collectionReference = remoteDatabase.collection(sportActivitiesCollectionName)
                
                try collectionReference.addDocument(from: sportActivity.firebaseSportActivity)
            } else if let documentID = sportActivity.firebaseDocumentID, !documentID.isEmpty {
                let docRef = remoteDatabase.collection(sportActivitiesCollectionName).document(documentID)
                    
                try docRef.setData(from: sportActivity.firebaseSportActivity)
            } else {
                throw DataStorageManagerError.remoteItemCouldNotBeSaved
            }
        } catch {
            throw DataStorageManagerError.remoteItemCouldNotBeSaved
        }
    }
    
    func deleteSportActivity(sportActivity: SportActivity) async throws {
        do {
            guard let documentID = sportActivity.firebaseDocumentID, !documentID.isEmpty else {
                throw DataStorageManagerError.remoteItemCouldNotBeDeleted
            }
            try await remoteDatabase.collection(sportActivitiesCollectionName).document(documentID).delete()
        } catch {
            throw DataStorageManagerError.remoteItemCouldNotBeDeleted
        }
    }
}
