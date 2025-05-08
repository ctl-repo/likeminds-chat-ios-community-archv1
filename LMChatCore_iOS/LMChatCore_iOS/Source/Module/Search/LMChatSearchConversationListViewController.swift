//
//  LMChatSearchConversationListViewController.swift
//  Pods
//
//  Created by Anurag Tyagi on 01/02/25.
//

import LikeMindsChatUI

/// A view controller that displays a list of conversations and chatrooms as search results.
///
/// This view controller manages a table view to present search results and a search bar to let users query for conversations.
/// It handles the layout, appearance, and interactions of the search results, including pagination and analytics tracking.
public class LMChatSearchConversationListViewController: LMViewController {

    /**
     A model representing a section's content in the search result list.

     Each section may have an optional title and an array of items that conform to `LMChatSearchCellDataProtocol`.
     */
    public struct ContentModel {
        /// An optional title for the section.
        let title: String?
        /// An array of data items conforming to `LMChatSearchCellDataProtocol` for display in the section.
        let data: [LMChatSearchCellDataProtocol]

        /**
         Initializes a new instance of `ContentModel`.

         - Parameters:
            - title: An optional title for the section.
            - data: The list of data items for the section.
         */
        public init(title: String?, data: [LMChatSearchCellDataProtocol]) {
            self.title = title
            self.data = data
        }
    }

    /**
     The table view that displays search results.

     Configured with a grouped style, this table view registers a custom cell for displaying conversation messages,
     sets itself as the data source and delegate, and disables bouncing for a smoother experience.
     */
    open private(set) lazy var tableView: LMTableView = {
        let table = LMTableView(frame: .zero, style: .grouped)
            .translatesAutoresizingMaskIntoConstraints()
        table.register(LMUIComponents.shared.searchConversationMessageCell)
        table.dataSource = self
        table.delegate = self
        table.estimatedSectionHeaderHeight = .leastNonzeroMagnitude
        table.bounces = false
        return table
    }()

    /**
     The search controller used to manage and display the search bar.

     The search controller is set not to obscure the background and uses this view controller as the search bar delegate.
     */
    open private(set) lazy var searchController: UISearchController = {
        let search = UISearchController()
        search.searchBar.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        return search
    }()

    /// An array of search result content models for populating the table view.
    public var searchResults: [ContentModel] = []
    /// A timer used to debounce search input events.
    public var timer: Timer?
    /// The view model responsible for fetching and managing search conversation data.
    public var viewmodel: LMChatSearchConversationListViewModel?

    // MARK: - View Lifecycle Methods

    /**
     Sets up the view hierarchy.

     Adds the table view as a subview to the main view.
     */
    open override func setupViews() {
        super.setupViews()
        view.addSubview(tableView)
    }

    /**
     Configures the layout constraints for subviews.

     The table view is constrained to the safe area of the view with a top padding of 8 points.
     */
    open override func setupLayouts() {
        super.setupLayouts()
        tableView.addConstraint(
            top: (view.safeAreaLayoutGuide.topAnchor, 8),
            bottom: (view.safeAreaLayoutGuide.bottomAnchor, 0),
            leading: (view.safeAreaLayoutGuide.leadingAnchor, 0),
            trailing: (view.safeAreaLayoutGuide.trailingAnchor, 0))
    }

    /**
     Configures the visual appearance of the view.

     Sets background colors for the main view and table view using shared appearance settings.
     */
    open override func setupAppearance() {
        super.setupAppearance()
        view.backgroundColor = Appearance.shared.colors.white
        tableView.backgroundColor = Appearance.shared.colors.clear
    }

