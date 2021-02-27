/// Summary of descriptive stats of the name
class Summary {
  Map<String, int> _distribution = {};
  int _count = 0;
  int _frequency = 0;
  String _top = '';
  int _unique = 0;
  final String _namon;

  /// Creates a [Summary] of a given string of alphabetical characters
  Summary(this._namon, {List<String> restrictions = const [' ']}) {
    _compute(restrictions);
  }

  Map<String, int> get distribution => _distribution;
  int get count => _count;
  int get frequency => _frequency;
  String get top => _top;
  int get unique => _unique;
  int get length => _namon?.length;

  void _compute(List<String> restrictions) {
    _distribution = _groupByChar();
    for (var char in _distribution.keys) {
      if (restrictions.contains(_distribution[char]) == false) {
        _count += _distribution[char];
        if (_distribution[char] >= _frequency) {
          _frequency = _distribution[char];
          _top = char;
        }
        _unique++;
      }
    }
  }

  Map<String, int> _groupByChar() {
    final frequencies = <String, int>{};
    for (var char in _namon.split('')) {
      if (frequencies.containsKey(char)) {
        frequencies[char] += 1;
      } else {
        frequencies[char] = 1;
      }
    }
    return frequencies;
  }
}
