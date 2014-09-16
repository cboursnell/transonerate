module Transonerate

  class Transonerate

    def initialize assembly, genome, gtf
      @assembly = assembly
      @genome = genome
      @gtf = gtf
      @exonerate = Exonerate.new @assembly, @genome
      @annotation = Gtf.new @gtf
    end

    def score
      @exonerate.run
      @exonerate.parse_output
      @exonerate.hits.each do |query_name, hit|
        # puts "query = #{query_name}, hit.score = #{hit.score}"
        score = @annotation.search hit
        puts "#{query_name}\t#{score} x #{hit.pi} = #{score*hit.pi}"
      end
    end

  end

end