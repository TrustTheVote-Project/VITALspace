# VTL

Parser for the VTL XML format conforming to XSD 4.4.

## Usage

    class Handler
      def parsed_header(header)
        # header.filename
        # header.origin
        # header.origin_uniq
        # header.create_date
        # header.hash_alg
      end

      def parsed_record(record)
        # record.voter_id ...
      end

      def error(invalid_record)
        # invalid_record.errors
      end
    end

    handler = Handler.new
    VTL.parse_file(file, handler)

Each record has validated set of fields:

    voter_id
    date
    action
    form
    form_note
    jurisdiction
    leo
    notes
    comment
    election

