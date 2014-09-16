require 'open3'

module Transonerate

  class Exonerate

    attr_reader :hits

    def initialize assembly, genome
      # get exonerate path
      cmd = "which exonerate"
      stdout, stderr, status = Open3.capture3(cmd)
      if status.success?
        @exonerate_path = stdout.split("\n").first
      else
        abort "Can't find exonerate"
      end
      @assembly = assembly
      @genome = genome
      @hits = {}
    end

    def run output_dir="."
      # align assembly to genome (this might take a while)
      @output = "#{output_dir}/exonerate.out"
      cmd = 'exonerate --model est2genome'
      cmd << ' --ryo "@\t%qi\t%ti\t%pi\t%qab\t%qae\t%tab\t%tae\t%ql\t%s\n"'
      cmd << " --showalignment false "
      cmd << " --showvulgar false"
      cmd << " --query #{@assembly} "
      cmd << " --target #{@genome} "
      cmd << " > #{@output}"
      # puts cmd
      stdout, stderr, status = Open3.capture3 cmd
      if !status.success?
        abort "Something went wrong with exonerate"
      end
    end

    def parse_output
      # open output and store in a hash
      # make it easy to get out contig hits
      if !@output or !File.exist?(@output)
        abort "Can't find exonerate output file to parse"
      end
      File.open("#{@output}").each_line do |line|
        if line =~ /^@/
          cols = line.chomp.split("\t")
          query = cols[1]
          target = cols[2]
          pi = cols[3].to_f/100.0
          qstart = cols[4].to_i
          qstop = cols[5].to_i
          tstart = cols[6].to_i+1 # exonerate hit seems to start early
          tstop = cols[7].to_i
          qlen = cols[8].to_i
          score = cols[9].to_i
          if @hits[query]
            if @hits[query].score < score
              @hits[query] = Hit.new(query, target, pi, qstart, qstop,
                tstart, tstop, qlen, score)
            end
          else
            @hits[query] = Hit.new(query, target, pi, qstart, qstop,
              tstart, tstop, qlen, score)
          end

        end
      end
    end

  end

  class Hit

    attr_reader :query, :target, :pi, :qstart, :qstop
    attr_reader :tstart, :tstop, :qlen, :score

    def initialize query, target, pi, qstart, qstop, tstart, tstop, qlen, score
      @query = query
      @target = target
      @pi = pi
      @qstart = qstart
      @qstop = qstop
      @tstart = tstart
      @tstop = tstop
      @qlen = qlen
      @score = score
    end
  end

end