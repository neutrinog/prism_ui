require "prism"
require "./render_system.cr"
require "./block.cr"
require "./display.cr"
require "./color.cr"
require "./constraint_factory.cr"

module GUI
  class Engine < Prism::Engine
    include EventHandler
    @display = GUI::Display.new

    @[Override]
    def init
      # Register some default systems
      add_system Prism::Systems::InputSystem.new, 1
      add_system GUI::RenderSystem.new, 2

      # adds a full grey background to the screen (because it has no constraints)
      # @display.add GUI::Block.new(GUI::Color::GREY), GUI::ConstraintFactory.get_fill

      add_line

      # TODO: The UI should not use entitites to enter the rendering system.
      #  we should simply add a display to the render system on init
      entity = Prism::Entity.new
      entity.add @display
      add_entity entity
    end

    @[Override]
    def tick(tick : RenderLoop::Tick, input : RenderLoop::Input)
      @display.resize(input.window_size)
    end

    def add_line
      constraints = GUI::ConstraintFactory.get_default
      constraints.x = GUI::RelativeConstraint.new(0)
      constraints.y = GUI::CenterConstraint.new
      constraints.width = GUI::RelativeConstraint.new(1)
      constraints.height = GUI::PixelConstraint.new(20)
      @display.add GUI::Block.new(GUI::Color::WHITE), constraints
    end
  end
end
