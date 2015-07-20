require 'nokogiri'
require 'timeliness'

class VTL

  def self.parse_file(file, handler)
    filename = file.is_a?(String) ? File.basename(file) : file.original_filename
    Nokogiri::XML::SAX::Parser.new(VTL::Parser.new(filename, handler)).parse_file(file)
  end

  def self.parse_uri(uri, handler)
    uri = uri.is_a?(String) ? URI(uri) : uri
    filename = File.basename(uri.path)

    parser = Nokogiri::XML::SAX::PushParser.new(VTL::Parser.new(filename, handler))

    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new(uri, 'User-Agent' => 'curl/7.37.1')

      http.request request do |response|
        response.read_body do |chunk|
          parser << chunk
        end
      end
    end
  end

end

require_relative 'vtl/parser'
