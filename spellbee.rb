=begin
Created by jwillis1010 --> https://github.com/jwillis1010
in order to help solve the daily NYTimes Spelling Bee Puzzle @ https://www.nytimes.com/puzzles/spelling-bee

Disclaimer 1: I am not associated with the NYTimes. I'm just a reader who got frustrated trying to find the answers.

Disclaimer 2: Yes, this is cheating. I got bored and decided to write something up to help me solve the riddle.

Disclaimer 3: I don't know Ruby all that well and I'm sure this program can be done in 2 lines of code.

Disclaimer 4: The program produced all the answers for the daily puzzle correctly. Tested on 11/25/18.

Thank you to all the contributors of the dwyl/english-words github project
The dictionary used came from them --> https://github.com/dwyl/english-words
=end

require 'set'

# store today's letter in an array
letters = %w(c a b k l p u)

# two arrays will be used. One for the dictionary and one for answers
dictionary = Array.new
answers = Array.new

# parse dictionary and store in the dictionary array
File.open("words.txt", "r") do |f|
  f.each_line do |line|
    dictionary << line
  end
end

# iterate over the dictionary
dictionary.each do |word|
  word_length = word.size
  new_word = word.downcase[0..(word_length - 3)] # in order to remove the \n from each word that was parsed

  chars_in_word_set = new_word.split("").to_set # must split new word before turning it to a set
  letters_set = letters.to_set

  if chars_in_word_set == letters_set || chars_in_word_set < letters_set # set must be equal or dictionary word must be proper subset
    if new_word.size >= 4 && new_word.include?("c") # answer words must be length of 4 or higher. Lastly, check for the target character
      answers << word
    end
  end
end

# print the answers to the screen
answers.each do |answer|
  puts answer.downcase
end
