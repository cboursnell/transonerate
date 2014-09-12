require 'helper'
require 'tmpdir'

class TestTophat < Test::Unit::TestCase

  context "Tophat" do

    setup do
      genome = File.join(File.dirname(__FILE__), 'data', 'genome.fa')
      gtf = File.join(File.dirname(__FILE__), 'data', 'genome.gtf')
      @output = Dir.mktmpdir
      @tophat = Transonerate::Tophat.new genome, gtf, @output
    end

    teardown do
      cmd = "rm -rf #{@output}"
      `#{cmd}`
    end

    should "setup correctly" do
      assert @tophat
    end

    should "build a bowtie index of the genome" do
      @tophat.create_index
      assert File.exist?("#{@output}/genome.1.bt2"), "index exists"
    end

    should "create samfile by align reads to the genome using tophat" do
      left = File.join(File.dirname(__FILE__), 'data', 'left.fastq')
      right = File.join(File.dirname(__FILE__), 'data', 'right.fastq')
      @tophat.create_index
      @tophat.align_reads left, right

      assert File.exist?("#{@output}/accepted_hits.sam"), "samfile exists"
    end

    should "run cufflinks on the tophat sam output" do
      left = File.join(File.dirname(__FILE__), 'data', 'left.fastq')
      right = File.join(File.dirname(__FILE__), 'data', 'right.fastq')

      @tophat.create_index
      @tophat.align_reads left, right
      @tophat.create_new_gtf

      assert File.exist?("#{@output}/transcripts.gtf"), "transcripts.gtf exists"
    end

  end

end
