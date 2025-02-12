//
//  LMChatHomeFeedListView.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 09/02/24.
//

import UIKit

protocol BaseContentModel {}

/// A delegate protocol for handling user interactions and scroll events on the home feed list view.
///
/// Implementers of this protocol are expected to respond to events such as cell taps, scroll events, and
/// requests to fetch more data (e.g., for pagination). In addition, the protocol provides optional methods
/// to handle secret chatroom invite actions. Default (empty) implementations are provided so that conforming
/// types can choose to override only the methods they need.
///
/// Methods:
/// - didTapOnCell(indexPath:): Called when a cell is tapped.
/// - fetchMoreData(): Called when more data should be loaded (e.g., when scrolling to the bottom).
/// - scrollViewDidEndDragging(_:willDecelerate:): Called when the user stops dragging the scroll view.
/// - scrollViewDidScroll(_:): Called continuously as the user scrolls.
/// - didAcceptSecretChatroomInvite(data:): Called when a secret chatroom invite is accepted.
/// - didRejectSecretChatroomInvite(data:): Called when a secret chatroom invite is rejected.
public protocol LMHomFeedListViewDelegate: AnyObject {
    /**
     Called when a cell at the specified index path is tapped.

     - Parameter indexPath: The index path of the tapped cell.
     */
    func didTapOnCell(indexPath: IndexPath)

    /**
     Called when more data should be fetched, typically used for pagination.
     */
    func fetchMoreData()

    /**
     Called when the scroll view ends dragging.

     - Parameters:
       - scrollView: The scroll view that ended dragging.
       - decelerate: A Boolean indicating whether the scroll view will continue to decelerate.
     */
    func scrollViewDidEndDragging(
        _ scrollView: UIScrollView, willDecelerate decelerate: Bool)

    /**
     Called continuously as the scroll view is scrolled.

     - Parameter scrollView: The scroll view that is scrolling.
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView)

    /**
     Default implementation for handling acceptance of a secret chatroom invite.

     - Parameter data: The content model associated with the secret chatroom invite.
     */
    func didAcceptSecretChatroomInvite(
        data: LMChatHomeFeedSecretChatroomInviteCell.ContentModel
    )

    /**
     Default implementation for handling rejection of a secret chatroom invite.

     - Parameter data: The content model associated with the secret chatroom invite.
     */
    func didRejectSecretChatroomInvite(
        data: LMChatHomeFeedSecretChatroomInviteCell.ContentModel
    )
}

extension LMHomFeedListViewDelegate {
    /**
     Default implementation for handling cell tap events.

     - Parameter indexPath: The index path of the tapped cell.
     */
    public func didTapOnCell(indexPath: IndexPath) {}

    /**
     Default implementation for fetching more data.
     */
    public func fetchMoreData() {}

    /**
     Default implementation for handling the end of dragging events in the scroll view.

     - Parameters:
       - scrollView: The scroll view that ended dragging.
       - decelerate: A Boolean indicating whether the scroll view will continue to decelerate.
     */
    public func scrollViewDidEndDragging(
        _ scrollView: UIScrollView, willDecelerate decelerate: Bool
    ) {}

