module Transonerate

  class Gtf

    attr_reader :data

    def initialize filename
      @filename = File.expand_path(filename)
      @data = {}
      self.run
    end

    def run
      if !File.exist?(@filename)
        raise IOError.new("File not found #{@filename}")
      end
      mrna = nil
      File.open(@filename).each_line do |line|
        next if line=~/^#/
        cols = line.chomp.split("\t")
        chromosome = cols[0]
        type = cols[2] # mrna, exon, cds, utr etc
        start = cols[3].to_i
        stop = cols[4].to_i
        strand = cols[6]
        desc = cols[8]

        if type == "mRNA"
          if desc =~ /Name=(.*?);/
            mrna = $1
          else
            puts "Problem parsing name from desc line of gtf"
            mrna = "unknown"
          end
          @data[mrna] ||= Feature.new(mrna, type, chromosome,
                                      start, stop, strand)
        elsif type == "exon"
          if @data[mrna]
            @data[mrna].regions << (start..stop)
          end
        end

      end
    end

    def search hit
      # find the best entry in the gtf that corresponds to the Hit
      # query is the contig in the assembly
      # target is the chromosome in the genome
      # start and stop of the hit are genome coordinates

      candidates = []
      @data.each do |mrna, gtf|
        if gtf.chromosome == hit.target
          if hit.tstart >= gtf.start and hit.tstop <= gtf.stop
            candidates << gtf
          end
        end
      end
      best = 0.0
      if candidates.length > 0
        best_candidate = candidates.first
        #puts "! #{hit.tstart}..#{hit.tstop} #{gtf.start}..#{gtf.stop}"
        candidates.each do |gtf|
          exon_lengths = 0
          coverage = 0
          gtf.regions.each do |region|
            exon_lengths += region.last - region.first + 1
            if region.first >= hit.tstart
              if region.last <= hit.tstop
                # |-------|
                #   |---|
                coverage += region.last - region.first + 1
              else
                if region.first > hit.tstop
                  # |---|
                  #       |---|
                else
                  # |-----|
                  #    |-----|
                  coverage += hit.tstop - region.first + 1
                end
              end
            else # region.first < hit.tstart
              if region.last >= hit.tstop
                #   |--|
                # |------|
                coverage += hit.tstop - hit.tstart + 1
              else
                if hit.tstart >= region.last
                  #       |---|
                  # |---|
                else
                  #    |-----|
                  # |-----|
                  coverage += region.last - hit.tstart + 1

                end
              end
            end
          end
          total_coverage = coverage/exon_lengths.to_f
          if total_coverage > best
            best = total_coverage
            best_candidate = gtf
          end
        end
        # puts "best: #{best_candidate.start}..#{best_candidate.stop}"
      else
        puts "warning: no hits found in gtf file"
      end
      return best
    end

  end

  class Feature

    attr_accessor :name, :type, :chromosome, :features, :start, :stop, :strand
    attr_accessor :regions

    def initialize(name, type, chromosome, start, stop, strand)
      @name = name
      @type = type
      @chromosome = chromosome
      @start = start
      @stop = stop
      @regions = []
      @strand = strand
    end
  end

end