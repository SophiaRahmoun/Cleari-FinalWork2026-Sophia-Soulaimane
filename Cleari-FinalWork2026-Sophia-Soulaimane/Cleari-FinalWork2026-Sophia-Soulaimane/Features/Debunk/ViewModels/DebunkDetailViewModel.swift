//
//  DebunkDetailViewModel.swift
//  Cleari-FinalWork2026-Sophia-Soulaimane
//
//  Created by Soulaimane Saadi on 23/05/2026.
//

import Foundation

@MainActor
final class DebunkDetailViewModel: ObservableObject {

    @Published var comments: [FakeTrendComment] = []

    @Published var commentText: String = ""

    @Published var isLoading = false

    func fetchComments(postId: Int) async {

        isLoading = true

        do {

            comments = try await DebunkService.shared.fetchComments(postId: postId)

        } catch {

            print("ERROR FETCHING COMMENTS:", error.localizedDescription)
        }

        isLoading = false
    }

    func sendComment(postId: Int) async {

        guard !commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }

        do {

            try await DebunkService.shared.createComment(
                postId: postId,
                content: commentText
            )

            commentText = ""

            await fetchComments(postId: postId)

        } catch {

            print("ERROR CREATING COMMENT:", error.localizedDescription)
        }
    }
}
