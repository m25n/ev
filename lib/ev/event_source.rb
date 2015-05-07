module EV
	class EventSource
		def self.new_from_events(events)
			allocate.tap do |root|
				root.initialize_from_events(events)
			end
		end

		def initialize_from_events(events)
			events.each do |event|
				apply_without_changes(event)
			end
		end

		def version
			@version || 0
		end

		def changes
			if @changes
				@changes.dup
			else
				[]
			end
		end

		def initial_version
			version - changes.size
		end

		def dirty?
			changes.size > 0
		end

		def commit
			@changes.clear if @changes
		end

		protected

		def handle(event)
			raise NotImplementedError
		end

		def apply(event)
			apply_without_changes(event)
			@changes ||= []
			@changes << event
		end

		private

		def apply_without_changes(event)
			handle(event)
			@version = version.next
		end
	end
end