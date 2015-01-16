# events that happen within a stage, like keynote slide events

define_behavior :progression do
  setup do
    actor.has_attribute :progression_counter, 0
  end
end