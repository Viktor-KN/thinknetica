class Menu
  attr_reader :menu_list, :data_table

  def initialize(menu_list, data_table)
    @menu_list = menu_list
    @data_table = data_table
    validate!
    @current_menu = get_menu_items(menu_list[:default])
    @current_title = get_menu_title(menu_list[:default])
  end

  def run
    loop do
      print_nn current_title
      choice = ask(your_choice, current_menu)
      do_action(current_menu[choice][:action], current_menu[choice][:params])
    end
  end

  protected

  attr_accessor :current_menu, :current_title

  # Честно говоря не имею представления, как это можно сократить, чтобы rubocop
  # не ругался.
  def validate!
    raise 'menu_list param must be a Hash.' unless menu_list.is_a?(Hash)

    raise 'data_table param must be a Hash.' unless data_table.is_a?(Hash)

    raise 'No mandatory key :default in menu_list.' \
          unless menu_list.key?(:default)

    # Тут rubocop зациклился. Предлагает конвертировать в normal
    # unless-statement, после переделки предлагает опять в modifier clause
    raise "No key :#{menu_list[:default]} in menu_list hash, defined by" \
          ' :default key.' unless menu_list.key?(menu_list[:default])

    validate_menu_list
  end

  def validate_menu_list
    menu_list.each do |key, value|
      next if key == :default

      raise "No mandatory :title key for menu_list[:#{key}]." \
            unless value.key?(:title)

      raise "No mandatory :menu key for menu_list[:#{key}]." \
            unless value.key?(:menu)

      raise "menu_list[:#{key}][:menu] must be a Hash." \
            unless menu_list[key][:menu].is_a?(Hash)

      raise "menu_list[:#{key}][:menu] must not be empty" \
            if menu_list[key][:menu].empty?

      validate_menu(value[:title], value[:menu])
    end
  end

  def validate_menu(title, menu)
    menu.each do |key, value|
      raise "Item with '#{key}' in #{title} must be a Hash." \
            unless value.is_a?(Hash)

      raise "No mandatory :title key for menu item with key '#{key}' in" \
            " #{title}." unless value.key?(:title)

      raise "No mandatory :action key for menu item with key '#{key}' in" \
            " #{title}." unless value.key?(:action)

      validate_action(title, value[:action]) unless value[:action] == :show_menu

      raise "No mandatory :params key for menu item with key '#{key}' in" \
            " #{title}." unless value.key?(:params)

      validate_data(title, value[:params]) unless value[:action] == :show_menu
    end
  end

  def validate_action(title, action)
    raise "No method defined for action :#{action} in #{title}" \
          unless action_defined?(action)
  end

  def validate_data(title, params)
    params.each do |elem|
      raise "No key :#{elem} in data_table hash, defined in #{title}" \
            unless data_table.key?(elem)
    end
  end

  def action_defined?(action)
    self.class.private_method_defined?(action) ||
      self.class.protected_method_defined?(action) ||
      self.class.public_method_defined?(action)
  end

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

  def get_menu_items(key)
    menu_list[key][:menu]
  end

  def get_menu_title(key)
    menu_list[key][:title]
  end

  def print_nn(*args)
    args.map! { |arg| "\n#{arg}\n" }
    print(*args)
  end

  def do_action(action, params)
    if action == :show_menu
      self.current_menu = get_menu_items(params[0])
      self.current_title = get_menu_title(params[0])
    else
      action_params = []
      params.each do |param|
        action_params << data_table[param]
      end

      send(action, *action_params)
    end
  end

  def ask(question, variants = nil)
    if variants.is_a?(Hash)
      ask_with_hash(question, variants)
    elsif variants.is_a?(Array)
      ask_with_array(question, variants)
    else
      ask_simple(question)
    end
  end

  def ask_with_hash(question, variants)
    variants.each { |key, val| puts "#{key}#{key_val_separator}#{val[:title]}" }

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
