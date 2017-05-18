module Data.Drasil.Changes where

import Language.Drasil
import Data.Drasil.Modules

{-likely changes-}

lcHW :: LCChunk
lcHW      = LCChunk (nw $ npnc "hardware" (nounPhraseSP
  "The specific hardware on which the software is running.")
  ) [mod_hw]

lcCtrl, lcInputF, lcOutputF, lcArray, lcRng, lcPlot, lcVect, lcTree, 
  lcHash :: ModuleChunk -> LCChunk

lcCtrl    mod_ctrl    = LCChunk (nw $ npnc "control" (nounPhraseSP
  "The algorithm for the overall operation procedure of the program.")
  ) [mod_ctrl]
  
lcInputF  mod_inputf  = LCChunk (nw $ npnc "input" (nounPhraseSP
  "The format of the initial input data.")
  ) [mod_inputf]
  
lcOutputF mod_outputf = LCChunk (nw $ npnc "output" (nounPhraseSP
  "The format of the final output data.")
  ) [mod_outputf]
  
lcArray   mod_sds     = LCChunk (nw $ npnc "array" (nounPhraseSP
  "The implementation for the sequence (array) data structure.")
  ) [mod_sds]

lcRng     mod_rng     = LCChunk (nw $ npnc "rand" (nounPhraseSP
  "The method of generating pseudo-random numbers.")
  ) [mod_rng]
  
lcPlot    mod_plot    = LCChunk (nw $ npnc "plot" (nounPhraseSP
  "The method of displaying the final output.")
  ) [mod_plot]

lcTree    mod_link    = LCChunk (nw $ npnc "tree" (nounPhraseSP $ 
  "The implementation of the linked (tree) data structure."))
  [mod_link]

lcHash    mod_asso    = LCChunk (nw $ npnc "hash table" (nounPhraseSP $ 
  "The implementation of the associative (hash table) data structure."))
  [mod_asso]

lcVect   mod_vect     = LCChunk (nw $ npnc "vector" (nounPhraseSP $ 
  "The implementation of mathematical vectors."))
  [mod_vect]

{-Unlikely Changes-}

ucIO, ucInputS, ucOutput, ucCart, uc2D :: UCChunk

ucIO     = nw $ npnc "IO" (nounPhraseSP $
  "Input/Output devices (Input: File and/or Keyboard, Output: File, " ++
  "Memory, and/or Screen).")

ucInputS = nw $ npnc "inputsource" (nounPhraseSP
  "There will always be a source of input data external to the software.")

ucOutput = nw $ npnc "output" (nounPhraseSP
  "Output data are displayed to the output device.")

ucCart = nw $ npnc "Cartesian" 
  (nounPhraseSP "A Cartesian coordinate system is used.")

uc2D = nw $ npnc "2D" (nounPhraseSP "All objects are 2D.")