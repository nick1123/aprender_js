require 'json'

files =  `ls data`.strip.split(/\s+/)
files.each do |file|
  file_lines = IO.readlines("data/#{file}")

  meta_line = file_lines.shift.strip
  meta_info = JSON.parse(meta_line)

  javascript_variable_questions = []
  javascript_variable_questions_and_answers = []
  file_lines.each do |line|
    line.strip!
    pieces = line.split("\t")
    question = pieces[0]
    answer = pieces[1]

    javascript_variable_questions << "\t\"#{question}\""
    javascript_variable_questions_and_answers << "\t\"#{question}\": \"#{answer}\""
  end

  javascript_variable_questions = "var questions = [\n" + javascript_variable_questions.join(",\n") + "];"
  javascript_variable_questions_and_answers = "var questionsAndAnswers = {\n" + javascript_variable_questions_and_answers.join(",\n") + "};"

  html_file = "html/" + file.gsub("tsv", "html")

  file_question_javascript = "<SCRIPT LANGUAGE=\"JavaScript\">\n#{javascript_variable_questions}\n\n#{javascript_variable_questions_and_answers}\n</script>\n"

  file_contents = file_question_javascript + IO.read("game_template.html")
  file_contents.gsub!("==TITLE==", meta_info["title"])

  File.open(html_file, 'w') {|f| f.write(file_contents)}
end
