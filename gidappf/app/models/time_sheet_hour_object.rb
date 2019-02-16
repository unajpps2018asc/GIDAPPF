require 'singleton'
class TimeSheetHourObject
  include Singleton
  attr_accessor :elements

  def initialize
    @elements=Array.new
  end
end
