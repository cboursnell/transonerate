require 'helper'
require 'tmpdir'

class TestTophat < Test::Unit::TestCase

  context "Tophat" do

    setup do

    end

    should "setup correctly" do
        assert @tophat
    end

    should "build a bowtie index of the genome" do
        assert File.exist?("genome.1.bt2")
    end

    should "align reads to the genome using tophat" do
        assert File.exist?("samfile")
    end

    should "run cufflinks on the tophat sam output" do
        assert File.exist?("transcripts.gtf")
    end

  end

end
