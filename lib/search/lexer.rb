require 'strscan'

module Search
  class Lexer
    TOKENS = {
      whitespace: /\s+/,
      binary_operator: /,|OR/,
      negation: /NOT/,
      left_parentheses: /\(+/,
      right_parentheses: /\)+/,
      term_delimiter: /:/,

      safe_string_until: /(\s*)(,|OR|NOT|"|\(|\))/,
      quoted_string: /"(?:[^\\]|\\.)*"/,
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

    def count(token)
      @scanner.skip TOKENS[token]
    end

    alias skip count

    # May contain words, numbers, spaces, dashes, and underscores.
    def safe_string
      match_until TOKENS[:safe_string_until]
    end

    # May contain any characters except for quotes (the latter are allowed when escaped).
    def quoted_string
      string = match(:quoted_string)[1..-2] # ignore quotes
      if string
        string.gsub(/\\"/, '"')
              .gsub(/\\\\/, '\\')
      end
    end

    def string_with_balanced_parentheses
      source = match_until TOKENS[:string_with_balanced_parentheses_until]
      opening_parens = source.count('(')

      balanced = source.split(')')[0..opening_parens].join(')')
      balanced += ')' if opening_parens > 0 && source.ends_with?(')')

      cutoff = source.length - balanced.length
      @scanner.pos -= cutoff

      balanced
    end

    # StringScanner#scan_until returns everything up to and including the regex.
    # To avoid including the pattern, we use a lookahead.
    def match_until(regex)
      pattern = /.+?(?=#{regex.source}|\z)/
      match_regex(pattern)
    end
  end
end
