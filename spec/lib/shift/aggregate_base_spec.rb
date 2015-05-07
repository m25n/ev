require 'spec_helper'
require_relative '../../../lib/ev/event_root'

module EV
	class DummyModel < EventRoot
		def handle(event)
		end
	end

	describe EventRoot do
		describe ".new_from_events" do
			subject { EventRoot }

			it "does not call new" do
				expect(subject).to_not receive(:new)
				subject.new_from_events([])
			end

			describe "with events" do
				before do
					root = EventRoot.new
					expect(root).to receive(:handle).twice
					expect(subject).to receive(:allocate).and_return(root)
				end

				it "calls handle for each event" do
					subject.new_from_events([1, 2])
				end

				it "does not show changes" do
					root = subject.new_from_events([1, 2])
					expect(root.changes).to eq([])
				end

				it "increments the verison number" do
					root = subject.new_from_events([1, 2])
					expect(root.version).to eq(2)
				end
			end
		end

		describe "#apply" do
			subject { EventRoot.new }
			before do
				@event = {foo: :bar}
				expect(subject).to receive(:handle).with(@event)
			end

			it "calls handle" do
				subject.send(:apply, @event)
			end

			it "increments version" do
				expect(subject.version).to eq(0)
				subject.send(:apply, @event)
				expect(subject.version).to eq(1)
			end

			it "shows changes" do
				expect(subject.changes).to eq([])
				subject.send(:apply, @event)
				expect(subject.changes).to eq([@event])
			end

			it "duplicates the changes list" do
				subject.send(:apply, @event)
				subject.changes.shift
				expect(subject.changes.size).to eq(1)
			end
		end

		describe "#initial_version" do
			subject { DummyModel.new_from_events([1, 2])}

			it "works with no changes" do
				expect(subject.initial_version).to eq(2)
			end

			it "works with changes" do
				subject.send(:apply, 3)
				expect(subject.initial_version).to eq(2)
			end
		end

		describe "#dirty?" do
			subject { DummyModel.new_from_events([1,2]) }

			it "works with no changes" do
				expect(subject.dirty?).to eq(false)
			end

			it "works with changes" do
				subject.send(:apply, 3)
				expect(subject.dirty?).to eq(true)
			end
		end

		describe "#commit" do
			subject { DummyModel.new_from_events([1,2]) }

			it "works with no changes" do
				subject.commit
				expect(subject.dirty?).to eq(false)
			end

			it "works with changes" do
				subject.send(:apply, 3)
				subject.commit
				expect(subject.dirty?).to eq(false)
			end
		end
	end
end