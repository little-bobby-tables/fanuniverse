require 'strscan'

module Search
  class Lexer
    TOKENS = {
      whitespace: /\s+/,
      binary_operator: /,|OR/,
      negation: /NOT/,
      term_delimiter: /:/,

      safe_string_until: /(\s*)(,|OR|NOT|"|\(|\))/,
      quoted_string: /"(?:[^\\]|\\.)*?"/,
      string_with_balanced_parentheses_until: /(\s*)(,|OR|NOT)/
    }

    def initialize(string)
      @scanner = StringScanner.new(string)
    end

    def match(token)
      @scanner.scan TOKENS[token]
    end

    def match_regex(regex)
      @scanner.scan regex
    end

    def left_parentheses
      @scanner.skip /\(/
    end

    def right_parentheses(expected_count)
      @scanner.skip /\){,#{expected_count}}/
    end

    def skip(token)
      @scanner.skip TOKENS[token]
    end

    # May contain words, numbers, spaces, dashes, and underscores.
    def safe_string
      match_until TOKENS[:safe_string_until]
    end

    # May contain any characters except for quotes (the latter are allowed when escaped).
    def quoted_string
      string = match(:quoted_string)

      if string
        string[1..-2] # ignore quotes
              .gsub(/\\"/, '"')
              .gsub(/\\\\/, '\\')
      end
    end

    def string_with_balanced_parentheses
      string = match_until TOKENS[:string_with_balanced_parentheses_until]

      if string
        opening_parens = string.count('(')

        balanced = string.split(')')[0..opening_parens].join(')')
        balanced += ')' if opening_parens > 0 && string.ends_with?(')')

        cutoff = string.length - balanced.length
        @scanner.pos -= cutoff

        balanced
      end
    end

    # StringScanner#scan_until returns everything up to and including the regex.
    # To avoid including the pattern, we use a lookahead.
    def match_until(regex)
      pattern = /.+?(?=#{regex.source}|\z)/
      match_regex(pattern)
    end
  end
end
