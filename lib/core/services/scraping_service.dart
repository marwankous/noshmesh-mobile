import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

class ScrapingService {
  // A list of common selectors for article content
  final List<String> _contentSelectors = [
    'article',
    'main',
    '.content',
    '#content',
    '.main',
    '#main',
    '.post',
    '.entry-content',
    '.article-content',
    '.article-body',
  ];

  Future<String> extractArticleContent(String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36',
          'Referer': url, // Use the same URL as Referer
          'Accept':
              'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
          'Accept-Language': 'en-US,en;q=0.9',
        },
      );

      if (response.statusCode == 200) {
        return parseHtmlContent(response.body);
      } else {
        return 'Failed to load page: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error fetching or parsing URL: $e';
    }
  }

  String parseHtmlContent(String html) {
    final document = html_parser.parse(html);

    // Try to find the article content using the selectors
    for (final selector in _contentSelectors) {
      final element = document.querySelector(selector);
      if (element != null) {
        return _cleanText(element.text);
      }
    }

    // If no specific element is found, fall back to the body
    return _cleanText(document.body?.text ?? 'Could not extract content.');
  }

  // Helper to remove extra whitespace and newlines
  String _cleanText(String text) {
    return text.replaceAll(RegExp(r'\s{2,}', multiLine: true), '\n').trim();
  }
}
