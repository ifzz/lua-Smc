
require 'Coat'
require 'Coat.Role'

role 'Smc.Visitor'

requires('visitFSM',
         'visitMap',
         'visitState',
         'visitTransition',
         'visitGuard',
         'visitAction',
         'visitParameter')

