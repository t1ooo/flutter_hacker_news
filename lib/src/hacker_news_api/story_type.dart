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
    return this.toString().split('.').last.replaceAll('_', '');
  }
}
