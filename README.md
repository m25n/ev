# ev

```ruby
require 'ev'
require 'set'

ItemAdded = Struct.new(:name)
ItemRemoved = Struct.new(:name)

class TodoList < EV::EventSource
  def add_item(name)
    raise "Item already added" if items.include?(name)
    apply(ItemAdded.new(name))
  end

  def remove_item(name)
    raise "Item cannot be removed because it does not exist" unless items.include?(name)
    apply(ItemRemoved.new(name))
  end

  protected

  def items
    @items ||= Set.new
  end

  def handle(event)
    case event
      when ItemAdded
        items << event.name
      when ItemRemoved
        items.delete(event.name)
    end
  end
end

def debug
  begin
    es = yield
    puts "	dirty?  #{es.dirty?.inspect}"
    puts "	version #{es.version}"
    puts "	changes #{es.changes.inspect}"
  rescue => e
    puts "	ERROR: #{e.message}"
  end
end

todo_list = nil

debug do
  puts "Initialization:"
  todo_list = TodoList.new([ItemAdded.new("Buy a thing"), ItemAdded.new("Clean room")])
end

debug do
  puts "Adding \"Take back library book\":"
  todo_list.add_item("Take back library book")
  todo_list
end

debug do
  puts "Commit:"
  todo_list.commit
  todo_list
end

debug do
  puts "Trying to add \"Take back library book\" again:"
  todo_list.add_item("Take back library book")
  todo_list
end

debug do
  puts "Trying to remove \"Something else\" again:"
  todo_list.remove_item("Something else")
  todo_list
end
```