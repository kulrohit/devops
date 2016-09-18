rule 'RPM001', 'Don\'t hardcode RPM' do
  tags %w{bug RPM rpm}
  cookbook do |path|
    recipes  = Dir["#{path}/{#{standard_cookbook_subdirs.join(',')}}/**/*"]
    recipes += Dir["#{path}/*.rb"]
    recipes.collect do |recipe|
      lines = File.readlines(recipe)

      lines.collect.with_index do |line, index|
        if line.match('(rpm)')
          {
            :filename => recipe,
            :matched => recipe,
            :line => index+1,
            :column => 0
          }
        end
      end.compact
    end.flatten
  end
end


