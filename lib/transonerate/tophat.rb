require 'open3'

module Transonerate

  class Tophat

    def initialize genome, gtf, output_dir
      @genome = genome
      @gtf = gtf
      @output_dir = File.expand_path(output_dir)
      # get bowtie2-build path
      cmd = "which bowtie2-build"
      stdout, stderr, status = Open3.capture3(cmd)
      if status.success?
        @build_path = stdout.split("\n").first
      else
        abort "Can't find bowtie2-build"
      end
      # get tophat path
      cmd = "which tophat2"
      stdout, stderr, status = Open3.capture3(cmd)
      if status.success?
        @tophat2_path = stdout.split("\n").first
      else
        abort "Can't find tophat2"
      end
      # get cufflinks path
      cmd = "which cufflinks"
      stdout, stderr, status = Open3.capture3(cmd)
      if status.success?
        @cufflinks_path = stdout.split("\n").first
      else
        abort "Can't find tophat2"
      end
      @threads  = 1
    end

    def create_index
      @index = File.join(@output_dir,
                         File.basename(@genome,File.extname(@genome)))
      build = "#{@build_path} #{@genome} #{@index}"
      stdout, stderr, status = Open3.capture3 build
      if !status.success?
        abort "something went wrong running bowtie2-build"
      end
    end

    def align_reads left, right
      tophat_cmd = "#{@tophat2_path}"
      tophat_cmd << " -o #{@output_dir} " # options
      tophat_cmd << " -p #{@threads} " # options
      # tophat_cmd << " --phred64-quals "  #
      tophat_cmd << " --no-convert-bam "
      tophat_cmd << " --b2-very-sensitive "
      # tophat_cmd << " -G #{@gtf} "
      tophat_cmd << " #{@index} "
      tophat_cmd << " #{left} "
      tophat_cmd << " #{right} "
      # puts tophat_cmd
      stdout, stderr, status = Open3.capture3 tophat_cmd
      if !status.success?
        abort "something went wrong running tophat"
      end
    end

    def create_new_gtf
      cufflinks_cmd = "#{@cufflinks_path}"
      cufflinks_cmd << " -o #{@output_dir} "
      cufflinks_cmd << " -p #{@threads} "
      cufflinks_cmd << " -g #{@gtf} "
      cufflinks_cmd << " #{@output_dir}/accepted_hits.sam "
      # puts cufflinks_cmd
      stdout, stderr, status = Open3.capture3 cufflinks_cmd
      if !status.success?
        abort "something went wrong running cufflinks"
      end
    end

  end

end