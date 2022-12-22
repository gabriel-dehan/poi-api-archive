# Charon, the ferryman of Hades who carries souls of the newly deceased across the rivers Styx.
# He will do the same for our requests signed by services tokens.
# Charon is a custom middleware adding a layer of authorization to our API.
module Charon
  class NotAuthenticated < StandardError; end

  # TODO (L): Should be loaded from a config/config file
  INTERNAL_CLIENTS = ["poi-app", "poi-observer", "poi-server"]

end