    /**
     Default implementation for handling scrolling events.

     - Parameter scrollView: The scroll view that is scrolling.
     */
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {}
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
extension LMChatHomeFeedListView: UITableViewDataSource, UITableViewDelegate,
    LMChatHomeFeedSecretChatroomInviteCellDelegate
{

    /**
     Called when the accept button is tapped within a secret chatroom invite cell.

     This method forwards the event to the delegate by calling `didAcceptSecretChatroomInvite(data:)`.

     - Parameter data: The content model representing the secret chatroom invite cell.
     */
    public func didTapAcceptButton(
        in data: LMChatHomeFeedSecretChatroomInviteCell.ContentModel
    ) {
        self.delegate?.didAcceptSecretChatroomInvite(data: data)
    }

    /**
     Called when the reject button is tapped within a secret chatroom invite cell.

     This method forwards the event to the delegate by calling `didRejectSecretChatroomInvite(data:)`.

     - Parameter data: The content model representing the secret chatroom invite cell.
     */
    public func didTapRejectButton(
        in data: LMChatHomeFeedSecretChatroomInviteCell.ContentModel
    ) {
        self.delegate?.didRejectSecretChatroomInvite(data: data)
    }

    open func numberOfSections(in tableView: UITableView) -> Int {
        tableSections.count
    }

    open func tableView(
        _ tableView: UITableView, numberOfRowsInSection section: Int
    ) -> Int {
        tableSections[section].data.count
    }

    /**
     Returns the configured table view cell for the specified index path.

     This method determines which type of cell to dequeue and configure based on the section type of the
     `tableSections` array. There are three supported section types:

     - **.exploreTab**: Dequeues a cell for exploring the home feed. It casts the corresponding data item
       to a `LMChatHomeFeedExploreTabCell.ContentModel`, configures the cell, and returns it.

     - **.secretChatroomInvite**: Dequeues a cell for secret chatroom invites. It casts the corresponding data item
       to a `LMChatHomeFeedSecretChatroomInviteCell.ContentModel`, configures the cell, assigns its delegate, and returns it.

     - **.chatrooms**: Dequeues a cell for chatrooms. It casts the corresponding data item to a
       `LMChatHomeFeedChatroomCell.ContentModel`, configures the cell, and triggers fetching of more data
       if the current row is near the end of the list (last 4 items). Then it returns the cell.

     If no cell can be dequeued or configured, a default `UITableViewCell` is returned.

     - Parameters:
        - tableView: The `UITableView` requesting the cell.
        - indexPath: The `IndexPath` indicating the row and section of the cell.
     - Returns: A configured `UITableViewCell` instance ready for display.
     */
    open func tableView(
        _ tableView: UITableView, cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        // Retrieve the list of items for the given section.
        let items = tableSections[indexPath.section].data

        // Switch based on the section type to determine which cell to dequeue and configure.
        switch tableSections[indexPath.section].sectionType {

        case .exploreTab:
            // Attempt to cast the item at the specified row to the explore tab content model and dequeue the appropriate cell.
            if let item = items[indexPath.row]
                as? LMChatHomeFeedExploreTabCell.ContentModel,
                let cell = tableView.dequeueReusableCell(
                    LMUIComponents.shared.homeFeedExploreTabCell)
            {
                cell.configure(with: item)
                return cell
            }

        case .secretChatroomInvite:
            // Attempt to cast the item at the specified row to the secret chatroom invite content model and dequeue the appropriate cell.
            if let item = items[indexPath.row]
                as? LMChatHomeFeedSecretChatroomInviteCell.ContentModel,
                let cell = tableView.dequeueReusableCell(
                    LMUIComponents.shared.homeFeedSecretChatroomInviteCell)
            {
                cell.configure(with: item, delegate: self)
                return cell
            }

        case .chatrooms:
            // Attempt to cast the item at the specified row to the chatroom content model and dequeue the appropriate cell.
            if let item = items[indexPath.row]
                as? LMChatHomeFeedChatroomCell.ContentModel,
                let cell = tableView.dequeueReusableCell(
                    LMUIComponents.shared.homeFeedChatroomCell)
            {
                cell.configure(with: item)
                // Trigger fetching more data if the user is nearing the end of the current list (last 4 items).
                if indexPath.row >= (items.count - 4) {
                    self.delegate?.fetchMoreData()
                }
                return cell
            }
        }

        // Return an empty UITableViewCell if no cell could be dequeued or configured.
        return UITableViewCell()
    }

    open func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
    ) {
        switch tableSections[indexPath.section].sectionType {
        case .secretChatroomInvite:
            // In case the tapped cell is a secret chatroom invite
            // Do nothing
            return
        default:
            // Call the didTapOnCell method to call the respective action
            // for that cell
            self.delegate?.didTapOnCell(indexPath: indexPath)
        }
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
