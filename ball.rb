require 'yaml'
class Ball
  ANSWERS = YAML.load_file('answers.yml')
  def shake
    r = rand(ANSWERS.size)
    puts "\e[#{(r / 5 + 31)}m#{ANSWERS[r]}\e[0m"
    ANSWERS[r].to_s
  end
end
