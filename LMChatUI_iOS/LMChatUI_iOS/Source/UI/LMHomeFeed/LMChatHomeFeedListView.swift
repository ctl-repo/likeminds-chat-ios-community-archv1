//
//  LMChatHomeFeedListView.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 09/02/24.
//

import UIKit

protocol BaseContentModel {}

public protocol LMHomFeedListViewDelegate: AnyObject {
    func didTapOnCell(indexPath: IndexPath)
    func fetchMoreData()
    func scrollViewDidEndDragging(
        _ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    func scrollViewDidScroll(_ scrollView: UIScrollView)
}

extension LMHomFeedListViewDelegate {
    public func didTapOnCell(indexPath: IndexPath) {}
    public func fetchMoreData() {}
    public func scrollViewDidEndDragging(
        _ scrollView: UIScrollView, willDecelerate decelerate: Bool
    ) {}
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {}
    public func didAcceptSecretChatroomInvite(
        data: LMChatHomeFeedSecretChatroomInviteCell.ContentModel
    ) {}
    public func didRejectSecretChatroomInvite(
        data: LMChatHomeFeedSecretChatroomInviteCell.ContentModel
    ) {}
}

public enum HomeFeedSection: String {
    case exploreTab = "Explore Tab"
    case secretChatroomInvite = "Secret Chatroom Invite"
    case chatrooms = "Chatrooms"
}

@IBDesignable
open class LMChatHomeFeedListView: LMView {

    public struct ContentModel {
        public let data: [Any]
        public let sectionType: HomeFeedSection
        public let sectionOrder: Int

        init(data: [Any], sectionType: HomeFeedSection, sectionOrder: Int) {
            self.data = data
            self.sectionType = sectionType
            self.sectionOrder = sectionOrder
        }
    }

    // MARK: UI Elements
    open private(set) lazy var containerView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        return view
    }()

    open private(set) lazy var loadingView: LMChatHomeFeedShimmerView = {
        let view = LMUIComponents.shared.homeFeedShimmerView.init()
            .translatesAutoresizingMaskIntoConstraints()
        view.setWidthConstraint(with: UIScreen.main.bounds.size.width)
        return view
    }()

    open private(set) lazy var noResultFoundView: LMChatNoResultView = {
        let view = LMChatNoResultView(frame: UIScreen.main.bounds)
            .translatesAutoresizingMaskIntoConstraints()
        view.placeholderText.text = "It's time to participate"
        return view
    }()

    open private(set) lazy var tableView: LMTableView = {
        let table = LMTableView().translatesAutoresizingMaskIntoConstraints()
        table.register(LMUIComponents.shared.homeFeedChatroomCell)
        table.register(LMUIComponents.shared.homeFeedExploreTabCell)
        table.register(LMUIComponents.shared.homeFeedSecretChatroomInviteCell)
        table.dataSource = self
        table.delegate = self
        table.showsVerticalScrollIndicator = false
        table.clipsToBounds = true
        table.separatorStyle = .none
        return table
    }()

