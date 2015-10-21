module Actions
  attr_reader :name
  ATTR_CHNG = 5
  def feed
    @attr[:health] += ATTR_CHNG
    @attr[:fullness] += ATTR_CHNG + rand(ATTR_CHNG)
    pass_time
    puts "#{@name} поїв."
  end

  def play
    @attr[:health] += ATTR_CHNG + rand(ATTR_CHNG)
    @attr[:mood] += ATTR_CHNG + rand(ATTR_CHNG)
    @attr[:fullness] -= rand(ATTR_CHNG)
    @attr[:cheerful] -= rand(ATTR_CHNG)
    pass_time
    puts "#{@name} добряче нагулявся."
  end

  def stroke
    @attr[:faithful] += ATTR_CHNG + rand(ATTR_CHNG)
    @attr[:peace] -= ATTR_CHNG + rand(ATTR_CHNG)
    pass_time
    puts "Ви погладили #{@name}."
  end

  def fly
    @attr[:health] += rand(ATTR_CHNG)
    @attr[:mood] += ATTR_CHNG + rand(ATTR_CHNG)
    @attr[:fullness] -= rand(ATTR_CHNG)
    @attr[:faithful] += rand(ATTR_CHNG)
    @attr[:peace] += rand(ATTR_CHNG)
    pass_time
    puts "#{@name} політав по кімнаті."
  end

  def cut
    @attr[:health] -= ATTR_CHNG * 6
    @attr[:peace] -= ATTR_CHNG * 5
    @attr[:mood] -= ATTR_CHNG * 4
    pass_time
    puts "Ви відірвали #{@name} лапу."
  end

  def cry_out
    @attr[:mood] -= ATTR_CHNG * 2
    @attr[:peace] -= ATTR_CHNG * 2
    pass_time
    puts "Ви накричали на #{@name}."
  end

  def blow
    @attr[:mood] += ATTR_CHNG + rand(ATTR_CHNG)
    @attr[:peace] += rand(ATTR_CHNG)
    pass_time
    puts "Ви дмухнули на #{@name}."
  end

  def kick
    @attr[:mood] -= ATTR_CHNG + rand(ATTR_CHNG)
    @attr[:peace] -= ATTR_CHNG * 2
    pass_time
    puts "Ви пнули пальцем #{@name}.  "
  end
end

class Pet
  include Actions
  EVENT_PHR = ['Комар врізався в вікно.', 'Комар потрапив у паутину.',
               'Комар зустрівся з іншим комаром.', 'Комар укусив кота.']
  MAX_ATTR = 50
  MIN_ATTR = 0
  ATTR_CHNG = 5
  def initialize(name)
    @attr = { health: MAX_ATTR, mood: MAX_ATTR,
              fullness: MAX_ATTR, cheerful: MAX_ATTR,
              faithful: MAX_ATTR, peace: MAX_ATTR }
    @name = name
    @cause_of_death = ''
  end

  def wait(n)
    puts "#Чекаємо #{n} годин(и)."
    n.times do
      pass_time
      event if rand(3).zero?
      next unless check_state(10)
      puts "\e[31mНе можна більше чекат. Ваш #{@name} в поганому стані.\e[0m"
      break
    end
  end

  def sleep(n)
    puts "#{@name} спить #{n} годин."
    n.times do
      pass_time
      @attr[:cheerful] += ATTR_CHNG
      next unless check_state(10)
      puts "\e[31mВаш #{@name} проснувся, він погано себе почуває.\e[0m"
      break
    end
  end

  def born
    puts "Народився комар #{@name}"
    view_state
  end

  private

  def death
    @attr.each { |key, value| @cause_of_death = key if value <= 0 }
    after_death
  end

  def event
    r = rand(2)
    case r
    when 0
      puts EVENT_PHR[rand(2)]
      @attr[:health] -= ATTR_CHNG
    when 1
      puts EVENT_PHR[1 + rand(2)]
      @attr[:mood] += ATTR_CHNG
    end
  end

  def view_state
    puts "\e[5mІм'я: #{@name}; Вид: Комар; \e[0m
    Здоров'я    : \e[32m#{'|' * (@attr[:health])}\e[0m
    Настрій     : \e[33m#{'|' * (@attr[:mood])}\e[0m
    Ситість     : \e[34m#{'|' * (@attr[:fullness])}\e[0m
    Бадьорість  : \e[35m#{'|' * (@attr[:cheerful])}\e[0m
    Вірність    : \e[30m#{'|' * (@attr[:faithful])}\e[0m
    Спокій      : \e[31m#{'|' * (@attr[:peace])}\e[0m" unless check_state(0)
  end

  def check_state(edge)
    bool = false
    @attr.each_key { |key| bool = true if @attr[key] <= edge }
    death if edge.zero? && bool
    bool
  end

  def after_death
    case @cause_of_death
    when :health, :fullnes, :cheerful
      puts "\e[31m#{@name} помер від виснаження...\e[0m"
    when :mood, :peace
      puts "\e[31m#{@name} помер від затяжної депресії...\e[0m"
    when :faithful
      puts "\e[31m#{@name} втік від вас до іншого хазяїна...\e[0m"
    end
    exit
  end

  def pass_time
    @attr.each_key { |key| @attr[key] = @attr[key] - rand(5) }
    correct_attr
    view_state
  end

  def correct_attr
    @attr.each_key { |key| @attr[key] = MAX_ATTR if @attr[key] > MAX_ATTR }
  end
end
puts "\e[36mВведіть ім*я вашого комара:\e[0m"
komar = Pet.new(gets.chomp)
komar.born
command = ''
until command == 'exit'
  puts 'Введіть команду.'
  command = gets.chomp
  case command
  when 'exit'
    break
  when 'help'
    puts "\e[2mКоманди:
    годувати - нагодувати комара;
    вигуляти - вигуляти комара;
    пнути - пнути комара пальцем;
    літати - дозволити комару політати навулиці;
    годувати_собою - дозволити комару укусити себе; (корисно для вірності)
    крик - кричати на комра; (приглушує агресію, якщо її небагато)
    чекати - чекати певний проміжок часу;(з випадковими подіями)
    спати - спати певний проміжок часу;
    дмух - дмухнути на комара;
    відірвати_лапу - відірвати комару лапу;
    гладити - гладити комара;\e[0m"
  when 'годувати'
    komar.feed
  when 'вигуляти'
    komar.play
  when 'гладити'
    komar.stroke
  when 'літати'
    komar.fly
  when 'крик'
    komar.cry_out
  when 'відірвати_лапу'
    komar.cut
  when 'дмух'
    komar.blow
  when 'пнути'
    komar.kick
  when 'чекати'
    puts 'Скільки годин чекати?'
    komar.wait(gets.to_i)
  when 'спати'
    puts 'Скільки годин спати?'
    komar.sleep(gets.to_i)
  end
end
