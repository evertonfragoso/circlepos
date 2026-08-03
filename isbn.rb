def get_isbn13(isbn)
  raise if isbn.to_s.strip.empty?

  digits = isbn.to_s.chars.map(&:to_i)

  raise if digits.all?(&:zero?)

  sum = 0

  digits.each_with_index do |digit, index|
    sum += index.even? ? digit : (digit * 3)
  end

  remainder = sum % 10
  check_digit = remainder.zero? ? 0 : (10 - remainder)

  "#{isbn}#{check_digit}"
end
