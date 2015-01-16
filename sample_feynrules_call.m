(* ::Package:: *)

Exit[];


SetDirectory[FileNameJoin[{$HomeDirectory,"FeynLecture"}]]
<<FeynRules`;
LoadModel["phi4.fr"];


CheckHermiticity[Lagrangian]
CheckMassSpectrum[Lagrangian]
CheckKineticTermNormalisation[Lagrangian]
CheckDiagonalKineticTerms[Lagrangian]
CheckDiagonalMassTerms[Lagrangian]
CheckDiagonalQuadraticTerms[Lagrangian]


Exit[];


SetDirectory[ToFileName[{$HomeDirectory,"FeynLecture"}]]
<<FeynRules`;
LoadModel["phi4.fr"];
WriteFeynArtsOutput[Lagrangian];






