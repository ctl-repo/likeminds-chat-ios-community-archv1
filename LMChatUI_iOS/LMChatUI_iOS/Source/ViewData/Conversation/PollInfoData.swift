import Foundation

/// A view-data class that mirrors the properties of `PollInfoData` from Kotlin.
///
/// This class is mutable and can be used in UI layers or intermediate layers
/// where flexibility in modifying properties is required.
public class PollInfoData : LMBasePollView.Content {    
    // MARK: - Private Properties
    private var _question: String?
    private var _expiryDate: Date?
    private var _optionState: String?
    private var _optionCount: Int?
    
    // MARK: - Protocol Properties
    public var question: String {
        return _question ?? ""
    }
    
    public var expiryDate: Date {
        return _expiryDate ?? Date()
    }
    
    public var optionState: String {
        return _optionState ?? ""
    }
    
    public var optionCount: Int {
        return _optionCount ?? 0
    }
    
    public var expiryDateFormatted: String {
        let now = Date()
        
        guard let expiryDate = _expiryDate else {
            return "--"
        }
        
        guard expiryDate > now else {
            return "Poll Ended"
        }
        
        let components = Calendar.current.dateComponents(
            [.day, .hour, .minute], from: now, to: expiryDate)
        
        guard let days = components.day, let hours = components.hour,
            let minutes = components.minute
        else {
            return "Just Now"
        }
        
        switch (days, hours, minutes) {
        case (0, 0, let min) where min > 0:
            return "Ends in \(min) \(getPluralText(withNumber: min, text: "min"))"
        case (0, let hr, _) where hr >= 1:
            return "Ends in \(hr) \(getPluralText(withNumber: hr, text: "hour"))"
        case (let d, _, _) where d >= 1:
            return "Ends in \(d) \(getPluralText(withNumber: d, text: "day"))"
        default:
            return "Just Now"
        }
    }
    
    public var optionStringFormatted: String {
        "*Select \(optionState.lowercased()) \(optionCount) \(optionCount == 1 ? "option" : "options")"
    }
    
    public var isShowOption: Bool {
        !optionState.isEmpty && (optionCount != 0)
    }

    // MARK: - Properties
    public var isAnonymous: Bool?
    public var allowAddOption: Bool?
    public var pollType: Int?
    public var pollTypeText: String?
    public var submitTypeText: String?
    public var expiryTime: Int?
    public var multipleSelectNum: Int?
    public var multipleSelectState: Int?
    public var pollViewDataList: [PollViewData]?
    public var pollAnswerText: String?
    public var isPollSubmitted: Bool?
    public var toShowResult: Bool?

    // MARK: - Additional Properties from LMChatPollView.ContentModel
    public var chatroomId: String?
    public var messageId: String?
    public var options: [PollViewData]?
    public var isInstantPoll: Bool?
    public var isShowSubmitButton: Bool?
    public var isShowEditVote: Bool?
    public var enableSubmitButton: Bool?
    public var tempSelectedOptions: [String]?
    public var isEditingMode: Bool?

    // MARK: - Initializer
    private init(
        isAnonymous: Bool?,
        allowAddOption: Bool?,
        pollType: Int?,
        pollTypeText: String?,
        submitTypeText: String?,
        expiryTime: Int?,
        multipleSelectNum: Int?,
        multipleSelectState: Int?,
        pollViewDataList: [PollViewData]?,
        pollAnswerText: String?,
        isPollSubmitted: Bool?,
        toShowResult: Bool?,
        chatroomId: String?,
        messageId: String?,
        question: String?,
        options: [PollViewData]?,
        expiryDate: Date?,
        optionState: String?,
        optionCount: Int?,
        isInstantPoll: Bool?,
        isShowSubmitButton: Bool?,
        isShowEditVote: Bool?,
        enableSubmitButton: Bool?,
        tempSelectedOptions: [String]?,
        isEditingMode: Bool?
    ) {
        self.isAnonymous = isAnonymous
        self.allowAddOption = allowAddOption
        self.pollType = pollType
        self.pollTypeText = pollTypeText
        self.submitTypeText = submitTypeText
        self.expiryTime = expiryTime
        self.multipleSelectNum = multipleSelectNum
        self.multipleSelectState = multipleSelectState
        self.pollViewDataList = pollViewDataList
        self.pollAnswerText = pollAnswerText
        self.isPollSubmitted = isPollSubmitted
        self.toShowResult = toShowResult
        self.chatroomId = chatroomId
        self.messageId = messageId
        self._question = question
        self.options = options
        self._expiryDate = expiryDate
        self._optionState = optionState
        self._optionCount = optionCount
        self.isInstantPoll = isInstantPoll
        self.isShowSubmitButton = isShowSubmitButton
        self.isShowEditVote = isShowEditVote
        self.enableSubmitButton = enableSubmitButton
        self.tempSelectedOptions = tempSelectedOptions
        self.isEditingMode = isEditingMode
    }

