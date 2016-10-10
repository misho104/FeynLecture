# Tools for BSM Physics: Appendices

.author[
  [Sho Iwamoto](http://www.misho-web.com)
  ![:height 1em](assets/ShoIwamoto_ja.png)

  .logo[
    ![Technion - Israel Institute of Technology](assets/Technion_he.png)
  ]
]


.location[
  11&ndash;14 Oct 2016 <br>
  Yonsei University
]

.copyright[
  &copy; 2012&ndash;2016 <a href="http://www.misho-web.com">Sho Iwamoto</a>

  These lecture slides are licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">Creative Commons Attribution-NonCommercial 4.0 International License</a>.

  Lecture materials are available at [https://github.com/misho104/FeynLecture/](https://github.com/misho104/FeynLecture/).

  <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/"><img alt="Creative Commons License" style="border-width:0" src="assets/cc_by_nc.png" /></a>
]

---
name: organize_codes

### Appendix I:<br> How should we organize the codes?

.note[
    This appendix is written for experts with deep knowledge of shell, scripts, and tools, and aims to give them several notions for better installation of the packages.
    **Beginners should NOT follow these advices.**
    I recommend beginners to follow the basic way and to concentrate on physics; do not spend too much time on the installation itself.]

.notes[
In the lecture course we have installed the packages in `~/codes`, and the paths are `~/codes/FeynArts-3.9` etc.
One improvement is to create a symbolic link, like
```sh
> cd ~/codes
> ls

FeynArts-3.9    FormCalc-9.4    LoopTools-2.13    feynrules-current

> ln -s FeynArts-3.9 FeynArts
```
  and
```mathematica
> AppendTo[$Path, "~/codes/FeynArts"]
```
]

---
.notes[
Then you do not have to update the `AppendTo` codes when you upgrade your packages to the latest versions.
Also you can write the `AppendTo` codes in the script `init.m`, which is automatically loaded by Mathematica (look up "init.m" in Mathematica help; on macos it is usually as `~/Library/Mathematica/Kernel/init.m`).
![:code_title](init.m)
```mathematica
(** User Mathematica initialization file **)

AppendTo[$Path, "~/codes/FeynArts"]
AppendTo[$Path, "~/codes/FormCalc"]
AppendTo[$Path, "~/codes/LoopTools"]

$FeynRulesPath = "~/codes/FeynRules";
AppendTo[$Path, $FeynRulesPath]
```

However, this is not an ideal way for scientific purpose because it breaks reproducability.
Imagine you have Project A with FeynArts 3.9, and it is compileted.
You started a new project B.
During Project B you updated FeynArts to 4.0.
The symlink now points FeynArts 4.0, and it is not straightforward to reproduce the results of Project A.
]

---
.notes[
Therefore it is better to symlink them *directly from your project*, keeping all the version you used in your computer.
```sh
> cd ~/projects/A
> mkdir vendor
> cd vendor
> ln -s ~/codes/FeynArts-3.9 FeynArts
```
![:code_title](~/projects/A/notes/crosssection.nb)
```mathematica
AppendTo[$Path, FileNameJoin[{NotebookDirectory[], "..", "vendor", "FeynArts"}]]
```

Now you do not prepare `$Path` in `init.m`.
Rather I recommend to write a function to prepare `$Path` so that you can use the "default" packages in your scratch code by typing `UseDefaultPackages[]`:
![:code_title](init.m)
```mathematica
(** User Mathematica initialization file **)

UseDefaultPackages = Function[
  AppendTo[$Path, "~/codes/FeynArts"];
  AppendTo[$Path, "~/codes/FormCalc"];
  AppendTo[$Path, "~/codes/LoopTools"];
  $FeynRulesPath = "~/codes/FeynArts";
  AppendTo[$Path, $FeynRulesPath];
];
```

To be more careful, you can store the package files together with the project data; you have your 'default' versions in `~/codes`, and another copy of each package in `~/projects/A/vendor`.
]

.note[
  `git` users can manage the external packages with `git-submodule`.]

---
name: feynrules_sm_file

### Appendix II:<br> FeynRules pre-installed Standard Model

Let's read the SM model file pre-installed in FeynRules, `models/SM/SM.fr`.

![:code_title](models/SM/SM.fr)
```mathematica
(* ************************** *)
(* *****  Information   ***** *)
(* ************************** *)
M$ModelName = "Standard Model";

M$Information = {
  Authors      -> {"N. Christensen", "C. Duhr", "B. Fuks"}, 
  Version      -> "1.4.6",
  Date         -> "15. 04. 2014",
  Institutions -> {"Michigan State University", "Universite catholique de Louvain (CP3)",
                   "IPHC Strasbourg / University of Strasbourg"},
  Emails       -> {"neil@pa.msu.edu", "claude.duhr@uclouvain.be", "benjamin.fuks@cnrs.in2p3.fr"},
  URLs         -> "http://feynrules.phys.ucl.ac.be/view/Main/StandardModel"
};
```

This information tells you that you must write to them when you find bugs or suspicious codes.

---
Note the positions of commas (`,`):
```mathematica
  list = {a, b, c, d, } (* is not allowed; interpreted as {a, b, c, d, Null} *)
  list = {a, b, c, d }  (* is the proper way. *)
```

.note[
  Some variables has `FR$` or `M$` in its name.
  `M$`-type variables are the model information, and expected to be read by FeynRules.
  `FR$`-variables are FeynRules-internal variables; they are modified by `SM.fr`.
  All variables can be accessible from your Mathematica terminal.]

---
![:code_title](models/SM/SM.fr)
```mathematica
(* Choose whether Feynman gauge is desired.                                                         ****)
(* If set to False, unitary gauge is assumed.                                                         **)
(* Feynman gauge is especially useful for CalcHEP/CompHEP where the calculation is 10-100 times faster.*)
(* Feynman gauge is not supported in MadGraph and Sherpa.                                             **)

FeynmanGauge = True;
```
This looks an important switch.
Let us keep it in mind.

![:code_title](models/SM/SM.fr)
```mathematica
(* ************************** *)
(* ***** NLO Variables ****** *)
(******************************)

FR$LoopSwitches = {{Gf, MW}};
FR$RmDblExt = { ymb -> MB, ymc -> MC, ymdo -> MD, yme -> Me, 
   ymm -> MMU, yms -> MS, ymt -> MT, ymtau -> MTA, ymup -> MU};
```
This is for NLO calculation, so we ignore for now.

---
![:code_title](models/SM/SM.fr)
```mathematica
(* ************************** *)
(* *****      vevs      ***** *)
(* ************************** *)
M$vevs = { {Phi[2],vev} };
```

This lists the VEVs of the model.
Here the second element of `Phi` is declared to have a `vev`.
For now we skip this for simplicity, but we should consult the manual (or source code) when our model has another VEV.

---
![:code_title](models/SM/SM.fr)
```mathematica
(* ************************** *)
(* *****  Gauge groups  ***** *)
(* ************************** *)
M$GaugeGroups = {
  U1Y  == { 
    Abelian          -> True,  
    CouplingConstant -> g1, 
    GaugeBoson       -> B, 
    Charge           -> Y },
  SU2L == {
    ...
    Representations -> {Ta,SU2D}, 
    Definitions     -> {Ta[a_,b_,c_]->PauliSigma[a,b,c]/2, FSU2L[i_,j_,k_]:> I Eps[i,j,k]}
  },
  SU3C == { 
    ...
    Representations -> {T,Colour}, 
    SymmetricTensor -> dSUN }
```
Here three gauge symmetries are defined, together with corresponding gauge bosons `B`, `Wi`, `G`, coupling constants `g1`, `gw`, `gs`, etc.
The manual says about `Representations`,
> The first component of each pair is a symbol defining the symbol for the generator,
> while the second one consists of the type of indices it acts on.

As `SU2D` is an index for SU(2) doublet defined just below as 1&ndash;2, this code defines a generator set `Ta[a,b,c]`$=\frac12(\sigma^a)^{bc}$.
Similarly, $(T{}^a)^{bc}$ is defined for SU(3).

---
.note[
  `Ta` is explicitly defined here, while `T` is not explicitly defined. It is internally evaluated.

  For a gauge group named `aaa`, FeynRules automatically defines the symbol `Faaa` to denote its adjoint representation.

  For details, see FeynRules manual
   * 6.1.5 Definition of Standard Model parameters and gauge groups, and a table therein,
   * 2.6.1 Gauge group declaration.
]
---
![:code_title](models/SM/SM.fr)
```mathematica
(* ************************** *)
(* *****    Indices     ***** *)
(* ************************** *)

IndexRange[Index[SU2W      ]] = Unfold[Range[3]]; 
IndexRange[Index[SU2D      ]] = Unfold[Range[2]];
IndexRange[Index[Gluon     ]] = NoUnfold[Range[8]];
IndexRange[Index[Colour    ]] = NoUnfold[Range[3]]; 
IndexRange[Index[Generation]] = Range[3];

IndexStyle[SU2W,       j];
IndexStyle[SU2D,       k];
IndexStyle[Gluon,      a];
IndexStyle[Colour,     m];
IndexStyle[Generation, f];
```
`Unfold` is important: from the manual,
> 
> Any index that expands in terms of non-physical states must be wrapped in `Unfold`.
> For instance, the SU(2)L indices in the SM or in the MSSM  must always be expanded in order to get the Feynman rules in terms of the physical states of the theory.

Read the manual for detail.

.note[
  `IndexStyle` defines the prefix of internal variables; e.g., indices `a1`, `a2`, ... are internally generated to represent gluon indices.]

---

![:code_title](models/SM/SM.fr)
```mathematica
(* ************************** *)
(* *** Interaction orders *** *)
(* ***  (as used by mg5)  *** *)
(* ************************** *)

M$InteractionOrderHierarchy = {
  {QCD, 1},
  {QED, 2}
};
```
We will see this later (in mg5 lecture).

---

![:code_title](models/SM/SM.fr)
```mathematica
(* ************************** *)
(* **** Particle classes **** *)
(* ************************** *)
M$ClassesDescription = {

(* Gauge bosons: physical vector fields *)
  V[1] == { 
    ClassName       -> A, 
    SelfConjugate   -> True,  
    Mass            -> 0,  
    Width           -> 0,  
    ParticleName    -> "a", 
    PDG             -> 22, 
    PropagatorLabel -> "a", 
    PropagatorType  -> W, 
    PropagatorArrow -> None,
    FullName        -> "Photon"
  },
...
```
Now the particles! Vector fields are defined as `V[ (number) ]`.

.quiz[
  Which properties are physically important, and which are just for illustration? ![:answer](SelfConjugate, Mass, and Width are physically important. ClassName and PDG are also important because they are the labels. FullName, ParticleName, and styles for propagators are just for illustration.)]
  
---
![:code_title](models/SM/SM.fr)
```mathematica
  V[2] == { 
    ClassName       -> Z, 
    SelfConjugate   -> True,
    Mass            -> {MZ, 91.1876},
    Width           -> {WZ, 2.4952},
    PDG             -> 23, 
  },
  V[3] == {
    ClassName        -> W,
    SelfConjugate    -> False,
    Mass             -> {MW, Internal},
    Width            -> {WW, 2.085},
    QuantumNumbers   -> {Q -> 1},
    PDG              -> 24, 
  },
  V[4] == {
    ClassName        -> G,
    SelfConjugate    -> True,
    Indices          -> {Index[Gluon]},
    Mass             -> 0,
    Width            -> 0,
    PDG              -> 21,
  },
```
We will discuss `QuantumNumbers` later.

Note there are `Internal` parameters, and parameters with values (external).

---
![:code_title](models/SM/SM.fr)
```mathematica
(* Gauge bosons: unphysical vector fields *)
  V[11] == { 
    ClassName     -> B, 
    Unphysical    -> True, 
    SelfConjugate -> True, 
    Definitions   -> { B[mu_] -> -sw Z[mu]+cw A[mu]} 
  },
  V[12] == { 
    ClassName     -> Wi,
    Unphysical    -> True,
    SelfConjugate -> True, 
    Indices       -> {Index[SU2W]},
    FlavorIndex   -> SU2W,
    Definitions   -> { Wi[mu_,1] -> (Wbar[mu]+W[mu])/Sqrt[2],
                       Wi[mu_,2] -> (Wbar[mu]-W[mu])/(I*Sqrt[2]),
                       Wi[mu_,3] -> cw Z[mu] + sw A[mu]}
  },
```
These particles have already appeared in `GaugeBoson` of the gauge group definition, so they will appear in covariant derivatives `DC` and field strengths `FS` later.
Note that they are `Unphysical`, and do not have `Mass` or `Width` properties but `Definitions`.

---
![:code_title](models/SM/SM.fr)
```mathematica
(* Fermions: physical fields *)
  F[1] == {
    ClassName        -> vl,
    ClassMembers     -> {ve,vm,vt},
    Indices          -> {Index[Generation]},
    FlavorIndex      -> Generation,
    SelfConjugate    -> False,
    Mass             -> 0,
    Width            -> 0,
    QuantumNumbers   -> {LeptonNumber -> 1}
  },
  F[2] == {
    ClassName        -> l,
    ClassMembers     -> {e, mu, ta},
    Indices          -> {Index[Generation]},
    FlavorIndex      -> Generation,
    SelfConjugate    -> False,
    Mass             -> {Ml, {Me,5.11*^-4}, {MMU,0.10566}, {MTA,1.777}},
    Width            -> 0,
    QuantumNumbers   -> {Q -> -1, LeptonNumber -> 1}
  },
  ...
```
These are physical fermions, so `Mass` and `Width` are defined.


.note[
  As `Index[Generation]` (runs 1&ndash;3) is marked as `FlavorIndex`, these classes have three "flavors".
  Therefore `ClassMembers` is specified and has three elements, and `Mass` etc. are with several elements (one common symbol followed by parameters for respective generations).]

---

![:code_title](models/SM/SM.fr)
```mathematica
F[11] == { 
  ClassName      -> LL, 
  Unphysical     -> True, 
  Indices        -> {Index[SU2D], Index[Generation]},
  FlavorIndex    -> SU2D,
  SelfConjugate  -> False,
  QuantumNumbers -> {Y -> -1/2},
  Definitions    -> {LL[sp1_, 1, ff_] :> Module[{sp2}, ProjM[sp1,sp2] vl[sp2,ff]],
                     LL[sp1_, 2, ff_] :> Module[{sp2}, ProjM[sp1,sp2] l [sp2,ff]]} },
```
Lagrangian is written in terms of `Unphysical` fermions such as this `LL`, which is converted to physical fermions `vl` and `l` as defined in `Definitions`.

With this description, we will obtain the proper covariant derivative `DC`:
$$
D\sub\mu(L)
= \partial\sub\mu(L)
-\ii g\sub 2 T^aW^a\sub\mu L
-\ii g\sub Y(-1/2) B\sub\mu L
$$
because, for `LL`, an index associated to `SU2L` gauge group  and a quantum number associated to `U1Y` gauge group are specified.

---
.note[
  `Indices` associated to a (non-Abelian) gauge group are used to define the representation in the gauge symmetry.

  `Indices` marked as `FlavorIndex` is used to link the class to each element in `ClassMembers`.

  The other `Indices` are used just as labels.]

.note[
  `QuantumNumbers` associated to an Abelian gauge group are used to define the charge under the gauge symmetry.

  `QuantumNumbers` not associated to Abelian groups are treated as a global U(1) symmetry (and its charge).
  If an interaction breaks such a symmetry, a warning may be recorded in log files.]

---
Quarks and the Higgs boson are similarly defined:
![:code_title](models/SM/SM.fr)
```mathematica
F[13] == { 
  ClassName      -> QL, 
  Unphysical     -> True, 
  Indices        -> {Index[SU2D], Index[Generation], Index[Colour]},
  FlavorIndex    -> SU2D,
  SelfConjugate  -> False,
  QuantumNumbers -> {Y -> 1/6},
  Definitions    -> { 
    QL[sp1_,1,ff_,cc_] :> Module[{sp2}, ProjM[sp1,sp2] uq[sp2,ff,cc]], 
    QL[sp1_,2,ff_,cc_] :> Module[{sp2,ff2}, CKM[ff,ff2] ProjM[sp1,sp2] dq[sp2,ff2,cc]] }
},
F[14] == { 
  ClassName      -> uR, 
  Unphysical     -> True, 
  Indices        -> {Index[Generation], Index[Colour]},
  FlavorIndex    -> Generation,
  SelfConjugate  -> False,
  QuantumNumbers -> {Y -> 2/3},
  Definitions    -> { uR[sp1_,ff_,cc_] :> Module[{sp2}, ProjP[sp1,sp2] uq[sp2,ff,cc]] } },
F[15] == { 
  ClassName      -> dR, 
  Unphysical     -> True, 
  Indices        -> {Index[Generation], Index[Colour]},
  FlavorIndex    -> Generation,
  SelfConjugate  -> False,
  QuantumNumbers -> {Y -> -1/3},
  Definitions    -> { dR[sp1_,ff_,cc_] :> Module[{sp2}, ProjP[sp1,sp2] dq[sp2,ff,cc]] } },
```

---
![:code_title](models/SM/SM.fr)
```mathematica
(* Higgs: physical scalars  *)
  S[1] == {
    ClassName       -> H,
    SelfConjugate   -> True,
    Mass            -> {MH,125},
    Width           -> {WH,0.00407},
  },
(* Higgs: unphysical scalars  *)
  S[11] == { 
    ClassName      -> Phi, 
    Unphysical     -> True, 
    Indices        -> {Index[SU2D]},
    FlavorIndex    -> SU2D,
    SelfConjugate  -> False,
    QuantumNumbers -> {Y -> 1/2},
    Definitions    -> { Phi[1] -> -I GP, Phi[2] -> (vev + H + I G0)/Sqrt[2]  }
  }
```

---
Then parameters are declared.

![:code_title](models/SM/SM.fr)
```mathematica
(* ************************** *)
(* *****   Parameters   ***** *)
(* ************************** *)
M$Parameters = {

  (* External parameters *)
  aEWM1 == { 
    ParameterType    -> External, 
    BlockName        -> SMINPUTS, 
    OrderBlock       -> 1, 
    Value            -> 127.9,
    InteractionOrder -> {QED,-2},
    Description      -> "Inverse of the EW coupling constant at the Z pole"
  },
```
This is an `External` parameter, so `Value` is given.
Also `BlockName` and `OrderBlock` is specified; users can input the value for `aEWM1` in the first element of `SMINPUTS` block in a SLHA parameter file.

---
![:code_title](models/SM/SM.fr)
```mathematica
  (* Internal Parameters *)
  aEW == {
    ParameterType    -> Internal,
    Value            -> 1/aEWM1,
    InteractionOrder -> {QED,2},
    TeX              -> Subscript[\[Alpha], EW],
    Description      -> "Electroweak coupling contant"
  },
  MW == { 
    ParameterType -> Internal, 
    Value         -> Sqrt[MZ^2/2+Sqrt[MZ^4/4-Pi/Sqrt[2]*aEW/Gf*MZ^2]], 
    TeX           -> Subscript[M,W], 
    Description   -> "W mass"
  },
```
These are `Internal` parameters; `Value` is specified as a Mathematica expression.

.exquiz[
  Verify that the expressions for the internal parameters are correct. For example, prove
    $$
      M\sub{W}^2 = \frac{M\sub{Z}^2}{2} + \sqrt{\frac{M\sub{Z}^4}{4}-\frac{\pi}{\sqrt 2}\frac{\alpha\w{ew}}{G\w F}M\sub{Z}^2}.
    $$]

---
![:code_title](models/SM/SM.fr)
```mathematica
  yd == {
    ParameterType    -> Internal,
    Indices          -> {Index[Generation], Index[Generation]},
    Definitions      -> {yd[i_?NumericQ, j_?NumericQ] :> 0  /; (i =!= j)},
    Value            -> {yd[1,1] -> Sqrt[2] ymdo/vev, yd[2,2] -> Sqrt[2] yms/vev, ...},
    InteractionOrder -> {QED, 1},
    ParameterName    -> {yd[1,1] -> ydo, yd[2,2] -> ys, yd[3,3] -> yb},
    TeX              -> Superscript[y, d],
    Description      -> "Down-type Yukawa couplings"
  },
(* N. B. : only Cabibbo mixing! *)
  CKM == { 
    ParameterType -> Internal,
    Indices       -> {Index[Generation], Index[Generation]},
    Unitary       -> True,
    Value         -> {CKM[1,1] -> Cos[cabi],  CKM[1,2] -> Sin[cabi], CKM[1,3] -> 0,
                      CKM[2,1] -> -Sin[cabi], CKM[2,2] -> Cos[cabi], CKM[2,3] -> 0,
                      CKM[3,1] -> 0,          CKM[3,2] -> 0,         CKM[3,3] -> 1},
    TeX         -> Superscript[V,CKM],
    Description -> "CKM-Matrix"}
```
These are with `Indices`, so matrix-type parameters.
For `yd`, both `Definitions` and `Value` are given, but they are exclusive.

---
Finally the Lagrangian is described.
The first part is
![:code_title](models/SM/SM.fr)
```mathematica
LGauge := Block[{mu,nu,ii,aa}, 
  ExpandIndices[
    - 1/4 FS[B,mu,nu] FS[B,mu,nu]
    - 1/4 FS[Wi,mu,nu,ii] FS[Wi,mu,nu,ii]
    - 1/4 FS[G,mu,nu,aa] FS[G,mu,nu,aa]
  , FlavorExpand->SU2W]];
```
This is easy to understand; `LGauge` is actually
$$
L\w{gauge} = -\frac14\left[
 B\sub{\mu\nu}B^{\mu\nu}
+W^i\sub{\mu\nu}W^{i\mu\nu}
+G^a\sub{\mu\nu}G^{a\mu\nu}
\right],
$$
where $B\sub{\mu\nu}$ etc. are the gauge field strengths (`FS`).


Remember that `SU2W` is defined as `Unfold[Range[3]]`, because
> Any index that expands in terms of non-physical states must be wrapped in Unfold.
> For instance, the SU(2)L indices in the SM or in the MSSM must always be expanded in order to get the Feynman rules in terms of the physical states of the theory.

Here, as is specified in `FlavorExpand`, the index `SU2W` is expanded.

---
![:code_title](models/SM/SM.fr)
```mathematica
LFermions := Block[{mu}, ExpandIndices[
  I*( QLbar.Ga[mu].DC[QL, mu] + LLbar.Ga[mu].DC[LL, mu] + ...

LHiggs := Block[{ii,mu, feynmangaugerules},
  feynmangaugerules = If[Not[FeynmanGauge], {G0|GP|GPbar ->0}, {}];
 
  ExpandIndices[
     DC[Phibar[ii],mu] DC[Phi[ii],mu] + muH^2 Phibar[ii] Phi[ii]
     - lam Phibar[ii] Phi[ii] Phibar[jj] Phi[jj]
  , FlavorExpand->{SU2D,SU2W}]/.feynmangaugerules
 ];
```
`LFermions` and `LHiggs` are basically
$$
\ii \overline{Q}\gamma^\mu D\sub{\mu}Q + \cdots,
$$
and
$$
  D^\mu \Phi\conj\sub{i} D\sub{\mu}\Phi\sub{i} + \mu\sub{H}^2 \Phi\conj\sub{i}\Phi\sub{i} - \lambda \Phi\conj\sub{i}\Phi\sub{i}\Phi\conj\sub{j}\Phi\sub{j},
$$
respectively. In Feynman gauge, all the goldstones are removed.

---
![:code_title](models/SM/SM.fr)
```mathematica
LYukawa := Block[{sp,ii,jj,cc,ff1,ff2,ff3,yuk,feynmangaugerules},
  feynmangaugerules = If[Not[FeynmanGauge], {G0|GP|GPbar ->0}, {}];
 
  yuk = ExpandIndices[
   -yd[ff2, ff3] CKM[ff1, ff2] QLbar[sp, ii, ff1, cc].dR [sp, ff3, cc] Phi[ii] - 
    yl[ff1, ff3] LLbar[sp, ii, ff1].lR [sp, ff3] Phi[ii] - 
    yu[ff1, ff2] QLbar[sp, ii, ff1, cc].uR [sp, ff2, cc] Phibar[jj] Eps[ii, jj]
  , FlavorExpand -> SU2D
  ];
  yuk = yuk /. { CKM[a_, b_] Conjugate[CKM[a_, c_]] -> IndexDelta[b, c], ... };
  yuk + HC[yuk] /. feynmangaugerules
];
```
Let us focus on the indices.
The field `QLbar` ($=Q^\dagger\gamma\sub0$) has four indices: `sp`, `ii`, `ff1`, and `cc`. The first index `sp` is for spin, and the others follow the class description of `QL` = `F[11]`:
```mathematica
    Indices        -> {Index[SU2D], Index[Generation], Index[Colour]}
```
Note that fermions, which are anticommuting, should be connected by `Dot` (`.`).
In some cases indices can be omittd, but it is recommended to write all the indices explicitly.

---
We will skip the last part of the Lagrangian,`LGhost`.

Finally the Standard Model Lagrangian is defined:
![:code_title](models/SM/SM.fr)
```mathematica
LSM:= LGauge + LFermions + LHiggs + LYukawa + LGhost;
```

---
##### Summary
When you implement your model as a FeynRules model, you have to code
 * gauge symmetries
 * fields
   - unphysical fields (gauge eigenstates)
   - physical fields (mass eigenstates)1
 * parameters
 * Lagrangian

.note[
  There is one more key ingredient of FeynRules model file, `Mixing`; it is not used in the SM.
  You have to read the manual when you handle a model with mixings.]

.note[
  FeynRules can handle superspace and superfields (but it is far beyond the scope of this lecture).]


---
name: feynrules_sm_validation

### Appendix III:<br> Validation of SM.fr in FeynRules

[When we check `SM.fr` in Lecture A](Lecture_A.html#feynrules_sm_validation), we have found the code raises several warnings:
![:code_title](models/SM/SM.wl)
```mathematica
(* Execute this block to check the validity of the input *)
SetDirectory[NotebookDirectory[]];
<<FeynRules`;
FR$Parallelize = False;
LoadModel["SM.fr"];
FeynmanGauge = False;

CheckKineticTermNormalisation[LSM, FlavorExpand->True]
```
```output
Neglecting all terms with more than 2 particles.
All kinetic terms are diagonal.
Warning: Kinetic term for {ve, vebar} seems not to be correctly normalized.
Warning: Kinetic term for {vm, vmbar} seems not to be correctly normalized.
Warning: Kinetic term for {vt, vtbar} seems not to be correctly normalized.
```
These are warnings, not errors, so we have to go further to check this is critical or false-positive.

---
To this end, we narrow the expressions:
```mathematica
Lneutrinos = ExpandIndices[LSM, FlavorExpand->True, Contains->vebar|vmbar|vtbar]
```
(Consult `ExpandIndices` and available options in the manual.)

Now you can read the terms by your eyes; you may find the kinetic terms are correctly normalized.

---
When you check the model in Feymnan gauge, you may see other messages.
First,
```mathematica
SetDirectory[NotebookDirectory[]];
<<FeynRules`;
FR$Parallelize = False;
LoadModel["SM.fr"];
FeynmanGauge = True;
```
```mathematica
> CheckDiagonalKineticTerms[LSM]
```
```output
Non diagonal kinetic term found: $\mathrm{c_w s_w ghA^\dagger.\partial_{mu}[\partial_{mu}[ghZ]]}$
Non diagonal kinetic term found: $\mathrm{c_w s_w ghZ^\dagger.\partial_{mu}[\partial_{mu}[ghA]]}$
```
This looks incorrect; to investigate, we narrow the terms.
As we know ghosts are only in `LGhost`,
```mathematica
> CheckDiagonalKineticTerms[LGhost]
```
but the same errors are shown.
So we will check `LGhost` by eyes.

---
If you are very careful, you may find `ghWi` in `LGhost`, and remember that they are unphysical fields and should have been expanded to `ghZ`, `ghWp` and `ghWm`.
However it is not expanded.
This may be a bug in the `FeynRules` code; it may be not easy to solve.

Instead, we fix the model files.
It comes from
![:code_title](models/SM/SM.fr)
```mathematica
  LGhw = -ghWibar.del[DC[ghWi,mu],mu];
```
So we replace it by
```mathematica
  LGhw = Sum[-ghWibar[i].del[DC[ghWi[i],mu],mu], {i, 1, 3}]
```
Then you will see
```mathematica
> CheckDiagonalKineticTerms[LSM]
```
```output
Neglecting all terms with more than 2 particles.
All kinetic terms are diagonal.
```

---
You will see another message:
```mathematica
> CheckDiagonalQuadraticTerms[LSM]
```
```output
Neglecting all terms with less than 2 particles.
Non diagonal quadratic term found: $\mathrm{e\ vev\ \partial_{mu}[GP^\dagger]W_{mu}}/2s_w$
...
```
This term should have been eliminated by gauge fixing.
Open `SM.fr` and check that the gauge-fixing terms are provided; you will find `SM.fr` lacks the gauge-fixing terms.

.note[
  I found this problem when I was preparing this lecture slides; I did not have enough time to fix this problem, and just sent an e-mail to one of the authors.
  So...]

.exquiz[
  Fix this problem.]

We just have learned the importance of validation (and being careful).
I hope that you also learn that we have to understand the underlying physics very well before using tools.

