# v1
class HackerNewsApi {}

class CommentController {
    get isVisible
    toggleVisibility
}

# v2
class HackerNewsApi {}

class CommentsController {
    isVisible(id)
    toggleVisibility(id)
}

# v3
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

# v4
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
