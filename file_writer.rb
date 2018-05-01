class FileWriter

  def initialize(output_file_name)
    @output_file = output_file_name

    File.write(output_file_name, "")
    puts "Writing output to #{Dir.pwd}/#{output_file_name}"
  end

  def write_to_file(content)
    File.open(output_file, 'a+') do |f|
      f.puts(content.to_s + "\n")
    end
  end

end