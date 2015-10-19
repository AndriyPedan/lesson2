require 'yaml'
class Ball
  ANSWERS = YAML.load_file('answers.yml')
  COL_CONST = 31
  def shake
    r = rand(ANSWERS.size)
    puts "\e[#{(r / 5 + COL_CONST)}m#{ANSWERS[r]}\e[0m"
    ANSWERS[r]
  end
end
