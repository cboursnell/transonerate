require 'helper'
require 'tmpdir'

class TestTransonerate < Test::Unit::TestCase

  context "Transonerate" do

    setup do
      assembly = File.join(File.dirname(__FILE__), 'data', 'assembly.fa')
      genome = File.join(File.dirname(__FILE__), 'data', 'genome.fa')
      gtf = File.join(File.dirname(__FILE__), 'data', 'genome.gtf')
      @transonerate = Transonerate::Transonerate.new(assembly, genome, gtf)
    end

    should "score" do
      @transonerate.score

    end

  end

end
