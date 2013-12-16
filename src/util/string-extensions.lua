function string.starts(String, Start)
   return string.sub(String, 1, string.len(Start)) == Start
end

function string.ends(String, End)
   return End == '' or string.sub(String, -string.len(End)) == End
end

function string:split(inSplitPattern, outResults)
   if not outResults then
      outResults = {}
   end
   local theStart = 1
   local theSplitStart, theSplitEnd = string.find(self, inSplitPattern, theStart)
   while theSplitStart do
      table.insert(outResults, string.sub( self, theStart, theSplitStart-1 ))
      theStart = theSplitEnd + 1
      theSplitStart, theSplitEnd = string.find(self, inSplitPattern, theStart)
   end
   table.insert(outResults, string.sub(self, theStart))
   return outResults
end
