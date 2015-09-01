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

    vtl_parser = VTL::Parser.new(filename, handler)
    parser = Nokogiri::XML::SAX::PushParser.new(vtl_parser)

    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new(uri, 'User-Agent' => 'curl/7.37.1')

      http.request request do |response|
        # restore the filename if present
        disp = response.to_hash["content-disposition"].to_s
        if m = disp.scan(/filename=\\\"(.*?)\\\"/) and m.flatten.size > 0
          vtl_parser.filename = m.flatten.first
        end

        response.read_body do |chunk|
          parser << chunk unless chunk.nil? || chunk.empty?
        end
      end
    end
  end

end

require_relative 'vtl/parser'
