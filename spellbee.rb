=begin
Created by jwillis1010 --> https://github.com/jwillis1010
in order to help solve the daily NYTimes Spelling Bee Puzzle @ https://www.nytimes.com/puzzles/spelling-bee

Disclaimer 1: I am not associated with the NYTimes. I'm just a reader who got frustrated trying to find the local_dic_answers.

Disclaimer 2: Yes, this is cheating. I got bored and decided to write something up to help me solve the riddle.

Disclaimer 3: I don't know Ruby all that well and I'm sure this program can be done in 2 lines of code.

Disclaimer 4: The program produced all the local_dic_answers for the daily puzzle correctly. Tested on 11/25/18.

Thank you to all the contributors of the dwyl/english-words github project
The dictionary used came from them --> https://github.com/dwyl/english-words

Thanks to the Oxford dictionaries for making an API available for free/public use.
=end

require 'set'
require 'httparty'
require 'yaml'

# load the configuration file
config = YAML.load_file('config.yml')

# set today's letters and target character that must be included in every word.
letters = %w(p y t d a i r)
target_letter = 'r'

# three arrays will be used. One for the dictionary used, one for the local_dic_answers and one for the verified_oxford_answers.
dictionary = Array.new
local_dic_answers = Array.new
verified_oxford_answers = Array.new

# parse dictionary and store in the local dictionary array
File.open("words.txt", "r") do |f|
  f.each_line do |line|
    dictionary << line
  end
end

# iterate over the dictionary entries
dictionary.each do |word|
  word_length = word.size
  new_word = word.downcase[0..(word_length - 3)] # in order to remove the \n from each word that was parsed

  chars_in_word_set = new_word.split("").to_set # must split new word before turning it to a set
  letters_set = letters.to_set

  if chars_in_word_set == letters_set || chars_in_word_set < letters_set # set must be equal or dictionary word must be proper subset
    if new_word.size >= 4 && new_word.include?(target_letter) # answer words must be length of 4 or higher. Lastly, check for the target character
      local_dic_answers << new_word
    end
  end
end

# process the local_dic_answers. Verify each against the oxford dictionary API. Lastly, print the sorted array to the screen.
local_dic_answers.each do |answer|

  sleep(5) # make a request every 5 seconds. API provider rules.
  url = "https://od-api.oxforddictionaries.com:443/api/v1/entries/en/" + answer
  response = HTTParty.get(url, {# request Oxford API credentials via this link https://developer.oxforddictionaries.com
                                :headers => {
                                    :app_id => config['app_id'], #your app id issued by oxford api
                                    :app_key => config['app_key'] # your app key issued by oxford api
                                }
  })

  if response.code == 200 # the entry exists in Oxford dictionary, therefore, add it to the verified answer list
    # You could print the definition of the word by uncommenting these lines and processing the JSON response.
    # Notes: some error checking has to implemented here for this to work correctly.
    #payload =  response.parsed_response
    #answer_definition = payload['results'][0]['lexicalEntries'][0]['entries'][0]['senses'][0]['definitions'][0]
    #puts answer + " = " + answer_definition
    verified_oxford_answers << answer
  end
end

puts verified_oxford_answers.sort_by {|x| x.length} # sort by length. Longer words get the highest score in the game.