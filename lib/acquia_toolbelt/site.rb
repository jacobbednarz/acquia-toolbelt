module AcquiaToolbelt
  class Site < AcquiaToolbelt::Thor
    desc "example", "example site command"
    def example
      puts "example site command"
    end
  end
end