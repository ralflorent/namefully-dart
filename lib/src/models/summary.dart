/// Summary of descriptive stats of the name
class Summary {
  Map<String, int> distribution = {};
  int count = 0;
  int frequency = 0;
  String top = '';
  int unique = 0;
  final String namon;

  /// Creates a [Summary] of a given string of alphabetical characters
  Summary(this.namon, {List<String> restrictions = const [' ']}) {
    _compute(restrictions);
  }

  void _compute(List<String> restrictions) {
    distribution = _groupByChar();
    for (var char in distribution.keys) {
      if (restrictions.contains(distribution[char]) == false) {
        count += distribution[char];
        if (distribution[char] >= frequency) {
          frequency = distribution[char];
          top = char;
        }
        unique++;
      }
    }
  }

  Map<String, int> _groupByChar() {
    final frequencies = <String, int>{};
    namon.split('').forEach((char) {
      if (frequencies.containsKey(char)) {
        frequencies[char] += 1;
      } else {
        frequencies[char] = 1;
      }
    });
    return frequencies;
  }
}
