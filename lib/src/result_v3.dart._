class Result<V>  {
  final V value;
  Result(this.value);
}

Result boo() {
  return Result<int>(1);
}

void foo() {
  // final r = Result<int>(1);
  final r = boo();
  if (r is Result<int>) {
    print(r.value + 1);
  }
  if (r is Result<String>) {
    print(r.value.padLeft(2));
  }
}


// class Result<V, Type>  {
//   final V value;
//   Result(this.value);
// }


// void foo() {
//   final r = Result<int, int>(1);
//   if (r is Result<int, int>) {
//     print(r.value + 1);
//   }
//   if (r is Result<String, String>) {
//     print(r.value.padStart(2));
//   }
// }
