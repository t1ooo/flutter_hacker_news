# v1
class StoriesNotifier {
    get storyIds
    loadStoryIds()
}

class ItemNotifier {
    item(id)
    loadItem(id)
}

class CommentController {
    get isCommentVisible
    toggleCommentVisibility()
}

# v2
class StoriesController {
    get storyIds
    loadStoryIds()
}

class StoryController {
    get story
    get comment
    loadStory()
    loadComment()
    toggleCommentVisibility()
    isCommentVisible(id)
}

class UserInfoController {
    get userInfo
    loadUserInfo()
}

class UserActivityController {
    get activity
    loadActivity
}
