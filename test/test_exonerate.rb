require 'helper'
require 'tmpdir'

class TestExonerate < Test::Unit::TestCase

  context "Exonerate" do

    setup do

    end

    should "setup correctly" do
      assert @exonerate
    end

    should "align a set of transcripts to a genome" do
      assert File.exist?("exonerate.out")
    end

    should "parse the exonerate output to a list of hashes" do
      assert @exonerate
    end

  end

end
