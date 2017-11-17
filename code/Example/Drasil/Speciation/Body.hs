module Drasil.Speciation.Body where
import Control.Lens ((^.))
import Language.Drasil
import qualified Drasil.SRS as SRS

import Drasil.DocumentLanguage

import Data.Drasil.SI_Units
import Data.Drasil.People (sPalmer, scottSmith)
import Data.Drasil.Concepts.Documentation (analysis, appendix, aspect,
  characteristic, class_, code, condition, constant, constraint, content,
  datum, definition, description, document, emphasis, endUser, failure,
  figure, goal, implementation, information, interface, input_, item,
  message, model, organization, output_, practice, problem, purpose, 
  quantity, reference, reviewer, section_, scenario, software, standard,
  symbol_, system, template, term_, theory, traceyMatrix, user, value, 
  variable, physicalSystem, datumConstraint, userInput, assumption, dataDefn, 
  goalStmt, inModel, likelyChg, physSyst, requirement, srs, thModel, 
  dataConst, acroNumGen, product_)
import Data.Drasil.Concepts.Education (frstYr, undergraduate, physChem)
import Data.Drasil.Software.Products (sciCompS)
import Data.Drasil.Concepts.Computation (computerApp, inParam,
  computerLiteracy, inValue, inQty)
import Data.Drasil.Concepts.Physics (distance)
import Data.Drasil.Concepts.Thermodynamics (degree_')
import Data.Drasil.Concepts.PhysicalProperties (flexure)
import Data.Drasil.Concepts.Software (correctness, verifiability,
  understandability, reusability, maintainability, portability,
  performance, errMsg)
import Data.Drasil.Concepts.Math (graph, calculation, probability,
  parameter, surface, equation, shape)
import Data.Drasil.Utils (getS, makeTMatrix, makeListRef, itemRefToSent,
  refFromType, enumSimple, enumBullet, prodUCTbl)
import Data.Drasil.SentenceStructures (acroA, acroR, sVersus, sAnd, foldlSP,
  foldlSent, foldlOptions, foldlSent_, figureLabel, foldlList, showingCxnBw,
  foldlsC, sOf, followA, ofThe, sIn, isThe, isExpctdToHv, sOr, underConsidertn,
  tAndDWAcc, tAndDOnly, tAndDWSym, andThe)
import Data.Drasil.Concepts.PhysicalProperties (dimension, materialProprty)

import Drasil.Speciation.Symbols
import Drasil.Speciation.Concepts

{-
import Drasil.GlassBR.Unitals (stressDistFac, aspectR, dimlessLoad,
  lateralLoad, sflawParamM, char_weight, sD, demand, lite, demandq,
  aspectRWithEqn, aspectR, lRe, wtntWithEqn, sdWithEqn,
  prob_br, notSafe, safeMessage, is_safe1, is_safe2, plate_width,
  plate_len, blast, glassTy, gbInputDataConstraints, explosion, lateral,
  load_dur, explosion, pb_tol, blast, bomb, blastTy, glassGeo,
  glass_type, nom_thick, sdx, sdy, sdz, tNT, gBRSpecParamVals,
  constant_LoadDur, constant_ModElas, constant_M, constant_K, loadTypes,
  load, glassTypes, probBreak, termsWithAccDefn, termsWithDefsOnly,
  gbConstants, gbConstrained, gbOutputs, gbInputs,
  glBreakage, capacity, constant_LoadDF, constant_LoadSF)
import Drasil.GlassBR.Symbols
import Drasil.GlassBR.Concepts (aR, lShareFac, gLassBR, stdOffDist,
  glaSlab, blastRisk, glass, responseTy, cantilever, beam, plane, edge,
  glaPlane, glassBRProg, ptOfExplsn, acronyms)
import Drasil.GlassBR.Changes (likelyChanges, unlikelyChanges)
import Drasil.GlassBR.Modules (modules)
import Drasil.GlassBR.Reqs (reqs)
import Drasil.GlassBR.TMods (tModels, t1SafetyReq, t2SafetyReq)
import Drasil.GlassBR.IMods (iModels, calOfCap, calOfDe, probOfBr)
import Drasil.GlassBR.DataDefs (dataDefns, gbQDefns, hFromt,
  strDisFac, nonFL, dimLL, glaTyFac, tolStrDisFac, tolPre)
import Drasil.GlassBR.References (gbCitations)
import Drasil.GlassBR.ModuleDefs
-}

import Drasil.Sections.ReferenceMaterial (intro)
import Drasil.Sections.TraceabilityMandGs (traceGIntro)
import Drasil.Sections.SpecificSystemDescription (solChSpecF,
  inDataConstTbl, outDataConstTbl, dataConstraintUncertainty, goalStmtF,
  physSystDesc, termDefnF, probDescF, specSysDesF)

{--}

resourcePath :: String
resourcePath = "../../../datafiles/Speciation/"

specn_srs :: Document
specn_srs = mkDoc mkSRS (for'' titleize phrase) specnSystInfo

mkSRS :: DocDesc
mkSRS = RefSec (RefProg intro [TUnits, tsymb [TSPurpose, SymbOrder], TAandA]) :
        IntroSec (
          IntroProg startIntro
          (short specgen)
          [ IPurpose s2_1_intro_p1,
            IScope scope1 scope2,
            IOrgSec s2_3_intro dataDefn (SRS.dataDefn SRS.missingP []) s2_3_intro_end,
            IChar EmptyS (phrase frstYr +:+ phrase undergraduate +:+ phrase physChem) EmptyS ] ) :
        StkhldrSec ( 
          StkhldrProg2 
          [ Client specgen (S "Dr." +:+ name scottSmith),
            Cstmr specgen ] ) :
        GSDSec (
          GSDProg2 [ UsrChars [s4_1_bullets], SystCons [] [] ] ) :
        []
  
  
  {- IntroSec (
    IntroProg (startIntro software blstRskInvWGlassSlab gLassBR)
      (short gLassBR)
    [IPurpose (s2_1_intro_p1 document gLassBR glaSlab),
     IScope incScoR endScoR,
     IChar (rdrKnldgbleIn glBreakage blastRisk) undIR appStanddIR,
     IOrgSec s2_3_intro dataDefn (SRS.dataDefn SRS.missingP []) s2_3_intro_end]) :
  StkhldrSec 
    (StkhldrProg2 
      [Client gLassBR (S "Entuitive. It is developed by Dr." +:+ name mCampidelli),
      Cstmr gLassBR]) :
  GSDSec (GSDProg2 [UsrChars [s4_1_bullets endUser gLassBR secondYear
    undergradDegree civilEng structuralEng glBreakage blastRisk], 
    SystCons [] []]) :
  ScpOfProjSec (ScpOfProjProg (short gLassBR) (s5_1_table) (s5_2 (glaSlab)
    (capacity) (demandq) (probability))) :
  SSDSec (SSDVerb s6) :
  {-SSDSec (SSDProg
    [SSDProblem  (PDProg start gLassBR ending [s6_1_1, s6_1_2, s6_1_3])
    , SSDSolChSpec (SCSProg
    [DDs [Label, Symbol, Units, DefiningEquation,
          Description Verbose IncludeUnits (S "Testing")] dataDefns]
    (symbolMap dataDefns))]) :-}
  ReqrmntSec (ReqsProg [
    FReqsSub s7_1_list, 
    NonFReqsSub [performance] (gBRpriorityNFReqs)
    (S "This problem is small in size and relatively simple")
    (S "Any reasonable" +:+ phrase implementation +:+.
    (S "will be very quick" `sAnd` S "use minimal storage"))]) :
  LCsSec (LCsProg s8_list) :
  TraceabilitySec
    (TraceabilityProg traceyMatrices [s9_table1Desc, s9_table2Desc, s9_table3Desc]
    (traceyMatrices ++ s9_intro2 ++ traceyGraphs) []) :
  AuxConstntSec (AuxConsProg gLassBR auxiliaryConstants) :
  Bibliography gbCitations :
  AppndxSec (AppndxProg [s12_intro, fig_5, fig_6]) : [] -}

specnSystInfo :: SystemInformation
specnSystInfo = SI {
  _sys         = specnProg,
  _kind        = srs,
  _authors     = [sPalmer],
  _units       = map UU [metre, second, kilogram] ++ map UU [pascal, newton],
  _quants      = specnSymbols,
  _concepts    = [] :: [CQSWrapper],
  _namedIdeas  = acronyms,
  _definitions = [],
  _inputs      = [] :: [QWrapper],
  _outputs     = [] :: [QWrapper],
  _defSequence = [],
  _constraints = [] :: [ConstrainedChunk],
  _constants   = [],
  _sysinfodb   = specnSymbMap
}
  --FIXME: All named ideas, not just acronyms.

{-- INTRO --}  
  
startIntro :: Sentence
startIntro = foldlSent [
  at_start $ the software, S "described in", 
  (phrase $ this document) `sC` S "herein called",
  short specgen `sC` S "aims to generate speciation diagrams"
  +:+ S "for aqueous chemical systems" ]
  
scope1, scope2 :: Sentence  
scope1 = S "collecting all" +:+ plural inParam
  +:+ S "that describe a chemical system"
scope2 = S "use the" +:+ plural datum 
  +:+ S "to produce a speciation diagram in the pH range 0 to 14"
 
s2_1_intro_p1 :: Sentence
s2_1_intro_p1 = foldlSent [S "The main", phrase purpose,
  S "of", phrase $ this document, S "is to describe", (plural $ the $ requirement),
  S "of", phrase $ a_ software, phrase product_, S "that will" 
  +:+ S "produce a speciation diagram given a set of chemical reactions and element"
  +:+. S "totals that define a chemical system as inputs", S "The", plural goal
  `sAnd` plural thModel, S "used in the", short specgen, phrase code,
  S "are provided" `sC` S "with an", phrase emphasis,
  S "on explicitly identifying", (plural assumption) `sAnd` S "unambiguous" +:+.
  plural definition, S "This", phrase document, S "is intended to be used as a",
  phrase reference, S "to provide all", phrase information,
  S "necessary to understand" `sAnd` S "verify the transformation of inputs"
  +:+. S "to outputs",
  S "The", short srs, S "is abstract:", plural $ the content, S "describe",
  phrase $ the problem, S "being solved" `sC` S "but not how to solve it"]

s2_3_intro_end, s2_3_intro :: Sentence
s2_3_intro = foldlSent [S "The", phrase organization, S "of this",
  phrase document, S "follows the", phrase template, S "for an", short srs,
  S "for", phrase sciCompS, S "proposed by" +:+ (sSqBrNum 1 {-koothoor2013-})
  `sAnd` (sSqBrNum 2 {-smithLai2005-}), sParen (S "in" +:+ (makeRef (SRS.reference SRS.missingP [])))
  `sC` S "with some", plural aspect, S "taken from Volere", phrase template,
  S "16", (sSqBrNum 3 {-rbrtsn2012-})]

s2_3_intro_end = foldl (+:+) EmptyS [(at_start' $ the dataDefn),
  S "are used to support", (plural definition `ofThe` S "different"),
  plural model]
 

{-- GENERAL SYSTEM DESCRIPTION --}
 
s4_1_bullets :: Contents
s4_1_bullets = enumBullet [ foldlSent [ (phrase endUser `sOf` short specgen)
  `isExpctdToHv` S "an understanding of chemical equilibria in" +:+.
  S "aqueous systems", (at_start endUser)
  `isExpctdToHv` S "basic", phrase computerLiteracy, S "to handle the",
  phrase software ] ]
  
{-

s6, s6_1, s6_1_1, s6_1_2, s6_1_3, s6_2 :: Section

s5_1_table,
  s6_1_2_list, s6_2_intro, s6_2_5_table1,
  s6_2_5_table2, s9_table1,
  s9_table2, s9_table3, s12_intro,
  fig_glassbr, fig_2, fig_3, fig_4, fig_5,
  fig_6 :: Contents

s7_1_list, s9_intro2 :: [Contents]

--------------------------------------------------------------------------------
s6_1_1_bullets :: Contents
s6_1_1_bullets = Enumeration $ (Number $
  map tAndDOnly termsWithDefsOnly
  ++
  s6_1_1_bullets_glTySubSec
  ++
  s6_1_1_bullets_loadSubSec
  ++
  map tAndDWAcc termsWithAccDefn
  ++
  [tAndDWSym probBreak prob_br])
   --FIXME: merge? Needs 2 arguments because there is no instance for (SymbolForm ConceptChunk)...

s6_1_1_bullets_glTySubSec, s6_1_1_bullets_loadSubSec :: [ItemType]

s6_1_1_bullets_glTySubSec = [Nested (((titleize glassTy) :+: S ":"))
  (Bullet $ map tAndDWAcc glassTypes)]

s6_1_1_bullets_loadSubSec = [Nested (((at_start load) :+: S ":"))
  (Bullet $ map tAndDWAcc (take 2 loadTypes)
  ++
  map tAndDOnly (drop 2 loadTypes))]

--Used in "Goal Statements" Section--
s6_1_3_list :: Contents
s6_1_3_list = enumSimple 1 (short goalStmt) s6_1_3_list_goalStmt1

--Used in "Assumptions" Section--
assumptionConstants :: [QDefinition]
assumptionConstants = [constant_M, constant_K, constant_ModElas,
  constant_LoadDur, constant_LoadDF, constant_LoadSF]

--Used in "Traceability Matrices and Graphs" Section--
traceyMatrices, traceyGraphs :: [Contents]
traceyMatrices = [s9_table1, s9_table2, s9_table3]
traceyGraphs = [fig_2, fig_3, fig_4]

solChSpecSubsections :: [CI]
solChSpecSubsections = [thModel, inModel, dataDefn, dataConst]

--Used in "Values of Auxiliary Constants" Section--
auxiliaryConstants :: [QDefinition]
auxiliaryConstants = assumptionConstants ++ gBRSpecParamVals

--Used in "Functional Requirements" Section--
requiredInputs :: [QWrapper]
requiredInputs = (map qs [plate_len, plate_width, char_weight])
  ++ (map qs [pb_tol, tNT]) ++ (map qs [sdx, sdy, sdz])
  ++ (map qs [glass_type, nom_thick])

s7_1_req6_pulledList :: [QDefinition]
s7_1_req6_pulledList = [nonFL, glaTyFac, dimLL, tolPre,
  tolStrDisFac, strDisFac, hFromt]

--Used in "Non-Functional Requirements" Section--
gBRpriorityNFReqs :: [ConceptChunk]
gBRpriorityNFReqs = [correctness, verifiability, understandability,
  reusability, maintainability, portability]

--------------------------------------------------------------------------------
UsrChars [s4_1_bullets endUser gLassBR secondYear
    undergradDegree civilEng structuralEng glBreakage blastRisk], 
    SystCons [] []]

{--GENERAL SYSTEM DESCRIPTION--}

{--User Characteristics--}

s4_1_bullets :: (NamedIdea n1, NamedIdea n, NamedIdea n2, NamedIdea n3,
  NamedIdea n4, NamedIdea n5, NamedIdea c, NamedIdea n6) =>
  n6 -> c -> n5 -> n4 -> n3 -> n2 -> n1 -> n -> Contents
s4_1_bullets intendedIndvdl progName yr degreeType prog1 prog2 undrstd1 undrstd2
  = enumBullet [foldlSent [(phrase endUser `sOf` short specgen)
  `isExpctdToHv` S "completed at least", (S "equivalent" `ofThe` (phrase yr)),
  S "of an", phrase degreeType `sIn` phrase prog1 `sOr` phrase prog2],
  (phrase intendedIndvdl `isExpctdToHv` S "an understanding of" +:+.
  rdrKnldgbleIn (undrstd1) (undrstd2)), foldlSent [phrase endUser
  `isExpctdToHv` S "basic", phrase computerLiteracy, S "to handle the",
  phrase software]]

{--System Constraints--}

{--SCOPE OF THE PROJECT-}

{--Product Use Case Table--}

s5_1_table = prodUCTbl [s5_1_table_UC1, s5_1_table_UC2]

s5_1_table_UC1, s5_1_table_UC2 :: [Sentence]

s5_1_table_UC1 = [titleize user, titleize' characteristic +:+ S "of the"
  +:+ phrase glaSlab `sAnd` S "of the" +:+. phrase blast +:+ S "Details in"
  +:+ makeRef (SRS.indPRCase SRS.missingP [])]

s5_1_table_UC2 = [short gLassBR, S "Whether" `sOr` S "not the" +:+
  phrase glaSlab +:+ S "is safe for the" +:+ S "calculated" +:+ phrase load
  `sAnd` S "supporting calculated" +:+ plural value]

{--Individual Product Use Case--}

s5_2 :: NamedChunk -> ConceptChunk -> ConceptChunk -> ConceptChunk ->
  Contents
s5_2 mainObj compare1 compare2 factorOfComparison =
  foldlSP [S "The", phrase user, S "provides the", plural input_, S "to",
  short gLassBR, S "for use within the" +:+. phrase analysis,
  S "There are two main", plural class_, S "of" +: plural input_ +:+.
  (phrase glassGeo `sAnd` phrase blastTy), S "The", phrase glassGeo, S "based",
  plural input_, S "include" +:+. (phrase glassTy `sAnd` plural dimension `ofThe`
  phrase glaPlane), blastTy ^. defn, S "These", plural parameter, S "describe"
  +:+. (phrase char_weight `sAnd` S "stand off blast"), S "Another",
  phrase input_, S "the", phrase user, S "gives is the tolerable" +:+.
  (phrase value `sOf` phrase prob_br)
  +:+
  short gLassBR, plural output_, S "if the", phrase mainObj,
  S "will be safe by comparing whether", phrase compare1, S "is greater than"
  +:+. phrase compare2, (at_start compare1 `isThe` (compare1 ^. defn))
  `sAnd` (phrase compare2 `isThe` phrase requirement) +:+.
  (S "which" `isThe` (compare2 ^. defn)), S "The second", phrase condition,
  S "is to check whether the calculated", phrase factorOfComparison,
  sParen (getS prob_br), S "is less than the tolerable",
  phrase factorOfComparison, sParen (getS pb_tol),
  S "which is obtained from the", phrase user, S "as an" +:+. phrase input_,
  S "If both", plural condition, S "return true then it's shown that the",
  phrase mainObj, S "is safe to use" `sC`
  S "else if both return false then the", phrase mainObj +:+.
  S "is considered unsafe", S "All the supporting calculated", plural value,
  S "are also displayed as", phrase output_]

{--SPECIFIC SYSTEM DESCRIPTION--}

s6 = specSysDesF (S "and" +:+ plural definition) [s6_1, s6_2]

{--PROBLEM DESCRIPTION--}

start, ending :: Sentence
start = foldlSent [S "A", phrase system,
  S "is needed to efficiently" `sAnd` S "correctly predict the",
  phrase blastRisk +:+ S "involved with the glass"]
ending = foldl (+:+) EmptyS [S "interpret the", plural input_,
  S "to give out the", plural output_,
  S "which predicts whether the", phrase glaSlab,
  S "can withstand the", phrase blast, S "under the",
  plural condition]

s6_1 = probDescF start gLassBR ending [s6_1_1, s6_1_2, s6_1_3]

{--Terminology and Definitions--}

s6_1_1 = termDefnF (Just (S "All" `sOf` S "the" +:+ plural term_ +:+
  S "are extracted from" +:+ (sSqBrNum 4 {-astm_LR2009-}) `sIn`
  (makeRef (SRS.reference SRS.missingP [])))) [s6_1_1_bullets]

{--Physical System Description--}

s6_1_2 = physSystDesc (short gLassBR) (fig_glassbr) [s6_1_2_list, fig_glassbr]

fig_glassbr = Figure (at_start $ the physicalSystem) (resourcePath ++ "physicalsystimage.png")

s6_1_2_list = enumSimple 1 (short physSyst) s6_1_2_list_physys

--"Dead" knowledge?
s6_1_2_list_physys :: [Sentence]
s6_1_2_list_physys1 :: Sentence
s6_1_2_list_physys2 :: NamedIdea n => n -> Sentence

s6_1_2_list_physys = [s6_1_2_list_physys1, s6_1_2_list_physys2 (ptOfExplsn)]

s6_1_2_list_physys1 = at_start glaSlab

s6_1_2_list_physys2 imprtntElem = foldlSent [S "The"
  +:+. phrase imprtntElem, S "Where the", phrase bomb `sC`
  S "or", (blast ^. defn) `sC` S "is located. The", phrase sD
  `isThe` phrase distance, S "between the", phrase imprtntElem `sAnd`
  S "the glass"]

{--Goal Statements--}

s6_1_3 = goalStmtF [foldlList [plural dimension `ofThe` phrase glaPlane,
  phrase glassTy, plural characteristic `ofThe` phrase explosion,
  S "the" +:+ phrase pb_tol]] [s6_1_3_list]

s6_1_3_list_goalStmt1 :: [Sentence]
s6_1_3_list_goalStmt1 = [foldlSent [S "Analyze" `sAnd` S "predict whether",
  S "the", phrase glaSlab, S "under consideration will be able to withstand",
  S "the", phrase explosion `sOf` S "a certain", phrase degree_',
  S "which is calculated based on", phrase userInput]]

{--SOLUTION CHARACTERISTICS SPECIFICATION--}

s6_2 = solChSpecF gLassBR (s6_1, (SRS.likeChg SRS.missingP [])) EmptyS
 (EmptyS, dataConstraintUncertainty, end)
 (s6_2_1_list, map gbSymbMapT tModels, [], map gbSymbMapD dataDefns,
  map gbSymbMapT iModels,
  [s6_2_5_table1, s6_2_5_table2]) []
  where
    end = foldlSent [(makeRef (SRS.valsOfAuxCons SRS.missingP [])),
      S "gives", (plural value `ofThe` S "specification"),
      plural parameter, S "used in", (makeRef s6_2_5_table1)]
      +:+ s6_2_5_intro2

s6_2_intro = foldlSP [S "This", phrase section_, S "explains all the",
  plural assumption, S "considered" `sAnd` S "the", plural thModel,
  S "which are supported by the", plural dataDefn]

{--Assumptions--}

s6_2_1_list :: [Contents]
s6_2_1_list = acroNumGen assumptions 1

assumptions :: [Contents]
assumptions = fst (foldr (\s (ls, n) -> ((mkAssump ("assumption" ++ show n) s) : ls, n-1))
 ([], (length assumptionDescs)::Int) assumptionDescs)
-- These correspond to glassTyAssumps, glassCondition, explsnScenario,
-- standardValues, glassLiteAssmp, bndryConditions, responseTyAssump, ldfConstant

assumptionDescs :: [Sentence]
assumptionDescs = [a1Desc, a2Desc, a3Desc, a4Desc load_dur, a5Desc, a6Desc, a7Desc, a8Desc constant_LoadDF]

a1Desc :: Sentence
a1Desc = foldlSent [S "The standard E1300-09a for",
  phrase calculation, S "applies only to", foldlOptions $ map S ["monolithic",
  "laminated", "insulating"], S "glass constructions" `sOf` S "rectangular",
  phrase shape, S "with continuous", phrase lateral +:+. S "support along",
  foldlOptions $ map S ["one", "two", "three", "four"], plural edge, S "This",
  phrase practice, S "assumes that", sParenNum 1, S "the supported glass",
  plural edge, S "for two, three" `sAnd` S "four-sided support",
  plural condition, S "are simply supported" `sAnd` S "free to slip in",
  phrase plane `semiCol` (sParenNum 2), S "glass supported on two sides acts",
  S "as a simply supported", phrase beam `sAnd` (sParenNum 3), S "glass",
  S "supported on one side acts as a", phrase cantilever]

a2Desc :: Sentence
a2Desc = foldlSent [S "Following", (sSqBr (S "4" {-astm_LR2009-} +:+ sParen 
  (S "pg. 1"))) `sC` S "this", phrase practice, 
  S "does not apply to any form of", foldlOptions $ map S ["wired",
  "patterned", "etched", "sandblasted", "drilled", "notched", "grooved glass"],
  S "with", phrase surface `sAnd`
  S "edge treatments that alter the glass strength"]

a3Desc :: Sentence
a3Desc = foldlSent [S "This", phrase system,
  S "only considers the external", phrase explosion, phrase scenario,
  S "for its", plural calculation]

a4Desc :: UnitaryChunk -> Sentence
a4Desc mainIdea = foldlSent [S "The", plural value, S "provided in",
  makeRef (SRS.valsOfAuxCons SRS.missingP []), S "are assumed for the",
  phrase mainIdea, sParen (getS mainIdea) `sC` S "and the",
  plural materialProprty `sOf` foldlList (map getS
  (take 3 assumptionConstants))]

a5Desc :: Sentence
a5Desc = foldlSent [at_start glass, S "under consideration",
  S "is assumed to be a single" +:+. phrase lite, S "Hence the",
  phrase value `sOf` short lShareFac, S "is equal to 1 for all",
  plural calculation `sIn` short gLassBR]

a6Desc :: Sentence
a6Desc = foldlSent [S "Boundary", plural condition, S "for the",
  phrase glaSlab, S "is assumed to be 4-sided support for",
  plural calculation]

a7Desc :: Sentence
a7Desc = foldlSent [S "The", phrase responseTy, S "considered in",
  short gLassBR, S "is flexural"]

a8Desc :: QDefinition -> Sentence
a8Desc mainConcept = foldlSent [S "With", phrase reference, S "to",
  acroA 4, S "the", phrase value `sOf` phrase mainConcept,
  sParen (getS mainConcept), S "is a", phrase constant, S "in" +:+.
  short gLassBR, S "It is calculated by the" +: phrase equation +:+.
  E (C mainConcept := equat mainConcept), S "Using this" `sC`
  E (C mainConcept := (Dbl 0.27))]

{--Theoretical Models--}

{--Data Definitions--}

{--Data Constraints--}

{-input and output tables-}

s6_2_5_table1 = inDataConstTbl gbInputDataConstraints
s6_2_5_table2 = outDataConstTbl [prob_br]

s6_2_5_intro2 :: Sentence
s6_2_5_intro2 = foldlSent [makeRef s6_2_5_table2, S "shows the",
  plural constraint, S "that must be satisfied by the", phrase output_]

{--REQUIREMENTS--}

{--Functional Requirements--}

s7_1_list = (acroNumGen s7_1_listOfReqs 1) ++ s7_1_req6 ++ [s7_1_req1Table]

s7_1_req1, s7_1_req2, s7_1_req3, s7_1_req4, s7_1_req5 :: Contents
req1Desc, req2Desc, req3Desc, req4Desc :: Sentence
req5Desc :: NamedChunk -> Sentence
s7_1_req6 :: [Contents] --FIXME: Issue #327

s7_1_listOfReqs :: [Contents]
s7_1_listOfReqs = [s7_1_req1, s7_1_req2, s7_1_req3, s7_1_req4, s7_1_req5]

s7_1_req1 = mkRequirement "s7_1_req1" req1Desc
s7_1_req2 = mkRequirement "s7_1_req2" req2Desc
s7_1_req3 = mkRequirement "s7_1_req3" req3Desc
s7_1_req4 = mkRequirement "s7_1_req4" req4Desc
s7_1_req5 = mkRequirement "s7_1_req5" (req5Desc (output_))

req1Desc = foldlSent [at_start input_, S "the", plural quantity, S "from",
  makeRef s7_1_req1Table `sC` S "which define the", phrase glass,
  plural dimension `sC` (glassTy ^. defn) `sC` S "tolerable",
  phrase probability `sOf` phrase failure, S "and",
  (plural characteristic `ofThe` phrase blast), S "Note:",
  getS plate_len `sAnd` getS plate_width,
  S "will be input in terms of", plural millimetre `sAnd`
  S "will be converted to the equivalent value in", plural metre]

s7_1_req1Table :: Contents
s7_1_req1Table = Table
  [at_start symbol_, at_start description, S "Units"]
  (mkTable
  [(\ch -> getS ch),
   at_start, unit'2Contents] requiredInputs)
  (S "Required Inputs following R1") True

req2Desc = foldlSent [S "The", phrase system,
  S "shall set the known", plural value +: S "as follows",
  foldlList [(foldlsC (map getS (take 4 assumptionConstants)) `followA` 4),
  ((getS constant_LoadDF) `followA` 8), (short lShareFac `followA` 5)]]

--ItemType
{-s7_1_req2 = (Nested (S "The" +:+ phrase system +:+
   S "shall set the known" +:+ plural value +: S "as follows")
    (Bullet $ map Flat
     [foldlsC (map getS (take 4 assumptionConstants)) `followA` 4,
     (getS loadDF) `followA` 8,
     short lShareFac `followA` 5]))
-}
--FIXME:should constants, LDF, and LSF have some sort of field that holds
-- the assumption(s) that're being followed? (Issue #349)

req3Desc = foldlSent [S "The", phrase system, S "shall check the entered",
  plural inValue, S "to ensure that they do not exceed the",
  plural datumConstraint, S "mentioned in" +:+. makeRef
  (SRS.datCon SRS.missingP []), S "If any" `sOf` S "the", plural inParam,
  S "is out" `sOf` S "bounds" `sC` S "an", phrase errMsg, S "is displayed"
  `andThe` plural calculation, S "stop"]

req4Desc = foldlSent [titleize output_, S "the", plural inQty,
  S "from", acroR 1 `andThe` S "known", plural quantity,
  S "from", acroR 2]

req5Desc cmd = foldlSent_ [S "If", (getS is_safe1) `sAnd` (getS is_safe2),
  sParen (S "from" +:+ (makeRef (gbSymbMapT t1SafetyReq))
  `sAnd` (makeRef (gbSymbMapT t2SafetyReq))), S "are true" `sC`
  phrase cmd, S "the", phrase message, Quote (safeMessage ^. defn),
  S "If the", phrase condition, S "is false, then", phrase cmd,
  S "the", phrase message, Quote (notSafe ^. defn)]

testing :: [QWrapper]
testing = qs prob_br : qs lRe : qs demand : [] -- all different types!
testing1 :: [RelationConcept]
testing1 = [probOfBr, calOfCap, calOfDe]
--FIXME: rename or find better implementation?

s7_1_req6 = [(Enumeration $ Simple $ [(acroR 6, Nested (titleize output_ +:+
  S "the following" +: plural quantity)
  (Bullet $
    map (\(a, d) -> Flat $ (at_start a) +:+ sParen (getS a) +:+
    sParen (makeRef (gbSymbMapT d))) (zip testing testing1)
    ++
    map (\d -> Flat $ (at_start d) +:+ sParen (getS d) +:+
    sParen (makeRef (gbSymbMapD d))) s7_1_req6_pulledList
    ++
    [Flat $ (titleize aspectR) +:+ sParen (getS aspectR) +:+
    E (equat aspectRWithEqn)]
    ))])]

{--Nonfunctional Requirements--}

{--LIKELY CHANGES--}

s8_list :: [Contents]
s8_list = acroNumGen likelyChanges_SRS 1

likelyChanges_SRS :: [Contents]
likelyChanges_SRS = [s8_likelychg1, s8_likelychg2, s8_likelychg3,
  s8_likelychg4, s8_likelychg5]

s8_likelychg1, s8_likelychg2, s8_likelychg3, s8_likelychg4,
  s8_likelychg5 :: Contents

s8_likelychg1 = mkLklyChnk "s8_likelychg1" (lc1Desc (blastRisk))
s8_likelychg2 = mkLklyChnk "s8_likelychg2" (lc2Desc)
s8_likelychg3 = mkLklyChnk "s8_likelychg3" (lc3Desc)
s8_likelychg4 = mkLklyChnk "s8_likelychg4" (lc4Desc)
s8_likelychg5 = mkLklyChnk "s8_likelychg5" (lc5Desc)

lc1Desc :: NamedChunk -> Sentence
lc2Desc, lc3Desc, lc4Desc, lc5Desc :: Sentence

lc1Desc mainConcept = foldlSent [acroA 3 `sDash` S "The",
  phrase system, S "currently only calculates for external" +:+.
  phrase mainConcept, S "In the future", plural calculation,
  S "can be added for the internal", phrase mainConcept]

lc2Desc = foldlSent [acroA 4 `sC` (acroA 8 `sDash`
  S "Currently the"), plural value, S "for",
  foldlList (map getS (take 3 assumptionConstants)),
  S "are assumed to be the same for all" +:+. phrase glass,
  S "In the future these", plural value, S "can be changed to",
  phrase variable, plural input_]

lc3Desc = foldlSent [acroA 5 `sDash` S "The", phrase software,
  S "may be changed to accommodate more than a single", phrase lite]

lc4Desc = foldlSent [acroA 6 `sDash` S "The", phrase software,
  S "may be changed to accommodate more boundary", plural condition,
  S "than 4-sided support"]

lc5Desc = foldlSent [acroA 7 `sDash` S "The", phrase software,
  S "may be changed to consider more than just", phrase flexure,
  S "of the glass"]

{--TRACEABLITY MATRICES AND GRAPHS--}

s9_table1Desc :: Sentence
s9_table1Desc = foldlList (map plural (take 3 solChSpecSubsections)) +:+.
  S "with each other"

s9_table2Desc :: Sentence
s9_table2Desc = plural requirement +:+ S "on" +:+. foldlList
  (map plural solChSpecSubsections)

s9_table3Desc :: Sentence
s9_table3Desc = foldlsC (map plural (take 3 solChSpecSubsections)) `sC`
  plural likelyChg `sAnd` plural requirement +:+ S "on the" +:+
  plural assumption

s9_theorys, s9_instaModel, s9_dataDef, s9_data, s9_funcReq, s9_assump,
  s9_likelyChg :: [String]

s9_theorysRef, s9_instaModelRef, s9_dataDefRef, s9_dataRef, s9_funcReqRef,
  s9_assumpRef, s9_likelyChgRef :: [Sentence]

s9_theorys = ["T1", "T2"]
s9_theorysRef = map (refFromType Theory) tModels

s9_instaModel = ["IM1", "IM2", "IM3"]
s9_instaModelRef = map (refFromType Theory) iModels

s9_dataDef =  ["DD1", "DD2", "DD3", "DD4", "DD5", "DD6", "DD7", "DD8"]
s9_dataDefRef = map (refFromType Data) dataDefns

s9_data  = ["Data Constraints"]
s9_dataRef = [makeRef (SRS.datCon SRS.missingP [])]

s9_funcReq = ["R1", "R2", "R3", "R4", "R5", "R6"]
s9_funcReqRef = makeListRef s9_funcReq (SRS.funcReq SRS.missingP [])

s9_assump = ["A1", "A2", "A3", "A4", "A5", "A6", "A7", "A8"]
s9_assumpRef = makeListRef s9_assump (SRS.assump SRS.missingP [])

s9_likelyChg = ["LC1", "LC2", "LC3", "LC4", "LC5"]
s9_likelyChgRef = makeListRef s9_likelyChg (SRS.likeChg SRS.missingP [])

s9_row_t1 :: [String]
s9_row_t1 = s9_theorys ++ s9_instaModel ++ s9_dataDef

-- The headers for the first row, and column
s9_row_header_t1 :: [Sentence]
s9_row_header_t1 = zipWith itemRefToSent s9_row_t1 (s9_theorysRef ++
  s9_instaModelRef ++ s9_dataDefRef)

-- list of columns and their rows for traceability matrix
s9_columns_t1 :: [[String]]
s9_columns_t1 = [s9_t1_T1, s9_t1_T2, s9_t1_IM1, s9_t1_IM2, s9_t1_IM3,
  s9_t1_DD1, s9_t1_DD2, s9_t1_DD3, s9_t1_DD4, s9_t1_DD5, s9_t1_DD6, s9_t1_DD7,
  s9_t1_DD8]

s9_t1_T1, s9_t1_T2, s9_t1_IM1, s9_t1_IM2, s9_t1_IM3, s9_t1_DD1, s9_t1_DD2,
  s9_t1_DD3, s9_t1_DD4, s9_t1_DD5, s9_t1_DD6, s9_t1_DD7, s9_t1_DD8 :: [String]

-- list of each item that "this" item requires for traceability matrix
s9_t1_T1  = ["T2", "IM1"]
s9_t1_T2  = ["T1", "IM2", "IM3"]
s9_t1_IM1 = ["DD1", "DD2", "DD3"]
s9_t1_IM2 = ["DD4", "DD5"]
s9_t1_IM3 = []
s9_t1_DD1 = []
s9_t1_DD2 = []
s9_t1_DD3 = ["DD6"]
s9_t1_DD4 = ["DD2", "DD6"]
s9_t1_DD5 = []
s9_t1_DD6 = ["IM3", "DD2", "DD5"]
s9_t1_DD7 = ["DD8"]
s9_t1_DD8 = ["DD2"]

s9_table1 = Table (EmptyS:s9_row_header_t1)
  (makeTMatrix s9_row_header_t1 s9_columns_t1 s9_row_t1)
  (showingCxnBw (traceyMatrix)
  (titleize' item +:+ S "of Different" +:+ titleize' section_)) True

--

s9_row_t2 :: [String]
s9_row_t2 = s9_row_t1 ++ s9_data ++ s9_funcReq

s9_row_header_t2, s9_col_header_t2 :: [Sentence]
s9_row_header_t2 = s9_row_header_t1 ++
  (zipWith itemRefToSent (s9_data ++ s9_funcReq) (s9_dataRef ++ s9_funcReqRef))

s9_col_header_t2 = zipWith (\x y -> (S x) +:+ (sParen (S "in" +:+ y)))
  s9_funcReq s9_funcReqRef

s9_t2_r1, s9_t2_r2, s9_t2_r3, s9_t2_r4, s9_t2_r5,
  s9_t2_r6 :: [String]

s9_columns_t2 :: [[String]]
s9_columns_t2 = [s9_t2_r1, s9_t2_r2, s9_t2_r3, s9_t2_r4, s9_t2_r5, s9_t2_r6]
s9_t2_r1 = []
s9_t2_r2 = []
s9_t2_r3 = ["Data Constraints"]
s9_t2_r4 = ["R1", "R2"]
s9_t2_r5 = ["T1", "T2"]
s9_t2_r6 = ["IM1", "IM2", "IM3", "DD2", "DD3", "DD4", "DD5", "DD6", "DD7", "DD8"]

s9_table2 = Table (EmptyS:s9_row_header_t2)
  (makeTMatrix s9_col_header_t2 s9_columns_t2 s9_row_t2)
  (showingCxnBw (traceyMatrix) (titleize' requirement `sAnd` S "Other" +:+
  titleize' item)) True

--

s9_row_t3 :: [String]
s9_row_t3 = s9_assump

s9_row_header_t3, s9_col_header_t3 :: [Sentence]
s9_row_header_t3 = zipWith itemRefToSent s9_assump s9_assumpRef

s9_col_header_t3 = s9_row_header_t1 ++ (zipWith itemRefToSent
  (s9_likelyChg ++ s9_funcReq) (s9_likelyChgRef ++ s9_funcReqRef))

s9_columns_t3 :: [[String]]
s9_columns_t3 = [s9_t3_T1, s9_t3_T2, s9_t3_IM1, s9_t3_IM2, s9_t3_IM3, s9_t3_DD1,
  s9_t3_DD2, s9_t3_DD3, s9_t3_DD4, s9_t3_DD5, s9_t3_DD6, s9_t3_DD7, s9_t3_DD8,
  s9_t3_lc1, s9_t3_lc2, s9_t3_lc3, s9_t3_lc4, s9_t3_lc5, s9_t3_r1, s9_t3_r2,
  s9_t3_r3, s9_t3_r4, s9_t3_r5, s9_t3_r6]

s9_t3_T1, s9_t3_T2, s9_t3_IM1, s9_t3_IM2, s9_t3_IM3, s9_t3_DD1, s9_t3_DD2,
  s9_t3_DD3, s9_t3_DD4, s9_t3_DD5, s9_t3_DD6, s9_t3_DD7, s9_t3_DD8,
  s9_t3_lc1, s9_t3_lc2, s9_t3_lc3, s9_t3_lc4, s9_t3_lc5, s9_t3_r1,
  s9_t3_r2, s9_t3_r3, s9_t3_r4, s9_t3_r5, s9_t3_r6 :: [String]

-- list of each item that "this" item requires for traceability matrix
s9_t3_T1  = []
s9_t3_T2  = []
s9_t3_IM1 = ["A4", "A6", "A7"]
s9_t3_IM2 = ["A1", "A2", "A5"]
s9_t3_IM3 = []
s9_t3_DD1 = []
s9_t3_DD2 = []
s9_t3_DD3 = []
s9_t3_DD4 = ["A4"]
s9_t3_DD5 = []
s9_t3_DD6 = ["A5"]
s9_t3_DD7 = []
s9_t3_DD8 = ["A4"]
s9_t3_lc1 = ["A3"]
s9_t3_lc2 = ["A4", "A8"]
s9_t3_lc3 = ["A5"]
s9_t3_lc4 = ["A6"]
s9_t3_lc5 = ["A7"]
s9_t3_r1  = []
s9_t3_r2  = ["A4", "A5", "A8"]
s9_t3_r3  = []
s9_t3_r4  = []
s9_t3_r5  = []
s9_t3_r6  = []

s9_table3 = Table (EmptyS:s9_row_header_t3)
  (makeTMatrix s9_col_header_t3 s9_columns_t3 s9_row_t3)
  (showingCxnBw (traceyMatrix) (titleize' assumption `sAnd` S "Other"
  +:+ titleize' item)) True

--

s9_intro2 = traceGIntro traceyGraphs
  [(foldlList (map plural (take 3 solChSpecSubsections)) +:+.
  S "on each other"), (plural requirement +:+ S "on" +:+. foldlList
  (map plural solChSpecSubsections)),
  (foldlList ((map plural (take 3 solChSpecSubsections))++
  [plural requirement, plural likelyChg +:+ S "on" +:+ plural assumption]))]

fig_2 = figureLabel 2 (traceyMatrix)
  (titleize' item +:+ S "of Different" +:+ titleize' section_)
  (resourcePath ++ "Trace.png")

fig_3 = figureLabel 3 (traceyMatrix)
  (titleize' requirement `sAnd` S "Other" +:+ titleize' item)
  (resourcePath ++ "RTrace.png")

fig_4 = figureLabel 4 (traceyMatrix)
  (titleize' assumption `sAnd` S "Other" +:+ titleize' item)
  (resourcePath ++ "ATrace.png")

{--VALUES OF AUXILIARY CONSTANTS--}

{--REFERENCES--}

{--APPENDIX--}

s12_intro = foldlSP [
  S "This", phrase appendix, S "holds the", plural graph,
  sParen ((makeRef fig_5) `sAnd` (makeRef fig_6)),
  S "used for interpolating", plural value, S "needed in the", plural model]

fig_5 = Figure (titleize figure +: S "5" +:+ (demandq ^. defn) +:+
  sParen (getS demand) `sVersus` at_start sD +:+ sParen (getAcc stdOffDist)
  `sVersus` at_start char_weight +:+ sParen (getS sflawParamM))
  (resourcePath ++ "ASTM_F2248-09.png")

fig_6 = Figure (titleize figure +: S "6" +:+ S "Non dimensional" +:+
  phrase lateralLoad +:+ sParen (getS dimlessLoad)
  `sVersus` titleize aspectR +:+ sParen (getAcc aR)
  `sVersus` at_start stressDistFac +:+ sParen (getS stressDistFac))
  (resourcePath ++ "ASTM_F2248-09_BeasonEtAl.png")

blstRskInvWGlassSlab :: Sentence
blstRskInvWGlassSlab = phrase blastRisk +:+ S "involved with the" +:+
  phrase glaSlab
-}