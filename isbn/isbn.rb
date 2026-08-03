def get_isbn13(isbn)
  raise if isbn.to_s.strip.empty?

  digits = isbn.to_s.chars.map(&:to_i)

  raise if digits.all?(&:zero?)
  raise if digits.length != 12
  raise if digits.length > 12

  sum = 0

  digits.each_with_index do |digit, index|
    sum += index.even? ? digit : (digit * 3)
  end

  remainder = sum % 10
  check_digit = remainder.zero? ? 0 : (10 - remainder)

  "#{isbn}#{check_digit}"
end

if __FILE__ == $PROGRAM_NAME
  loop do
    print "Enter ISBN prefix (Ctrl+C to exit): "

    isbn = gets.chomp

    puts "ISBN-13: #{get_isbn13(isbn)}"
  rescue Interrupt
    puts "\nGoodbye!"
    exit
  rescue StandardError => e
    puts "Error: #{e.message}"
  end
end
