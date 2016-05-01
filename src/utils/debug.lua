--[[
A little bit of simple lua code to print debug messages
API notes:
- registerScope, takes a string scope name and a boolean value of whether to actually print these messages
- debug, takes a string message, severity (logger.logLevel values), and scopename
]]
require 'src.utils.stack'

local logger = {}
logger.logLevel = {
  NONE = -1,
  DEBUG = 0,
  WARN = 1,
  CRITICAL = 2
}
logger.scopes = {}
logger.currentScope = nil
NewStack(logger)
logger.setScope = function(scopeName, logLevel)
  assert(logLevel >= logger.logLevel.NONE and logLevel <= logger.logLevel.CRITICAL,
    "Invalid log level " .. logLevel .. ". Do you think this is a fucking game?"
  )
  logger.scopes[scopeName] = logLevel
  logger:push(scopeName)
  logger.currentScope = scopeName
end
logger.endScope = function()
  logger.currentScope = logger:pop()
end

logger.message = function(msg, msgLogLevel)
  if logger.currentScope then
    local logLevel = logger.scopes[logger.currentScope]
    if logLevel >= msgLogLevel then
      print ("[" .. logger.currentScope .. "] " .. msg)
    end
  else
    print(msg)
  end
end

logger.debug = function(msg)
  logger.message(msg, logger.logLevel.DEBUG)
end

logger.warn = function(msg)
  logger.message(msg, logger.logLevel.WARN)
end

logger.critical = function(msg)
  logger.message(msg, logger.logLevel.CRITICAL)
end

return logger