require 'vtl/record'
require 'vtl/header'

class VTL::Parser

  def initialize(filename, handler)
    @filename = filename
    @handler  = handler
    @header   = VTL::Header.new
    @record   = VTL::Record.new
  end

  def xmldecl(version, encoding, standalone)
  end

  def start_document
    @dest = nil
  end

  def start_element_namespace(name, attrs = [], prefix = nil, uri = nil, ns = [])
    case name
    when 'header'
      @header.clear
      @header.filename = @filename

      @dest      = @header
      @attr_name = nil
      @attr_map  = VTL::Header::ATTRS
    when 'voterTransactionRecord'
      @record.clear
      @dest      = @record
      @attr_name = nil
      @attr_map  = VTL::Record::ATTRS
    else
      @attr_name = @attr_map && @attr_map[name]
    end
  end

  def start_element(name, attrs)
  end

  def end_element(name)
  end

  def end_element_namespace(name, prefix = nil, uri = nil)
    @attr_name = nil
    case name
    when 'header'
      @handler.parsed_header(@header)
      @dest = nil
    when 'voterTransactionRecord'
      if @record.valid?
        @handler.parsed_record(@record)
      else
        @handler.error(@record)
      end

      @dest = nil
    else
      # inside element end
    end
  end

  def characters(text)
    @dest[@attr_name] = text.strip unless @attr_name.nil?
  end

  def end_document
  end

  def error(msg)
    @handler.xml_error(msg)
  end
end
