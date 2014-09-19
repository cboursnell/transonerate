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
      results = {}
      @exonerate.hits.each do |query_name, hit|
        coverage = @annotation.search hit
        pq = (hit.qstop-hit.qstart)/hit.qlen.to_f
        # puts "#{query_name}\t#{pq}\t#{coverage}\t#{hit.pi}\t#{coverage*hit.pi}"
        results[query_name]=[pq, coverage, hit.pi]
      end
      results
    end

  end

end