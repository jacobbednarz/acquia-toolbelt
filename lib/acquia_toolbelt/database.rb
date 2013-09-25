module AcquiaToolbelt
  class CLI
    class Database < AcquiaToolbelt::Thor
      desc "mydb", "a db command"
      def mydb
        puts "holy fuck, a database command"
      end
    end
  end
end