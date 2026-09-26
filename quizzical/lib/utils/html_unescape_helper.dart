/// Utility class to decode HTML entities returned by the OpenTDB API.
class HtmlUnescapeHelper {
  static final Map<String, String> _namedEntities = {
    '&quot;': '"',
    '&#039;': "'",
    '&apos;': "'",
    '&amp;': '&',
    '&lt;': '<',
    '&gt;': '>',
    '&nbsp;': ' ',
    '&iexcl;': '¡',
    '&cent;': '¢',
    '&pound;': '£',
    '&curren;': '¤',
    '&yen;': '¥',
    '&brvbar;': '¦',
    '&sect;': '§',
    '&uml;': '¨',
    '&copy;': '©',
    '&ordf;': 'ª',
    '&laquo;': '«',
    '&not;': '¬',
    '&shy;': '',
    '&reg;': '®',
    '&macr;': '¯',
    '&deg;': '°',
    '&plusmn;': '±',
    '&sup2;': '²',
    '&sup3;': '³',
    '&acute;': '´',
    '&micro;': 'µ',
    '&para;': '¶',
    '&middot;': '·',
    '&cedil;': '¸',
    '&sup1;': '¹',
    '&ordm;': 'º',
    '&raquo;': '»',
    '&frac14;': '¼',
    '&frac12;': '½',
    '&frac34;': '¾',
    '&iquest;': '¿',
    '&Agrave;': 'À',
    '&Aacute;': 'Á',
    '&Acirc;': 'Â',
    '&Atilde;': 'Ã',
    '&Auml;': 'Ä',
    '&Aring;': 'Å',
    '&AElig;': 'Æ',
    '&Ccedil;': 'Ç',
    '&Egrave;': 'È',
    '&Eacute;': 'É',
    '&Ecirc;': 'Ê',
    '&Euml;': 'Ë',
    '&Igrave;': 'Ì',
    '&Iacute;': 'Í',
    '&Icirc;': 'Î',
    '&Iuml;': 'Ï',
    '&ETH;': 'Ð',
    '&Ntilde;': 'Ñ',
    '&Ograve;': 'Ò',
    '&Oacute;': 'Ó',
    '&Ocirc;': 'Ô',
    '&Otilde;': 'Õ',
    '&Ouml;': 'Ö',
    '&times;': '×',
    '&Oslash;': 'Ø',
    '&Ugrave;': 'Ù',
    '&Uacute;': 'Ú',
    '&Ucirc;': 'Û',
    '&Uuml;': 'Ü',
    '&Yacute;': 'Ý',
    '&THORN;': 'Þ',
    '&szlig;': 'ß',
    '&agrave;': 'à',
    '&aacute;': 'á',
    '&acirc;': 'â',
    '&atilde;': 'ã',
    '&auml;': 'ä',
    '&aring;': 'å',
    '&aelig;': 'æ',
    '&ccedil;': 'ç',
    '&egrave;': 'è',
    '&eacute;': 'é',
    '&ecirc;': 'ê',
    '&euml;': 'ë',
    '&igrave;': 'ì',
    '&iacute;': 'í',
    '&icirc;': 'î',
    '&iuml;': 'ï',
    '&eth;': 'ð',
    '&ntilde;': 'ñ',
    '&ograve;': 'ò',
    '&oacute;': 'ó',
    '&ocirc;': 'ô',
    '&otilde;': 'õ',
    '&ouml;': 'ö',
    '&divide;': '÷',
    '&oslash;': 'ø',
    '&ugrave;': 'ù',
    '&uacute;': 'ú',
    '&ucirc;': 'û',
    '&uuml;': 'ü',
    '&yacute;': 'ý',
    '&thorn;': 'þ',
    '&yuml;': 'ÿ',
    '&OElig;': 'Œ',
    '&oelig;': 'œ',
    '&Scaron;': 'Š',
    '&scaron;': 'š',
    '&Yuml;': 'Ÿ',
    '&fnof;': 'ƒ',
    '&circ;': 'ˆ',
    '&tilde;': '˜',
    '&ndash;': '–',
    '&mdash;': '—',
    '&lsquo;': '‘',
    '&rsquo;': '’',
    '&sbquo;': '‚',
    '&ldquo;': '“',
    '&rdquo;': '”',
    '&bdquo;': '„',
    '&dagger;': '†',
    '&Dagger;': '‡',
    '&bull;': '•',
    '&hellip;': '…',
    '&permil;': '‰',
    '&prime;': '′',
    '&Prime;': '″',
    '&lsaquo;': '‹',
    '&rsaquo;': '›',
    '&euro;': '€',
    '&trade;': '™',
  };

  static final RegExp _entityRegex = RegExp(r'&(?:#x[0-9a-fA-F]+|#[0-9]+|[a-zA-Z]+);');

  /// Unescapes an HTML string containing numeric and named character entities.
  static String unescape(String input) {
    if (input.isEmpty) return input;

    return input.replaceAllMapped(_entityRegex, (match) {
      final entity = match.group(0)!;

      // Check named entity
      if (_namedEntities.containsKey(entity)) {
        return _namedEntities[entity]!;
      }

      // Check hexadecimal numeric entity &#xNN;
      if (entity.startsWith('&#x') || entity.startsWith('&#X')) {
        final hexString = entity.substring(3, entity.length - 1);
        final codePoint = int.tryParse(hexString, radix: 16);
        if (codePoint != null) {
          return String.fromCharCode(codePoint);
        }
      }

      // Check decimal numeric entity &#NN;
      if (entity.startsWith('&#')) {
        final decString = entity.substring(2, entity.length - 1);
        final codePoint = int.tryParse(decString, radix: 10);
        if (codePoint != null) {
          return String.fromCharCode(codePoint);
        }
      }

      return entity;
    });
  }
}
