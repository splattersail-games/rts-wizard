require 'src.engine.Entity'
require 'src.engine.Engine'
require 'src.engine.System'
require 'src.engine.EventManager'
require 'src.engine.Component'
require 'src.engine.util'

-- Requiring all Components
require 'src.engine.components'

-- Requiring all systems
require 'src.engine.systems'

-- Requiring all Events
require 'src.engine.events.ComponentAdded'
require 'src.engine.events.ComponentRemoved'
require 'src.engine.events.MousePressed'

lovetoyDebug = true