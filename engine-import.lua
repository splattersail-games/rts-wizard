-- Importing lovetoys
require 'src.engine.Entity'
require 'src.engine.Engine'
require 'src.engine.System'
require 'src.engine.EventManager'
require 'src.engine.Component'
require 'src.engine.util'

-- Requiring all Components
require 'src.engine.components.Collidable'
require 'src.engine.components.Drawable'
require 'src.engine.components.Moveable'
require 'src.engine.components.Position'
require 'src.engine.components.Light'
require 'src.engine.components.Player.PlayerControlled'
require 'src.engine.components.Player.CommandQueue'
require 'src.engine.components.Logic.IsCamera'

-- Requiring all systems
require 'src.engine.systems.DrawCollisionBoxesSystem'
require 'src.engine.systems.DrawImageSystem'
require 'src.engine.systems.DrawSelectedSystem'
require 'src.engine.systems.events.SelectUnits'

-- Requiring all Events
require 'src.engine.events.ComponentAdded'
require 'src.engine.events.ComponentRemoved'
require 'src.engine.events.SelectionBoxReleased'

lovetoyDebug = true