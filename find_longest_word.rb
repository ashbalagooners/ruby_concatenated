require "trie"

class LongestConcatenatedWords
  attr_accessor :trie,  :wordList, :sortedWordList, :checkedHash, :longestConcatWord, :secondlongestConcatWord, :totalCount, :newsortedlist

  def initialize
    @trie = Trie.new
    @wordList = []
    @sortedWordList = []
    @checkedHash = {}
    @longestConcatWord = ""
    @secondlongestConcatWord = ""
    @totalCount = 0
    @newsortedlist = []
  end


  def read_file (file)
    File.open(file).each do |line|
      word = line.strip
      @wordList.push(word)
      @trie.add(word,1)
    end
  end

  def lookup_longest_concatenatedword
    @sortedWordList = sorted_list_by_length(@wordList)
    @sortedWordList.each do |word|
      @trie.add(word,0)
      checked = @checkedHash.has_key?(word)
      if find_concat_words(word,checked)
        @totalCount += 1
        if @longestConcatWord.empty?
          @longestConcatWord = word
        end
         @newsortedlist.push(word)
         @newsortedlist = sorted_list_by_length(@newsortedlist)
         @secondlongestConcatWord = @newsortedlist[1]
      end
      @trie.add(word,1)
    end
    display_results(@longestConcatWord,@secondlongestConcatWord, @totalCount)
  end

private
  def find_concat_words(word, checked=false)
    if checked == false
      return @checkedHash[word] if @checkedHash.has_key?(word)
    end
    0.upto(word.length-1) do |index|
      str = word[0..index]
      if @trie.has_key?(str) && @trie.get(str) != 0
        if (word.length == index+1) || find_concat_words(word[(index+1)..(word.length-1)])
          @checkedHash[word] = true
          return true
        end
      end
    end
    @checkedHash[word] = false
    return false
  end

  def sorted_list_by_length(list)
    list.sort do |a,b|
      b.length <=> a.length
    end
  end

  def display_results(firstlongestword, secondlongestword,count)
    puts "1st longest concatenated word is:\n"
    puts firstlongestword
    puts "2nd longest concatenated word is:\n"
    puts secondlongestword
    puts "Total number of concatenated words is:\n"
    puts count
  end
end

list = LongestConcatenatedWords.new
list.read_file("actual_words_for_problem.txt")
list.lookup_longest_concatenatedword

