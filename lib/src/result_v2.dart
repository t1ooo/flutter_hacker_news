// class Result<T, E> {
//   final T? value;
//   final E? error;

//   Result(this.value, this.error);

//   factory Result.value(T value) => ResultValue<T,E>(value);
//   factory Result.error(E error) => ResultError<T,E>(error);
// }

// class ResultValue<T,E> extends Result<T,E> {
//   ResultValue(T value) : super(value, null);
// }

// class ResultError<T,E> extends Result<T,E> {
//   ResultError(E error) : super(null, error);
// }

// void foo() {
//   final r = Result<int, Object>.value(1);
//   if (r is ResultValue) {
//     print(r.value);
//   }
// }

class Result {
  static Result value<V>(V value) => ResultValue<V>(value);
  static Result error<E>(E error) => ResultValue<E>(error);
}

class ResultValue<V> extends Result {
  final V? value;
  ResultValue(this.value);
}

class ResultError<E> extends Result {
  final E? error;
  ResultError(this.error);
}


Result boo() {
  return Result.value<int>(1);
}


void foo() {
  // final r = Result.value<int>(1);
  final r = boo();
  if (r is ResultValue) {
    print(r.value);
  }
  if (r is ResultError) {
    print(r.error);
  }
}
