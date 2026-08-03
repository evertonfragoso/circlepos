require_relative "../isbn"

RSpec.describe "#get_isbn13" do
  it "returns the complete ISBN-13 for a valid prefix" do
    expect(get_isbn13("978030640615")).to eq("9780306406157")
  end

  it "accepts an integer as input" do
    expect(get_isbn13(978030640615)).to eq("9780306406157")
  end

  it "returns an ISBN ending in 0 when the check digit is 0" do
    expect(get_isbn13("978030640614")).to eq("9780306406140")
  end

  it "raises when isbn is nil" do
    expect { get_isbn13(nil) }.to raise_error
  end

  it "raises when isbn is blank" do
    expect { get_isbn13("") }.to raise_error
  end

  it "raises when all digits are zero" do
    expect { get_isbn13("000000000000") }.to raise_error
  end

  it "raises an error when isbn prefix has less than 12 digits" do
    expect { get_isbn13("123456") }.to raise_error
  end

  it "raises an error when isbn prefix has more than 12 digits" do
    expect { get_isbn13("1234567890123") }.to raise_error
  end
end
