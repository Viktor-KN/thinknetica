class Menu
  attr_reader :menu_list, :data_table

  def initialize(menu_list, data_table)
    @menu_list = menu_list
    @data_table = data_table
  end

  def run
    current_menu = menu_list[:default]
    loop do
      print_nn menu_list[current_menu][:title]
      choice = ask(your_choice, menu_list[current_menu][:menu])

      if menu_list[current_menu][:menu][choice][:action] == :show_menu
        current_menu = menu_list[current_menu][:menu][choice][:params][0]
        next
      else
        action = menu_list[current_menu][:menu][choice][:action]
        params = []
        menu_list[current_menu][:menu][choice][:params].each do |param|
          params << data_table[param]
        end
        print "\n"
        send(action, *params)
      end
    end
  end

  protected

  def your_choice
    'Your choice: '
  end

  def incorrect_choice
    'Incorrect choice provided. Try again: '
  end

  def empty_value
    'Empty value provided. Try again: '
  end

  def key_val_separator
    ".\t"
  end

  def ask(question, variants = nil)
    if variants.is_a?(Hash)
      variant = ask_with_hash(question, variants)
    elsif variants.is_a?(Array)
      variant = ask_with_array(question, variants)
    else
      variant = ask_simple(question)
    end
    variant
  end

  def print_nn(*args)
    args.map! { |arg| "\n#{arg}\n" }
    print(*args)
  end

  def ask_with_hash(question, variants)
    variants.each do |key, val|
      puts "#{key}#{key_val_separator}#{val[:title]}"
    end
    print question
    until variants.key?(variant = gets.strip)
      print incorrect_choice
    end
    variant
  end

  def ask_with_array(question, variants)
    variants.each.with_index(1) do |var, index|
      puts "#{index}#{key_val_separator}#{var}"
    end
    print question
    until (0..variants.size - 1).cover?(variant = gets.to_i - 1)
      print incorrect_choice
    end
    variant
  end

  def ask_simple(question)
    print question
    while (variant = gets.strip).empty?
      print empty_value
    end
    variant
  end
end
