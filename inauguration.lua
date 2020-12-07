#!/usr/bin/env lua

now = os.time()
count = 1611162000 - now
if count < 0 then
  print "Joe Biden has been inaugurated president"
  os.exit(0)
end
days = math.floor(count / 86400)
hours = math.floor((count - (days * 86400)) / 3600)
minutes = math.floor((count - (days * 86400) - (hours * 3600)) / 60)
seconds = count - (days * 86400) - (hours * 3600) - (minutes * 60)

print("Joe Biden will be inaugurated president in ")
print(tostring(days) ..
      " days, " .. tostring(hours) .. " hours, " .. tostring(minutes) ..
      " minutes, " .. tostring(seconds) .. " seconds.")

