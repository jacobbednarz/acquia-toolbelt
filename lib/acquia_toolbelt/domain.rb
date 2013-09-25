module AcquiaToolbelt
  class Domain < AcquiaToolbelt::Thor
    desc "example", "example domain command"
    def example
      puts "example domain command"
    end

    desc "list", "List all domains."
    def list
      sites = AcquiaToolbelt::CLI::API.acquia_api_call("sites")
      ui.info sites
    end

    # def add
    # end

    # def delete
    # end
  end
end