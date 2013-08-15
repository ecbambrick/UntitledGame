return function(threshold)
	return {
		count = 0,
		threshold = threshold,
		
		update = function(self, dt)
			self.count = self.count + dt
			if self.count > self.threshold then
				self.count = 0
				return true
			else
				return false
			end
		end,
		
		ready = function(self)
			return self.count == 0
		end,
		
		reset = function(self)
			self.count = 0
		end,
	}
end
