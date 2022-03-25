enum ResultType {
  value,
  error,
}

class Result<T, E> {
  final T? value;
  final E? error;
  final ResultType type;

  Result(this.value, this.error, this.type);

  factory Result.value(value) => Result(value, null, ResultType.value);
  factory Result.error(error) => Result(null, error, ResultType.error);
}


void foo() {
  final r = Result<int, Object>.value(1);
  switch(r.type) {
    case ResultType.value:
      print(r.value!);
      break;
    case ResultType.error:
      print(r.error!);
      break;
  }
}
