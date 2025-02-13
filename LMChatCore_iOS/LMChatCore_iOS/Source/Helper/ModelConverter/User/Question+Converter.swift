//
//  Question+Converter.swift
//  Pods
//
//  Created by Anurag Tyagi on 21/01/25.
//

import LikeMindsChatData
import LikeMindsChatUI

extension Question {
    /**
     Converts this `Question` instance into a `QuestionViewData` object.

     - Returns: A `QuestionViewData` object populated with this question's data.
     */
    public func toViewData() -> QuestionViewData {
        let viewData = QuestionViewData()
        viewData.id = self.id
        viewData.questionTitle = self.questionTitle
        viewData.state = self.state
        viewData.value = self.value
        viewData.optional = self.optional
        viewData.helpText = self.helpText
        viewData.field = self.field
        viewData.isCompulsory = self.isCompulsory
        viewData.isHidden = self.isHidden
        viewData.communityId = self.communityId
        viewData.memberId = self.memberId
        viewData.directoryFields = self.directoryFields
        viewData.imageUrl = self.imageUrl
        viewData.canAddOtherOptions = self.canAddOtherOptions
        viewData.questionChangeState = self.questionChangeState
        viewData.isAnswerEditable = self.isAnswerEditable
        return viewData
    }
}

extension QuestionViewData {
    /**
     Converts this `QuestionViewData` object back into a `Question` struct.

     - Returns: A `Question` struct created using this view data's properties.
     */
    public func toQuestion() -> Question {
        return Question(
            id: self.id,
            questionTitle: self.questionTitle,
            state: self.state,
            value: self.value,
            optional: self.optional,
            helpText: self.helpText,
            field: self.field,
            isCompulsory: self.isCompulsory,
            isHidden: self.isHidden,
            communityId: self.communityId,
            memberId: self.memberId,
            directoryFields: self.directoryFields,
            imageUrl: self.imageUrl,
            canAddOtherOptions: self.canAddOtherOptions,
            questionChangeState: self.questionChangeState,
            isAnswerEditable: self.isAnswerEditable
        )
    }
}
