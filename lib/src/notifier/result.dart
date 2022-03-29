class Result<V, E> {
  final V? value;
  final E? error;

  Result(this.value, this.error);

  factory Result.empty() => Result(null, null);
  factory Result.value(V value) => Result(value, null);
  factory Result.error(E error) => Result(null, error);
}
