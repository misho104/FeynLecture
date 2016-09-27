(* ::Package:: *)

(* ::Subchapter:: *)
(*Codes for output*)


(* ::Text:: *)
(*Quit the kernel (by Quit[] or from menu) before executing each block!*)


(* Execute this block to generate UFO in Unitary gauge *)
SetDirectory[NotebookDirectory[]];
<<FeynRules`;
FR$Parallelize = False;

LoadModel["SM.fr"];
FeynmanGauge = False;
(*LoadRestriction["Cabibbo.rst", "Massless.rst"]*)
WriteUFO[LSM, Output->"Standard_Model_UFO_Unitary"];


(* Execute this block to generate FeynArts output *)
SetDirectory[NotebookDirectory[]];
<<FeynRules`;
FR$Parallelize=False;

LoadModel["SM.fr"];
FeynmanGauge = True;
(*LoadRestriction["Cabibbo.rst", "Massless.rst"]*)
WriteFeynArtsOutput[LSM, FlavorExpand->SU2W]


(* ::Subchapter:: *)
(*Model Validation*)


(* Execute this block to check the validity of the input *)
SetDirectory[NotebookDirectory[]];
<<FeynRules`;
FR$Parallelize = False;
LoadModel["SM.fr"];
FeynmanGauge = False;


CheckHermiticity[LSM, FlavorExpand->True]


CheckDiagonalMassTerms[LSM]


CheckMassSpectrum[LSM]


CheckDiagonalKineticTerms[LSM]


CheckKineticTermNormalisation[LSM, FlavorExpand->True]


CheckDiagonalQuadraticTerms[LSM]
