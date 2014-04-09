module ExecuteInDirectory
  def execute_in_directory(path)
    around(:each) do |example|
      old = Dir.pwd
      Dir.chdir path
      example.run
      Dir.chdir old
    end
  end
end
