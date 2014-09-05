require 'open3'

module Transonerate

  class Tophat

    def initialize left, right, genome, gtf

    end

    def create_index
      build = "#{@build_path} #{@genome} #{@index}"
    end

    def align_reads
      tophat_cmd = "#{@tophat_path}"
      tophat_cmd << " -o #{@outputdir} " # options
      tophat_cmd << " -p #{@threads} " # options
      # tophat_cmd << " --phred64-quals "  #
      tophat_cmd << " --no-convert-bam "  # Output is <output_dir>/accepted_hit.sam)
      tophat_cmd << " --b2-very-sensitive "
      tophat_cmd << " -G #{@existing_gff} "
      tophat_cmd << " #{@index} "
      tophat_cmd << " #{@left} "
      tophat_cmd << " #{@right} "
    end

    def create_new_gtf
      cufflinks_cmd = "#{@cufflinks_path}"
      cufflinks_cmd << " -o #{@outputdir} "
      cufflinks_cmd << " -p #{@threads} "
      cufflinks_cmd << " #{@outputdir}/accepted_hits.sam "
    end

  end

end