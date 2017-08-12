require 'spec_helper'

class EventSourceExample < EV::EventSource
  def add_event(event)
    apply(event)
  end

  protected
  def handle(event)
  end
end

RSpec.describe EventSourceExample do
  describe '#changes' do
    let(:events) { [1, 2] }
    subject { described_class.new(events) }

    context 'with events before initialization' do
      it 'has no changes' do
        expect(subject.changes).to eq([])
      end
    end

    context 'with an events before and after initialization' do
      let(:new_events) { [3, 4] }

      before { new_events.each { |event| subject.add_event(event) } }

      it 'has changes' do
        expect(subject.changes).to eq(new_events)
      end
    end
  end

  describe '#version' do
    subject { described_class.new(events) }

    context 'with no events at all' do
      let(:events) { [] }

      it 'defaults to zero' do
        expect(subject.version).to eq(0)
      end
    end

    context 'with events before initialization' do
      let(:events) { [1, 2] }

      it { expect(subject.version).to eq(events.count) }
    end

    context 'with an events before and after initialization' do
      let(:events) { [1, 2] }
      let(:new_events) { [3, 4] }

      before { new_events.each { |event| subject.add_event(event) } }

      it { expect(subject.version).to eq(new_events.count + events.count) }
    end
  end

  describe '#initial_version' do
    subject { described_class.new(events) }

    context 'with no events at all' do
      let(:events) { [] }

      it { expect(subject.initial_version).to eq(0) }
    end

    context 'with events before initialization' do
      let(:events) { [1, 2] }

      it { expect(subject.initial_version).to eq(events.count) }
    end

    context 'with an events before and after initialization' do
      let(:events) { [1, 2] }
      let(:new_events) { [3, 4] }

      before { new_events.each { |event| subject.add_event(event) } }

      it { expect(subject.initial_version).to eq(events.count) }
    end
  end

  describe '#dirty?' do
    subject { described_class.new(events) }

    context 'no changes' do
      let(:events) { [1, 2] }

      it { expect(subject.dirty?).to eq(false) }
    end

    context 'with an events before and after initialization' do
      let(:events) { [1, 2] }
      let(:new_events) { [3, 4] }

      before { new_events.each { |event| subject.add_event(event) } }

      it { expect(subject.dirty?).to eq(true) }
    end
  end

  describe '#commit' do
    subject { described_class.new(events) }

    context 'with no changes' do
      let(:events) { [1, 2] }

      before { subject.commit }

      it { expect(subject.changes).to eq([]) }
    end

    context 'with an events before and after initialization' do
      let(:events) { [1, 2] }
      let(:new_events) { [3, 4] }

      before do
        new_events.each { |event| subject.add_event(event) }
        subject.commit
      end

      it { expect(subject.changes).to eq([]) }
    end
  end
end