    /**
     Performs additional setup after the view is loaded.

     Configures the navigation item with the search controller and sets the search bar's text color.
     */
    open override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        let textFieldInsideSearchBar =
            searchController.searchBar.value(forKey: "searchField")
            as? UITextField
//        textFieldInsideSearchBar?.textColor = .black
    }

    /**
     Called after the view appears on the screen.

     Automatically focuses the search bar to prompt the user to begin searching.

     - Parameter animated: Indicates whether the appearance was animated.
     */
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }

    /**
     Called after the view disappears from the screen.

     Tracks an analytics event to indicate that the chatroom search was closed.

     - Parameter animated: Indicates whether the disappearance was animated.
     */
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        LMChatCore.analytics?.trackEvent(
            for: .chatroomSearchClosed, eventProperties: [:])
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension LMChatSearchConversationListViewController: UITableViewDataSource,
    UITableViewDelegate
{

    /**
     Returns the number of sections in the table view.

     - Parameter tableView: The table view requesting this information.
     - Returns: The number of sections, based on the count of search result content models.
     */
    open func numberOfSections(in tableView: UITableView) -> Int {
        searchResults.count
    }

    /**
     Returns the number of rows in a given section.

     - Parameters:
        - tableView: The table view requesting this information.
        - section: The index of the section.
     - Returns: The number of rows in the section, determined by the count of data items.
     */
    open func tableView(
        _ tableView: UITableView, numberOfRowsInSection section: Int
    ) -> Int {
        searchResults[section].data.count
    }

    /**
     Returns the cell for a given index path.

     Dequeues and configures a cell based on the search result data. If the cell data corresponds to a conversation message,
     the cell is configured accordingly. Otherwise, a default cell is returned.

     - Parameters:
        - tableView: The table view requesting the cell.
        - indexPath: The index path specifying the location of the cell.
     - Returns: A configured `UITableViewCell` instance.
     */
    open func tableView(
        _ tableView: UITableView, cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        if let data = searchResults[indexPath.section].data[indexPath.row]
            as? LMChatSearchConversationMessageCell.ContentModel,
            let cell = tableView.dequeueReusableCell(
                LMUIComponents.shared.searchConversationMessageCell)
        {
            cell.configure(with: data)
            return cell
        }
        return UITableViewCell()
    }

    /**
     Notifies when the table view scrolls.

     Resigns the first responder status from the search bar to dismiss the keyboard during scrolling.

     - Parameter scrollView: The scroll view instance that is scrolling.
     */
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }

    /**
     Returns the height for the header in a given section.

     Provides a height of 24 points if a section title exists; otherwise, returns a minimal height.

     - Parameters:
        - tableView: The table view requesting the header height.
        - section: The index of the section.
     - Returns: The height of the header view.
     */
    open func tableView(
        _ tableView: UITableView, heightForHeaderInSection section: Int
    ) -> CGFloat {
        searchResults[section].title != nil ? 24 : 0.001
    }

    /**
     Returns the height for the footer in a given section.

     The footer is effectively hidden by returning the least nonzero magnitude.

     - Parameters:
        - tableView: The table view requesting the footer height.
        - section: The index of the section.
     - Returns: The height of the footer view.
     */
    open func tableView(
        _ tableView: UITableView, heightForFooterInSection section: Int
    ) -> CGFloat {
        .leastNonzeroMagnitude
    }

    /**
     Notifies just before a cell is displayed.

     If the last cell of the last section is about to be displayed, a footer loader is shown and additional data is fetched.

     - Parameters:
        - tableView: The table view displaying the cell.
        - cell: The cell that will be displayed.
        - indexPath: The index path of the cell.
     */
    open func tableView(
        _ tableView: UITableView, willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.section == searchResults.count - 1,
            indexPath.row == searchResults[indexPath.section].data.count - 1
        {
            self.showHideFooterLoader(isShow: true)
            viewmodel?.fetchMoreData()
        }
    }

    /**
     Handles the selection of a row in the table view.

     Depending on whether a chatroom or a conversation message cell is selected, this method tracks the relevant
     analytics event and navigates to the appropriate chatroom view.

     - Parameters:
        - tableView: The table view in which the selection occurred.
        - indexPath: The index path of the selected row.
     */
    open func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
    ) {
        if let cell = searchResults[indexPath.section].data[indexPath.row]
            as? LMChatSearchChatroomCell.ContentModel
        {
            LMChatCore.analytics?.trackEvent(
                for: .chatroomSearched,
                eventProperties: viewmodel?.trackEventBasicParams(
                    chatroomId: cell.chatroomID) ?? [:])
            NavigationScreen.shared.perform(
                .chatroom(chatroomId: cell.chatroomID, conversationID: nil),
                from: self, params: nil)
        } else if let cell = searchResults[indexPath.section].data[
            indexPath.row]
            as? LMChatSearchConversationMessageCell.ContentModel
        {
            LMChatCore.analytics?.trackEvent(
                for: .messageSearched,
                eventProperties: viewmodel?.trackEventBasicParams(
                    chatroomId: cell.chatroomID) ?? [:])
            NavigationScreen.shared.perform(
                .chatroom(
                    chatroomId: cell.chatroomID, conversationID: cell.messageID),
                from: self, params: nil)
        }
    }

    /**
     Called just before a header view is displayed.

     Sets the text color of the header's text label.

     - Parameters:
        - tableView: The table view displaying the header view.
        - view: The header view that is about to be displayed.
        - section: The index of the section.
     */
    open func tableView(
        _ tableView: UITableView, willDisplayHeaderView view: UIView,
        forSection section: Int
    ) {
        (view as? UITableViewHeaderFooterView)?.textLabel?.textColor = .black
    }
}

