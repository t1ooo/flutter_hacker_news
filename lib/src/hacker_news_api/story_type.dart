enum StoryType {
  top,
  new_,
  best,
  ask,
  show,
  job,
}

extension StoryTypeToText on StoryType {
  String toText() {
    return toString().split('.').last.replaceAll('_', '');
  }
}
