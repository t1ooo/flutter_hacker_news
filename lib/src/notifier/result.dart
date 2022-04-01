class Result<V, E> {
  const Result(this.value, this.error);

  factory Result.empty() => Result(null, null);
  factory Result.value(V value) => Result(value, null);
  factory Result.error(E error) => Result(null, error);

  final V? value;
  final E? error;
}
