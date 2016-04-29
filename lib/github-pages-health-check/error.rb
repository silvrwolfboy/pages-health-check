module GitHubPages
  module HealthCheck
    class Error < StandardError
      DOCUMENTATION_BASE = "https://help.github.com"
      DOCUMENTATION_PATH = "/categories/github-pages-basics/"

      attr_reader :repository, :domain

      def initialize(repository: nil, domain: nil)
        super
        @repository = repository
        @domain     = domain
      end

      def self.inherited(base)
        subclasses << base
      end

      def self.subclasses
        @subclasses ||= []
      end

      def message
        "Something's wrong with your GitHub Pages site."
      end

      def message_with_url
        msg = message.gsub(/\s+/, " ").squeeze(" ").strip
        msg << "." unless msg =~ /\.$/
        [msg, more_info].join(" ")
      end
      alias_method :message_formatted, :message_with_url

      private

      def username
        if repository.nil?
          "[YOUR USERNAME]"
        else
          repository.owner
        end
      end

      def more_info
        "For more information, see #{documentation_url}."
      end

      def documentation_url
        URI.join(Error::DOCUMENTATION_BASE, self.class::DOCUMENTATION_PATH).to_s
      end
    end
  end
end
