require 'helper'
require 'tmpdir'

class TestExonerate < Test::Unit::TestCase

  context "Exonerate" do

    setup do
      @output = Dir.mktmpdir
      @exonerate = Transonerate::Exonerate.new(@output)
    end

    teardown do
      cmd = "rm -rf #{@output}"
      # `#{cmd}`
    end

    should "setup correctly" do
      assert @exonerate
    end

    should "align a set of transcripts to a genome" do
      assembly = File.join(File.dirname(__FILE__), 'data', 'assembly.fa')
      genome = File.join(File.dirname(__FILE__), 'data', 'genome.fa')
      @exonerate.run assembly, genome
      assert File.exist?("#{@output}/exonerate.out")
    end

    should "parse the exonerate output to a list of hashes" do
      assembly = File.join(File.dirname(__FILE__), 'data', 'assembly.fa')
      genome = File.join(File.dirname(__FILE__), 'data', 'genome.fa')
      @exonerate.run assembly, genome
      @exonerate.parse_output
      assert_equal 12262, @exonerate.hits["PAC:24119942"].score
    end

  end

end
