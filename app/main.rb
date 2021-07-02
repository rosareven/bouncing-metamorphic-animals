def tick args
  defaults args
  render args
  input args
  calc args
  credits args
end

def defaults args
  args.state.animals          = [:Chinchilla, :Chipmunk, :Ferret, :Gerbil, :GuineaPig, :Hamster, :Hedgehog, :Mouse, :Squirrel]
  args.state.animal.size      = 100
  args.state.animal.speed     = 2
  args.state.animal.x       ||= args.grid.w.half - args.state.animal.size.half
  args.state.animal.y       ||= args.grid.h.half - args.state.animal.size.half
  args.state.animal.dx      ||= [1, -1].sample
  args.state.animal.dy      ||= [1, -1].sample
  args.state.animal.status  ||= :moving
  set_animal args           if !args.state.animal.choice
end

def render args
  tile_index = 0

  if args.state.animal.status == :moving
    sprite_index = tile_index.frame_index count: 2,
                                          hold_for: 20,
                                          repeat: true
  end

  sprite_index ||= 0

  args.outputs.sprites << {
    x: args.state.animal.x,
    y: args.state.animal.y,
    w: args.state.animal.size,
    h: args.state.animal.size,
    path: "sprites/#{args.state.animal.choice}.png",
    tile_x: 0 + (sprite_index * 16),
    tile_y: 0,
    tile_w: 16,
    tile_h: 16,
    flip_horizontally: args.state.animal.dx > 0,
  }
end

def input args
  return unless args.inputs.keyboard.key_down.space
  if args.state.animal.status == :moving
    args.state.animal.status = :stopped
  else
    args.state.animal.status = :moving
  end
end

def calc args
  return unless args.state.animal.status == :moving
  args.state.animal.x += args.state.animal.dx * args.state.animal.speed
  args.state.animal.y += args.state.animal.dy * args.state.animal.speed

  if (args.state.animal.x + args.state.animal.size) > args.grid.w
    args.state.animal.x = args.grid.w - args.state.animal.size
    args.state.animal.dx = -1
    set_animal args
  elsif args.state.animal.x < 0
    args.state.animal.x = 0
    args.state.animal.dx = 1
    set_animal args
  end
  
  if (args.state.animal.y + args.state.animal.size) > args.grid.h
    args.state.animal.y = args.grid.h - args.state.animal.size
    args.state.animal.dy = -1
    set_animal args
  elsif args.state.animal.y < 0
    args.state.animal.y = 0
    args.state.animal.dy = 1
    set_animal args
  end
end

def set_animal args
  args.state.animal.choice = (args.state.animals - [args.state.animal.choice]).sample
end

# Sprites from https://gamebowgames.itch.io/16x16-small-animals-for-use-with-gbstudio
def credits args
  args.outputs.labels << [args.grid.w.half, 50, "Sprites from GamebowGames @itch.io", 0, 1]
  args.outputs.labels << [args.grid.w.half, args.grid.h - 10, "#{args.state.animal.choice}", 0, 1]
end
