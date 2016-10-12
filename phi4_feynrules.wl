(* ::Package:: *)

(* ::Subchapter:: *)
(*Validation*)


(* ::Text:: *)
(*Quit the kernel (by Quit[] or from menu) before executing these blocks!*)


SetDirectory[NotebookDirectory[]];
<<FeynRules`;
FR$Parallelize = False;
LoadModel["phi4.fr"];
ExpandedLagrangian = ExpandIndices[Lagrangian, FlavorExpand->True];


CheckHermiticity[ExpandedLagrangian]


CheckDiagonalMassTerms[ExpandedLagrangian]


CheckMassSpectrum[ExpandedLagrangian]


CheckDiagonalKineticTerms[ExpandedLagrangian]


CheckKineticTermNormalisation[ExpandedLagrangian]


CheckDiagonalQuadraticTerms[ExpandedLagrangian]


(* ::Subchapter:: *)
(*Codes for generate UFO*)


(* ::Text:: *)
(*Quit the kernel (by Quit[] or from menu) before executing this block!*)


SetDirectory[NotebookDirectory[]];
<<FeynRules`;
FR$Parallelize = False;
LoadModel["phi4.fr"];
WriteUFO[Lagrangian];


(* ::Subchapter:: *)
(*Codes for generate FeynArts output*)


(* ::Text:: *)
(*Quit the kernel (by Quit[] or from menu) before executing this block!*)


SetDirectory[NotebookDirectory[]];
<<FeynRules`;
FR$Parallelize = False;
LoadModel["phi4.fr"];
WriteFeynArtsOutput[Lagrangian];
