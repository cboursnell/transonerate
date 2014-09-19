require 'open3'
require 'threach'

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

    # TODO split query up to @threads pieces
    def run threads=1, output_dir="."
      # align assembly to genome (this might take a while)
      @output = "#{output_dir}/exonerate.out"
      if !File.exist?(@output)
        outputs=[]
        files = split_input(@assembly, threads)
        threads = [threads, files.length].min
        files.threach(threads) do |thread|
          cmd = 'exonerate --model est2genome'
          cmd << ' --ryo "@\t%qi\t%ti\t%pi\t%qab\t%qae\t%tab\t%tae\t%ql\t%s\n"'
          cmd << " --showalignment false "
          cmd << " --showvulgar false"
          cmd << " --query #{thread} "
          cmd << " --target #{@genome} "
          cmd << " --bestn 1 "
          cmd << " --maxintron 20000 "
          cmd << " > #{thread}.exonerate"
          outputs << "#{thread}.exonerate"
          stdout, stderr, status = Open3.capture3 cmd
          if !status.success?
            abort "Something went wrong with exonerate : #{thread}"
          end
        end
        # cat
        cat_cmd = "cat "
        cat_cmd << outputs.join(" ")
        cat_cmd << " > #{@output}"
        stdout, stderr, status = Open3.capture3(cat_cmd)
        if !status.success?
          abort "Problem concatenating individual exonerate output files"
        end
        files.each do |file|
          File.delete(file) if File.exist?(file)
        end
        outputs.each do |o|
          File.delete(o) if File.exist?(o)
        end
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
          qstart = cols[4].to_i+1 # exonerate uses between coordinates
          qstop = cols[5].to_i    #  A C G T A C G T
          tstart = cols[6].to_i+1 #   0 1 2 3 4 5 6
          tstop = cols[7].to_i
          qlen = cols[8].to_i
          score = cols[9].to_i
          tstart, tstop = [tstart, tstop].minmax
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

    # Split a fasta file in pieces
    #
    # @param [String] filename
    # @param [Integer] pieces
    def split_input filename, pieces
      input = {}
      name = nil
      seq=""
      sequences=0
      File.open(filename).each_line do |line|
        if line =~ /^>(.*)$/
          sequences+=1
          if name
            input[name]=seq
            seq=""
          end
          name = $1
        else
          seq << line.chomp
        end
      end
      input[name]=seq
      # construct list of output file handles
      outputs=[]
      output_files=[]
      pieces = [pieces, sequences].min
      pieces.times do |n|
        outfile = "#{filename}_chunk_#{n}.fasta"
        outfile = File.expand_path(outfile)
        outputs[n] = File.open("#{outfile}", "w")
        output_files[n] = "#{outfile}"
      end
      # write sequences
      count=0
      input.each_pair do |name, seq|
        outputs[count].write(">#{name}\n")
        outputs[count].write("#{seq}\n")
        count += 1
        count %= pieces
      end
      outputs.each do |out|
        out.close
      end
      output_files
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