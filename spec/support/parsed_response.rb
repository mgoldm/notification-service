# frozen_string_literal: true

module ParsedResponse
  def parsed_body
    Oj.load response.body, symbol_keys: true
  end
end
