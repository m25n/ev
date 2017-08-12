module EV
  class EventSource
    def initialize(events)
      events.each { |event| apply_without_changes(event) }
    end

    def version
      @version || 0
    end

    def changes
      return [] unless @changes
      @changes.dup
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