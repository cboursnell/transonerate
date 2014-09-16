require 'helper'
require 'tmpdir'

class TestExonerate < Test::Unit::TestCase

  context "Exonerate" do

    setup do
      assembly = File.join(File.dirname(__FILE__), 'data', 'assembly.fa')
      genome = File.join(File.dirname(__FILE__), 'data', 'genome.fa')
      @exonerate = Transonerate::Exonerate.new assembly, genome
    end

    teardown do
      cmd = "rm -rf #{@output}"
      `#{cmd}`
    end

    should "setup correctly" do
      assert @exonerate
    end

    should "align a set of transcripts to a genome" do
      @output = Dir.mktmpdir
      @exonerate.run @output
      assert File.exist?("#{@output}/exonerate.out")
    end

    should "parse the exonerate output to a list of hashes" do
      @output = Dir.mktmpdir
      @exonerate.run @output
      @exonerate.parse_output
      assert_equal 12262, @exonerate.hits["PAC:24119942"].score
      assert_equal 4555, @exonerate.hits["PAC:24117461"].score
    end

  end

end
