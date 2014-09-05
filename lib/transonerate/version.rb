# encoding: utf-8

module Transonerate

  # Defines the version of this codebase.
  #
  # This module is used in help messages and in generating
  # the Gem. Versions must be incremented in accordance with
  # Semantic Versioning 2.0 (http://semver.org/).
  module VERSION
    MAJOR = 0
    MINOR = 1
    PATCH = nil

    STRING = [MAJOR, MINOR, PATCH].compact.join('.')
  end

end # Transonerate
