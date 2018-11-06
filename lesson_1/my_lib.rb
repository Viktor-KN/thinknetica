def ask(question, expected_type)
  print "#{question} "
  if block_given?
    until yield(answer = gets.strip)
      print "Некорректный ввод. Пожалуйста повторите.\n#{question} "
    end
  else
    answer = gets.strip
  end

  case expected_type
    when :integer
      answer.to_i
    when :float
      answer.to_f
    when :string
      answer
  end
end
