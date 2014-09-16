require 'helper'
require 'tmpdir'

class TestGtf < Test::Unit::TestCase

  context "Gtf" do

    setup do
      gtf = File.join(File.dirname(__FILE__), 'data', 'genome.gtf')
      @output = Dir.mktmpdir
      @gtf = Transonerate::Gtf.new(gtf)
    end

    teardown do
      cmd = "rm -rf #{@output}"
      # `#{cmd}`
    end

    should "setup correctly and parse gtf file" do
      assert @gtf
      assert @gtf.data["LOC_Os01g01010.2"]
      assert_equal 2984, @gtf.data["LOC_Os01g01010.2"].start
      assert_equal 10562, @gtf.data["LOC_Os01g01010.2"].stop
    end

  end

end
