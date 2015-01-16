(* ::Package:: *)

Exit[];


SetDirectory[FileNameJoin[{$HomeDirectory,"Documents","Dropbox","FeynLecture"}]]
<<FeynRules`;
LoadModel["phi4.fr"];


CheckHermiticity[Lagrangian]
CheckMassSpectrum[Lagrangian]
CheckKineticTermNormalisation[Lagrangian]
CheckDiagonalKineticTerms[Lagrangian]
CheckDiagonalMassTerms[Lagrangian]
CheckDiagonalQuadraticTerms[Lagrangian]


Exit[];


SetDirectory[ToFileName[{$HomeDirectory,"Documents","Dropbox","FeynLecture"}]]
<<FeynRules`;
LoadModel["phi4.fr"];
WriteFeynArtsOutput[Lagrangian];