    // MARK: - Public Methods
    public func pollAnswerTextUpdated() -> String {
        if let pollAnswerText = pollAnswerText, !pollAnswerText.isEmpty {
            return pollAnswerText
        }
        return "Be the first to respond"
    }

    public var isPollExpired: Bool {
        return expiryDate < Date()
    }

    public func addTempSelectedOptions(_ option: String) {
        self.tempSelectedOptions?.append(option)
    }

    public func removeTempSelectedOptions(_ option: String) {
        guard
            let index = self.tempSelectedOptions?.firstIndex(where: {
                $0 == option
            })
        else { return }
        self.tempSelectedOptions?.remove(at: index)
    }

    public func getPluralText(withNumber number: Int, text: String) -> String {
        number > 1 ? "\(text)s" : text
    }

    public func pollTypeWithSubmitText() -> String {
        let submitType = submitTypeText ?? ""
        let pollType = pollTypeText ?? ""
        return "\(pollType) \(Constants.shared.strings.dot) \(submitType)"
    }
    

    // MARK: - Builder
    public class Builder {
        private var isAnonymous: Bool?
        private var allowAddOption: Bool?
        private var pollType: Int?
        private var pollTypeText: String?
        private var submitTypeText: String?
        private var expiryTime: Int?
        private var multipleSelectNum: Int?
        private var multipleSelectState: Int?
        private var pollViewDataList: [PollViewData]?
        private var pollAnswerText: String?
        private var isPollSubmitted: Bool?
        private var toShowResult: Bool?
        private var chatroomId: String?
        private var messageId: String?
        private var question: String?
        private var options: [PollViewData]?
        private var expiryDate: Date?
        private var optionState: String?
        private var optionCount: Int?
        private var isInstantPoll: Bool?
        private var isShowSubmitButton: Bool?
        private var isShowEditVote: Bool?
        private var enableSubmitButton: Bool?
        private var tempSelectedOptions: [String]?
        private var isEditingMode: Bool?

        public init() {}

        @discardableResult
        public func isAnonymous(_ isAnonymous: Bool?) -> Builder {
            self.isAnonymous = isAnonymous
            return self
        }

        @discardableResult
        public func allowAddOption(_ allowAddOption: Bool?) -> Builder {
            self.allowAddOption = allowAddOption
            return self
        }

        @discardableResult
        public func pollType(_ pollType: Int?) -> Builder {
            self.pollType = pollType
            return self
        }

        @discardableResult
        public func pollTypeText(_ pollTypeText: String?) -> Builder {
            self.pollTypeText = pollTypeText
            return self
        }

        @discardableResult
        public func submitTypeText(_ submitTypeText: String?) -> Builder {
            self.submitTypeText = submitTypeText
            return self
        }

        @discardableResult
        public func expiryTime(_ expiryTime: Int?) -> Builder {
            self.expiryTime = expiryTime
            return self
        }

        @discardableResult
        public func multipleSelectNum(_ multipleSelectNum: Int?) -> Builder {
            self.multipleSelectNum = multipleSelectNum
            return self
        }

        @discardableResult
        public func multipleSelectState(_ multipleSelectState: Int?) -> Builder
        {
            self.multipleSelectState = multipleSelectState
            return self
        }

        @discardableResult
        public func pollViewDataList(_ pollViewDataList: [PollViewData]?)
            -> Builder
        {
            self.pollViewDataList = pollViewDataList
            return self
        }

        @discardableResult
        public func pollAnswerText(_ pollAnswerText: String?) -> Builder {
            self.pollAnswerText = pollAnswerText
            return self
        }

        @discardableResult
        public func isPollSubmitted(_ isPollSubmitted: Bool?) -> Builder {
            self.isPollSubmitted = isPollSubmitted
            return self
        }

