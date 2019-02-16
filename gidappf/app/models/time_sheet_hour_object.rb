require 'singleton'
class TimeSheetHourObject
  include Singleton
  attr_accessor :elements

  def initialize
    @elements = {}
  end

  def version
    '0.0.1'
  end
end
