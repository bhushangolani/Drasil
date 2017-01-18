{-# OPTIONS -Wall #-}
{-# LANGUAGE FlexibleContexts #-} 
module Drasil.SWHS.Concepts where

import Language.Drasil
import Data.Drasil.Concepts.Math (ode)
---Acronyms---
ordDiffEq,phsChgMtrl,rightSide,progName :: ConceptChunk

ordDiffEq   = ode

--FIXME: Acronyms
phsChgMtrl  = dcc "phsChgMtrl" "PCM" "Phase Change Material"
rightSide   = dcc "rightSide" "RHS" "Right Hand Side"
progName    = dcc "progName" "SWHS" "Solar Water Heating System"

-- I want to include SI as an acronym, but I can't find a way for the 
-- description to have accents when using dcc.

---ConceptChunks---

charging, coil, discharging, gauss_div, heat_flux, mech_energy,
  perfect_insul, phase_change_material, specific_heat, swhs_pcm, swhsProg, tank,
  tank_pcm, transient, water :: ConceptChunk

charging = dcc "charging" "Charging" "Charging of the tank"
coil = dcc "coil" "Heating coil" 
  "Coil in tank that heats by absorbing solar energy"
discharging = dcc "discharging" "Discharging" "Discharging of the tank"
gauss_div = dcc "gauss_div" "Gauss's Divergence theorem" 
  "FIXME: Define this"
heat_flux = dcc "heat_flux" "Heat flux" 
  "The rate of heat energy transfer per unit area."
  --FIXME: Heat flux needs to be a Unital Chunk
mech_energy = dcc "mech_energy" "Mechanical energy" 
  "The energy that comes from motion and position"
--TODO: Physical property.
perfect_insul = dcc "perfect_insul" "perfectly insulated" 
                ("Describes the property of a " ++
                "material not allowing heat transfer through its boundaries")
phase_change_material = dcc "pcm" "Phase Change Material (PCM)" 
      ("A substance that uses phase changes (such as melting) to absorb or " ++
      "release large amounts of heat at a constant temperature")
swhsProg = dcc "swhsProg" "SWHS" "SWHS program"
specific_heat = dcc "specific_heat" "Specific heat" 
  "Heat capacity per unit mass" 
  --FIXME: Specific Heat needs to be a UnitalChunk
swhs_pcm = dcc "swhs_pcm" "solar water heating systems incorporating PCM" 
  "Solar water heating systems incorporating phase change material"
tank = dcc "tank" "Tank" "Solar water heating tank"
tank_pcm = dcc "tank_pcm" "Solar water heating tank incorporating PCM" 
  "FIXME: Define this"
transient = dcc "transient" "Transient" "Changing with time"
water = dcc "water" "Water" "The liquid with which the tank is filled"