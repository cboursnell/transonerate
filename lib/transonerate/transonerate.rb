module Transonerate

  class Transonerate

    def initialize assembly, genome, gtf
      @assembly = assembly
      @genome = genome
      @gtf = gtf
      @exonerate = Exonerate.new @assembly, @genome
      @annotation = Gtf.new @gtf
    end

    def score threads
      @exonerate.run threads
      @exonerate.parse_output
      @exonerate.hits.each do |query_name, hit|
        # puts "query = #{query_name}, hit.score = #{hit.score}"
        score = @annotation.search hit
        puts "#{query_name}\t#{score}\t#{hit.pi}\t#{score*hit.pi}"
      end
    end

  end

end