        @discardableResult
        public func toShowResult(_ toShowResult: Bool?) -> Builder {
            self.toShowResult = toShowResult
            return self
        }

        @discardableResult
        public func chatroomId(_ chatroomId: String?) -> Builder {
            self.chatroomId = chatroomId
            return self
        }

        @discardableResult
        public func messageId(_ messageId: String?) -> Builder {
            self.messageId = messageId
            return self
        }

        @discardableResult
        public func question(_ question: String?) -> Builder {
            self.question = question
            return self
        }

        @discardableResult
        public func options(_ options: [PollViewData]?) -> Builder {
            self.options = options
            return self
        }

        @discardableResult
        public func expiryDate(_ expiryDate: Date?) -> Builder {
            self.expiryDate = expiryDate
            return self
        }

        @discardableResult
        public func optionState(_ optionState: String?) -> Builder {
            self.optionState = optionState
            return self
        }

        @discardableResult
        public func optionCount(_ optionCount: Int?) -> Builder {
            self.optionCount = optionCount
            return self
        }

        @discardableResult
        public func isInstantPoll(_ isInstantPoll: Bool?) -> Builder {
            self.isInstantPoll = isInstantPoll
            return self
        }

        @discardableResult
        public func isShowSubmitButton(_ isShowSubmitButton: Bool?) -> Builder {
            self.isShowSubmitButton = isShowSubmitButton
            return self
        }

        @discardableResult
        public func isShowEditVote(_ isShowEditVote: Bool?) -> Builder {
            self.isShowEditVote = isShowEditVote
            return self
        }

        @discardableResult
        public func enableSubmitButton(_ enableSubmitButton: Bool?) -> Builder {
            self.enableSubmitButton = enableSubmitButton
            return self
        }

        @discardableResult
        public func tempSelectedOptions(_ tempSelectedOptions: [String]?)
            -> Builder
        {
            self.tempSelectedOptions = tempSelectedOptions
            return self
        }

        @discardableResult
        public func isEditingMode(_ isEditingMode: Bool?) -> Builder {
            self.isEditingMode = isEditingMode
            return self
        }

        public func build() -> PollInfoData {
            return PollInfoData(
                isAnonymous: isAnonymous,
                allowAddOption: allowAddOption,
                pollType: pollType,
                pollTypeText: pollTypeText,
                submitTypeText: submitTypeText,
                expiryTime: expiryTime,
                multipleSelectNum: multipleSelectNum,
                multipleSelectState: multipleSelectState,
                pollViewDataList: pollViewDataList,
                pollAnswerText: pollAnswerText,
                isPollSubmitted: isPollSubmitted,
                toShowResult: toShowResult,
                chatroomId: chatroomId,
                messageId: messageId,
                question: question,
                options: options,
                expiryDate: expiryDate,
                optionState: optionState,
                optionCount: optionCount,
                isInstantPoll: isInstantPoll,
                isShowSubmitButton: isShowSubmitButton,
                isShowEditVote: isShowEditVote,
                enableSubmitButton: enableSubmitButton,
                tempSelectedOptions: tempSelectedOptions,
                isEditingMode: isEditingMode
            )
        }
    }

    public func toBuilder() -> Builder {
        return Builder()
            .isAnonymous(isAnonymous)
            .allowAddOption(allowAddOption)
            .pollType(pollType)
            .pollTypeText(pollTypeText)
            .submitTypeText(submitTypeText)
            .expiryTime(expiryTime)
            .multipleSelectNum(multipleSelectNum)
            .multipleSelectState(multipleSelectState)
            .pollViewDataList(pollViewDataList)
            .pollAnswerText(pollAnswerText)
            .isPollSubmitted(isPollSubmitted)
            .toShowResult(toShowResult)
            .chatroomId(chatroomId)
            .messageId(messageId)
            .question(question)
            .options(options)
            .expiryDate(expiryDate)
            .optionState(optionState)
            .optionCount(optionCount)
            .isInstantPoll(isInstantPoll)
            .isShowSubmitButton(isShowSubmitButton)
            .isShowEditVote(isShowEditVote)
            .enableSubmitButton(enableSubmitButton)
            .tempSelectedOptions(tempSelectedOptions)
            .isEditingMode(isEditingMode)
    }
}