    // MARK: Data Variables
    public let cellHeight: CGFloat = 60
    private var data: [LMChatHomeFeedChatroomCell.ContentModel] = []
    public weak var delegate: LMHomFeedListViewDelegate?
    public var tableSections: [ContentModel] = []

    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        addSubview(containerView)
        containerView.addSubview(tableView)
        tableView.backgroundView = loadingView
    }

    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        pinSubView(subView: containerView)
        containerView.pinSubView(subView: tableView)
    }

    // MARK: setupAppearance
    open override func setupAppearance() {
        super.setupAppearance()
        backgroundColor = Appearance.shared.colors.clear
        containerView.backgroundColor = Appearance.shared.colors.white
        tableView.backgroundColor = Appearance.shared.colors.clear
    }

    open func reloadData() {
        tableSections.sort(by: { $0.sectionOrder < $1.sectionOrder })
        self.tableView.reloadData()
    }

    public func updateChatroomsData(
        chatroomData: [LMChatHomeFeedChatroomCell.ContentModel]
    ) {
        if let index = tableSections.firstIndex(where: {
            $0.sectionType == .chatrooms
        }) {
            tableSections[index] = .init(
                data: chatroomData, sectionType: .chatrooms, sectionOrder: 1)
        } else {
            if !chatroomData.isEmpty {
                tableSections.append(
                    .init(
                        data: chatroomData, sectionType: .chatrooms,
                        sectionOrder: 1))
            }
        }
        if chatroomData.isEmpty {
            let view = LMChatNoResultView(frame: tableView.bounds)
            view.placeholderText.text = "It's time to participate"
            tableView.backgroundView = view
        } else {
            tableView.backgroundView = nil
        }
        reloadData()
    }

    // MARK: - Explore Tab

    /**
         Updates the explore tab count section with the given content model.

         This function checks if an existing `.exploreTab` section already exists in
         `tableSections`. If it does, it updates that section’s data. If not, it will
         insert a new `.exploreTab` section in the correct order:
         1. Before `secretChatroomInvite` if it exists.
         2. If no `secretChatroomInvite` is found, before `chatrooms`.
         3. If neither exist, it appends the new section to the end.

         - Parameter exploreTabCount: The content model for the Explore tab section.
         */
    public func updateExploreTabCount(
        exploreTabCount: LMChatHomeFeedExploreTabCell.ContentModel
    ) {
        // 1. Attempt to find an existing `.exploreTab` section.
        if let index = tableSections.firstIndex(where: {
            $0.sectionType == .exploreTab
        }) {
            // If found, update the existing section with the new data and order.
            tableSections[index] = .init(
                data: [exploreTabCount],
                sectionType: .exploreTab,
                sectionOrder: 1
            )
        } else {
            // If `.exploreTab` doesn't exist yet, find where to insert it:

            // 2. Check if a `.secretChatroomInvite` section exists.
            if let indexOfSecretChatroomInvites = tableSections.firstIndex(
                where: {
                    $0.sectionType == .secretChatroomInvite
                }), indexOfSecretChatroomInvites != -1
            {
                // Insert `.exploreTab` before `.secretChatroomInvite`.
                tableSections.insert(
                    .init(
                        data: [exploreTabCount],
                        sectionType: .exploreTab,
                        sectionOrder: 1
                    ),
                    at: indexOfSecretChatroomInvites
                )
            }
            // 3. If `.secretChatroomInvite` wasn’t found,
            //    check if `.chatrooms` is present.
            else if let indexOfChatrooms = tableSections.firstIndex(where: {
                $0.sectionType == .chatrooms
            }), indexOfChatrooms != -1 {
                // Insert `.exploreTab` before `.chatrooms`.
                tableSections.insert(
                    .init(
                        data: [exploreTabCount],
                        sectionType: .exploreTab,
                        sectionOrder: 1
                    ),
                    at: indexOfChatrooms
                )
            } else {
                // 4. If neither `secretChatroomInvite` nor `chatrooms` are found,
                //    simply append the new `.exploreTab` section at the end.
                tableSections.append(
                    .init(
                        data: [exploreTabCount],
                        sectionType: .exploreTab,
                        sectionOrder: 1
                    )
                )
            }
        }

        // 5. Finally, reload data to reflect the updated sections in the UI.
        reloadData()
    }

    // MARK: - Secret Chatroom Invites

    /**
         Updates or inserts the `.secretChatroomInvite` section with the given array
         of content models.

         If a `.secretChatroomInvite` section already exists, this function updates it
         with the new data. Otherwise, it inserts it in front of the `.chatrooms` section
         if present, or appends it to the end if `.chatrooms` is not found.

         - Parameter secretChatroomInvites: An array of invite data for the secret chatrooms.
         */
    public func updateSecretChatroomInviteCell(
        secretChatroomInvites: [LMChatHomeFeedSecretChatroomInviteCell
            .ContentModel]
    ) {
        // Create a ContentModel for the secret chatroom invites.
        let content: ContentModel = .init(
            data: secretChatroomInvites,
            sectionType: .secretChatroomInvite,
            sectionOrder: 1
        )

        // 1. Look for an existing `.secretChatroomInvite` section.
        if let index = tableSections.firstIndex(where: {
            $0.sectionType == .secretChatroomInvite
        }) {
            // If found, replace it with the updated content.
            tableSections[index] = content
        } else {
            // If not found, check where to insert it:

            // 2. Look for `.chatrooms`.
            if let indexOfChatrooms = tableSections.firstIndex(where: {
                $0.sectionType == .chatrooms
            }), indexOfChatrooms != -1 {
                // Insert `.secretChatroomInvite` before `.chatrooms`.
                tableSections.insert(content, at: indexOfChatrooms)
            } else {
                // 3. If `.chatrooms` is not found, append to the end.
                tableSections.append(content)
            }
        }

        // 4. Reload the data to update the UI with the new or updated section.
        reloadData()
    }

}

// MARK: UITableView
extension LMChatHomeFeedListView: UITableViewDataSource, UITableViewDelegate {

    open func numberOfSections(in tableView: UITableView) -> Int {
        tableSections.count
    }

    open func tableView(
        _ tableView: UITableView, numberOfRowsInSection section: Int
    ) -> Int {
        tableSections[section].data.count
    }

    open func tableView(
        _ tableView: UITableView, cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let items = tableSections[indexPath.section].data

        switch tableSections[indexPath.section].sectionType {
        case .exploreTab:
            if let item = items[indexPath.row]
                as? LMChatHomeFeedExploreTabCell.ContentModel,
                let cell = tableView.dequeueReusableCell(
                    LMUIComponents.shared.homeFeedExploreTabCell)
            {
                cell.configure(with: item)
                return cell
            }
        case .secretChatroomInvite:
            if let item = items[indexPath.row]
                as? LMChatHomeFeedSecretChatroomInviteCell.ContentModel,
                let cell = tableView.dequeueReusableCell(
                    LMUIComponents.shared.homeFeedSecretChatroomInviteCell)
            {
                cell.configure(with: item)
                cell.delegate = self
                return cell
            }
        case .chatrooms:
            if let item = items[indexPath.row]
                as? LMChatHomeFeedChatroomCell.ContentModel,
                let cell = tableView.dequeueReusableCell(
                    LMUIComponents.shared.homeFeedChatroomCell)
            {
                cell.configure(with: item)
                if indexPath.row >= (items.count - 4) {
                    self.delegate?.fetchMoreData()
                }
                return cell
            }
        }
        return UITableViewCell()
    }

    open func tableView(
        _ tableView: UITableView, willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
    }

    open func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
    ) {
        self.delegate?.didTapOnCell(indexPath: indexPath)
    }

    public func scrollViewDidEndDragging(
        _ scrollView: UIScrollView, willDecelerate decelerate: Bool
    ) {
        self.delegate?.scrollViewDidEndDragging(
            scrollView, willDecelerate: decelerate)
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewDidScroll(scrollView)
    }
}

extension LMChatHomeFeedListView: LMChatHomeFeedSecretChatroomInviteCellDelegate
{
    func didTapAcceptButton(
        in data: LMChatHomeFeedSecretChatroomInviteCell.ContentModel
    ) {
        self.delegate?.didAcceptSecretChatroomInvite(data: data)
    }

    func didTapRejectButton(
        in data: LMChatHomeFeedSecretChatroomInviteCell.ContentModel
    ) {
        self.delegate?.didRejectSecretChatroomInvite(data: data)
    }
}
