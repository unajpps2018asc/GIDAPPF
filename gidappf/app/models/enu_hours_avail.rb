class EnuHoursAvail < ActiveRecord::Base
  enum hours_avails: {from0to24:24, from10to22:1022, from8to12:812, from12to16:1216, from16to22:1622, from0to12:12, from12to24:1224}
end