// MARK: - UISearchBarDelegate

extension LMChatSearchConversationListViewController: UISearchBarDelegate {

    /**
     Called when the text in the search bar changes.

     Trims the input text and, if non-empty, resets the search results and displays a shimmer loading view.
     A debounce timer is then scheduled to perform the search after a short delay.

     - Parameters:
        - searchBar: The search bar where the text changed.
        - searchText: The current text entered in the search bar.
     */
    open func searchBar(
        _ searchBar: UISearchBar, textDidChange searchText: String
    ) {
        guard
            let text = searchBar.text?.trimmingCharacters(
                in: .whitespacesAndNewlines),
            !text.isEmpty
        else {
            resetSearchData()
            return
        }

        searchResults.removeAll(keepingCapacity: true)
        tableView.reloadData()
        tableView.backgroundView = LMChatSearchShimmerView(
            frame: tableView.bounds)

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) {
            [weak self] _ in
            self?.viewmodel?.searchList(with: text)
        }
    }

    /**
     Called when the cancel button on the search bar is clicked.

     Tracks an analytics event for the cancel action and resets the search data.

     - Parameter searchBar: The search bar that triggered the cancel action.
     */
    open func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        LMChatCore.analytics?.trackEvent(
            for: .searchCrossIconClicked,
            eventProperties: [
                LMChatAnalyticsKeys.source.rawValue: LMChatAnalyticsSource
                    .homeFeed.rawValue
            ])
        resetSearchData()
    }

    /**
     Resets the search data to its initial state.

     This method invalidates any running timers, clears the search results, removes any background views from the table view,
     and reloads the table view.
     */
    public func resetSearchData() {
        timer?.invalidate()
        viewmodel?.searchList(with: "")
        searchResults.removeAll(keepingCapacity: true)
        tableView.backgroundView = nil
        tableView.reloadData()
    }
}

// MARK: - LMChatSearchConversationListViewProtocol

extension LMChatSearchConversationListViewController:
    LMChatSearchConversationListViewProtocol
{

    /**
     Updates the search list with new data.

     If no results are found, a "no result" view is displayed in the table view's background.
     The footer loader is hidden and the table view is reloaded with the new data.

     - Parameter data: An array of `ContentModel` instances representing the updated search results.
     */
    public func updateSearchList(with data: [ContentModel]) {
        tableView.backgroundView =
            data.isEmpty ? LMChatNoResultView(frame: tableView.bounds) : nil
        showHideFooterLoader(isShow: false)
        self.searchResults = data
        tableView.reloadData()
    }

    /**
     Shows or hides the footer loader in the table view.

     - Parameter isShow: A Boolean value indicating whether to show (`true`) or hide (`false`) the footer loader.
     */
    public func showHideFooterLoader(isShow: Bool) {
        tableView.showHideFooterLoader(isShow: isShow)
    }
}
