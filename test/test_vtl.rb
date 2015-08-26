require 'test_helper'

class VTLTest < Minitest::Test

  class Handler
    attr_reader :header
    attr_reader :recs
    attr_reader :invalid_record

    def initialize
      @recs = []
    end

    def parsed_header(header)
      @header = header
    end

    def parsed_record(rec)
      @recs << rec.clone
    end

    def error(invalid_record)
      @invalid_record = invalid_record
    end
  end

  def test_parse_file
    handler = Handler.new
    VTL.parse_file(File.dirname(__FILE__) + "/fixtures/log-full.xml", handler)
    assert_handler(handler)
  end

  def test_parse_url
    handler = Handler.new
    VTL.parse_uri('https://raw.githubusercontent.com/TrustTheVote-Project/vtl/master/test/fixtures/log-full.xml?a', handler)
    assert_handler(handler)
  end

  def test_invalid_notes
    handler = Handler.new
    VTL.parse_file(File.dirname(__FILE__) + "/fixtures/log-invalid-notes.xml", handler)

    r = handler.invalid_record
    refute_nil r
    assert_equal [ "notes is invalid" ], r.errors
  end

  def assert_handler(handler)
    assert_nil handler.invalid_record

    h = handler.header
    assert_equal "Sample Virginia Data", h.origin
    assert_equal "B6BF0C25-BDEA-440B-BDAF-F484D01FA90D", h.origin_uniq
    assert_equal "SHA1", h.hash_alg
    assert_equal "2014-07-21T08:54:03.690", h.create_date

    recs = handler.recs
    assert_equal 2, recs.size

    r = recs[0]
    assert_equal "ACLyxNKFJvmidhT0E7KttaM07lk=", r.voter_id
    assert_equal "2014-07-11T11:46:38.777-04:00", r.date
    assert_equal "approve", r.action
    assert_equal "VoterRecordUpdate", r.form
    assert_equal "PRINCE GEORGE COUNTY", r.jurisdiction

    r = recs[1]
    assert_equal "AL/K6aDqL+wD3akQv6QmnYP7TYg=", r.voter_id
    assert_equal "2014-07-11T09:45:02.087-04:00", r.date
    assert_equal "approve", r.action
    assert_equal "VoterRecordUpdate", r.form
    assert_equal "ROANOKE CITY", r.jurisdiction
    assert_equal [ "acceptNewRequest", "postalSent" ], r.notes
  end

end
