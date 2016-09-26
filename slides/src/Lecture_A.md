# Tools for BSM Physics (A-1)

.author[
  [Sho Iwamoto](http://www.misho-web.com)
  ![:height 1em](assets/ShoIwamoto_ja.png)

  .logo[
    ![Technion - Israel Institute of Technology](assets/Technion_he.png)
  ]
]


.location[
  XX Oct 2016 <br>
  Yonsei University
]

.copyright[
  &copy; 2012-2016 <a href="http://www.misho-web.com">Sho Iwamoto</a>

  These lecture slides are licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">Creative Commons Attribution-NonCommercial 4.0 International License</a>.

  Lecture materials are available at [https://github.com/misho104/FeynLecture/](https://github.com/misho104/FeynLecture/).

  <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/"><img alt="Creative Commons License" style="border-width:0" src="assets/cc_by_nc.png" /></a>
]

---

## Lecture A: <br> Automated analytic calculation of matrix elements

  * FeynArts
  * FormCalc
  * LoopTools
  * FeynRules
  * (FeynCalc)

---
name:introduction

### 0. Introduction: Why automated?

#### Pros
 1. No miscalculations
 2. **Reusable and shareable**
 3. Mass production possible

---
#### Cons

 1. **Bugs in your codes**
 2. Learning cost
 3. *Too easy*; doable without proper understanding
 4. **Bugs in public packages**
 5. Not flexible

#### Strategy

 * **To read manuals is not sufficient.**
  - Compare your results with reliable books/papers.
  - Understand the underlying physics, and compare your results with your intuition.
 * Be patient. Struggle with errors.
 * Ask experts.

---
#### Basic flow
 * (1) `FeynArts`  : draw Feynman diagrams.
 * (2) `FormCalc`  : calculate the diagrams.

For 1-loop diagram,
 * (3) `LoopTools` : evaluate the loop integrals (Passarino-Veltman functions).

For your original model,
 * (0) `FeynRules` : define your Lagrangian.

#### Other tools

 `FormCalc` is easy to use but specialized to usual $\sum|\mathcal M|^2$ calculations.
If you want to be more flexible, you may want to use
 * (2') `FeynCalc` : manipulate the expressions for FeynArts diagrams

---
name: treelevel

### 1. Tree-level amplitudes with FeynArts + FormCalc

####  `Lecture1-1.nb` : $e^+ e^- \to \mu^+ \mu^-$ in QED

Start from the simplest. **Compare your results** with reliable books.

.quiz[
  Open `Lecture1-1.nb` and evaluate each line.
  The guy who wrote this file was at first a bit careless, and has a *bug* in the code, which made the results 4 times smaller than Peskin's.
  Find the origin of this discrepancy.]
.exquiz[
  Now you know `Hel[_] -> 0` gives a spin average.
  But why?
  Explain the reason. ![:hint](Open FormCalc manual, and look up `Hel` in the index. Read the text around.)]
.quiz[
  Do you remember why you should take an average for the inifial fermions and the sum for the final ones?]
.quiz[
  Do you remember the Mandelstam variables?
  Prove $S=4E^2$, $T = m\sub\mu^2-2\left(E^2-E\sqrt{E^2-m\sub\mu^2}\cos\theta\right)$ , and $U=-S-T+2m\sub\mu^2$.
]

---
.quiz[
  In the outputs, you find
```output
loading classes model file (...)/FeynArts/Models/SM.mod

$CKM=False

> 46 particles (incl. antiparticles) in 16 classes
> $CounterTerms are ON
> 88 vertices
> 115 counter terms of order 1
> 6 counter terms of order 2
classes model {SM} initialized
```
  This is the FeynArts default model file for the SM.
  Read Appendix B of FeynArts manual, and check the parameters and field contents for the model.
  What does `ExcludeParticles -> {V[2], S[1], S[2]}` mean?]

.note[
  It is recommended to call `ClearProcess[]` always before executing `CalcFeynAmp`.]

---
#### `Lecture1-2.nb` : $e^- \mu^- \to e^- \mu^-$ in QED

.quiz[
  Now you have all information needed to calculate $\sigma(e^-\mu^-\to e^-\mu^-)$.
  Open `Lecture1-2.nb` and evaluate the file step by step.
  Check that the calculated cross section agrees with that in Peskin.]
.quiz[
  FormCalc expressions often contain abbreviated expressions such as `F1` or `abbr1`.
  You can expand them by `//. Abbr[] //. Subexpr[]`.
  Let's expand the internal expressions! For example, expand `amplitude`.]
.quiz[
  Try to replace `FermionChains -> VA` by `FermionChains -> Dirac`.
  Check that it gives a different `amplitude`.
  Verify that, even though, the crosssections are the same as `VA` case.
  (Don't forget to call `ClearProcess[]` before `CalcFeynAmp`)]

Instead of `Hel[_]->0` after `CalcFeynAmp`, the same effect can be acomplished by executing `_Hel = 0` *before* `CalcFeynAmp`.

.exquiz[
  Why? (a tricky quiz; you have to learn the concept of `Head` in Mathematica language...)]

---
.exquiz[
  Try to understand the internal expression of `amplitude`.
  In particular, what does `Mat[(<v1|5,Lor[1]|u2>) (<u3|5,Lor[1]|v4>)]` mean?
  Consult `Mat` in FormCalc manual.
  You may want to see the "FullForm" of the expression: `FullForm[amplitude //. Abbr[] //. Subexpr[]]`.
]
.exquiz[
  Prove the following equations for massive fermions (FormCalc manual P.29):
$$ \require{cancel}
   u\sub\lambda(p)\overline u\sub\lambda(p) = \frac{1}{2}(1+\lambda\gamma_5\cancel{s})(\cancel{p}+m)$$
$$ v\sub\lambda(p)\overline v\sub\lambda(p) = \frac{1}{2}(1+\lambda\gamma_5\cancel{s})(\cancel{p}-m)$$]

---
#### `Lecture1-3.nb` : $e^+ e^- \to \gamma\gamma$ in QED

In the previous examples we only handle fermions as the external particles.
Now we treat external vector fields.

.quiz[
  Open and evaluate `Lecture1-3.nb`, and check the result agrees with Peskin.]
.quiz[
  Read one more time the part of gauge-invaliance check, and make sure what is happening there.]
.exquiz[
  In the file we have checked the gauge invariance (i.e., eta-independence of `PolSummedME`) in a limit $m_e\to 0$.
  Redo it without approximating $m_e=0$.]


---
#### `Lecture1-4.nb` : QCD amplitudes

The last skill of tree-level calculation is to evaluate the color structure with `ColourME`.
Let's calculate QCD two-jet cross sections, ignoring quark masses and QED/EW diagrams.

.quiz[
  `Lecture1-4.nb` has QCD amplitudes of two-jet cross sections, which are taken from the book by Ellis-String-Webber.
  Evaluate the file step by step as usual. You will see/notice
   * the squared matrix elements for $q q' \to q q'$ and $g q \to g q$ are calculated and agrees with the reference.
   * how to use `ColourME`: is it taking the sum, or an average?
   * the squared matrix element for $g q\to g q$ is independent of `eta`, i.e., the processes are gauge independent.
   ]
.quiz[
  Three "lessons" are given in the end of the file. Explain why we can summarize as such:
   * $\times 2$ for each FINAL fermion
   * DIVIDE by INITIAL colour factor
   * DIVIDE by the degrees-of-freedom of INITIAL vector particles.]

---
#### `Lecture1-ex.nb` [Exercise] QCD two-jet cross sections

Now you are asked to write codes by yourself.
Let's open `Lecture1-ex.nb`!

.quiz[
  Calculate the squared matrix element of $gg\to q\bar q$.
  You should use `GaugeTerms->False` to avoid extra complexity.
  Does your result agree with the book?]
.exquiz[
  Calculate the other processes and check the result.
  You should use `GaugeTerms->False` to avoid extra complexity.]
.exquiz[
  Calculate a process with `GaugeTerms->True`, and check that the squard matrix element, which contains `eta`'s in its expression, is actually independent of `eta`.
  Note that this is guaranteed by the gauge independence.]

#### `lecture1-ex-ex.nb` [Extra Exercise] Four more examples

.exquiz[
  Another four processes are taken from the same book and summarized in `Lecture1-ex-ex.nb`.
  Try to calculate some of them, and check that your results agrees with the book.]

---
#### Further investigations

Now, theoretically, you can calculate crosssections of any tree-level diagrams in the SM.
It is perhaps a good time to read the manual again.

.quiz[
  Read the following sections of FormCalc manual; you will understand more of QFT calculations.
   - 4.8 Fermionic Matrix Elements
   - 4.9 Colour Matrix Elements]
.exquiz[
  To learn the internal expressions, read FormCalc manual
   - 4.4 Ingredients of Feynman amplitudes]
.exquiz[
  For more flexible diagram generation, read FeynArts manual
   - 3.1 Topological Objects
   - 3.2 CreateTopologies
   - 4.1 The Three-Level Fields Concept
   - 4.2 InsertFields
   - 4.8 Extracting and Deleting Insertions by Number
   - 4.5 Selecting Insertions]

---
### 2. Create your own model by FeynRules

`FeynRules` : Read a Lagrangian from "FeynRules files" (`*.fr`), and output files for
  - CalcHep/CompHep,
  - *FeynArts/FormCalc*,
  - Sherpa,
  - *UFO (Universal FeynRules Output)* (for mg5),
  - Whizard/Omega


##### Strategy
 * Do not create a model file by your own! : Risk of bugs.
   - You have to imprement so many things (esp. mixing).
   - The grammar is not simple.
 * Use pre-installed models; they are made by professionals.
 * Append your particles/interaction to those pre-installed models.
   - Do not append everything. Physically interesting particles only.
 * If you write from scratch, you need to verify the files carefully.

---
#### Let's read the pre-installed Standard Model file

.quiz[
  Open `Models/SM/SM.fr` and read it.
  What does a model file have?]

---
A model file has

  - Gauge symmetries,
  - Indices (labels of color, generation, etc.),
  - Particle classes,
  - Parameters,
  - Interactions (embedded in a Lagrangian),
  - etc.

---
The file `models/SM/SM.fr` stars with "Information."

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

.note[
  This information tells you that you must write to them when you find bugs or suspicious codes.]

.note[
  Some variables has `FR$` or `M$` in its name.
  `M$`-type variables are the model information, and expected to be read by FeynRules.
  `FR$`-variables are FeynRules-internal variables; they are modified by `SM.fr`.
  All variables can be accessible from your Mathematica terminal.]

Note the positions of commas (`,`):
```mathematica
  list = {a, b, c, d, } (* is not allowed; interpreted as {a, b, c, d, Null} *)
  list = {a, b, c, d }  (* is the proper way. *)
```

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

.exquiz[
  Verify `LGhost` agrees with references, e.g., Peskin Chapter 21.]

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

#### How to use FeynRules

The power of FeynRules is you can generate many formats from a single `.fr` file.
Available formats are for
 - *FeynArts* (and thus FormCalc or FeynCalc)
 - Universal FeynRules Output (for *MadGraph5_aMC@NLO* etc.)
 - CalcHep / CompHep
 - ASperGe
 - Sherpa
 - Whizard

as well as $\TeX$ output.

Now we are going to create *UFO* and *FeynArts* output from `SM.fr`, as this course includes FeynArts and MG5_aMC.

Open `models/SM/SM.wl` in Mathematica; you will find four code-blocks.

.note[
  Though the file has an extension `.wl` (for "Wolfram language package), it is not a package file but intended to use as an usual notebook.
  I like to use `.wl` extension for my code because `.wl` files can be read with text editors.]

---
In the end of the file, you find a section:
![:code_title](models/SM/SM.wl)
```mathematica
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
```
This is to validate the model; I recommend to do these validations before output.

First line sets the Mathematica working directory as `NotebookDirectory[]`, which is `models/SM`.
`FR$Parallelize` is an option to FeynRules; parallelize makes the calculation faster, but sometimes unstable.
For simple models it can be switched off.
Then `models/SM/SM.fr` is loaded and checked.
Here, for simplicity, the unitary gauge is chosen by `$FeynmanGauge = False`.

---
You will find that
 - `The Lagrangian is hermitian.`
 - `All mass terms are diagonal.`
 - Analytical values (calculated from Lagrangian) and Model-file values (e.g., `Mass -> {MZ,91.1876}`) of masses are in agreement.
 - `All kinetic terms are diagonal.` and `All quadratic terms are diagonal.`

However, you may see
![:code_title](models/SM/SM.wl)
```mathematica
CheckKineticTermNormalisation[LSM, FlavorExpand->True]
```
```output
Neglecting all terms with more than 2 particles.
All kinetic terms are diagonal.
Warning: Kinetic term for {ve, vebar} seems not to be correctly normalized.
Warning: Kinetic term for {vm, vmbar} seems not to be correctly normalized.
Warning: Kinetic term for {vt, vtbar} seems not to be correctly normalized.
```
We ignore this warning now, because I know `SM.fr` in unitary gauge is valid.
.note[
  If you are very motivated and *have plenty of time*, go to [Appendix II](appendices.html#feynrules_sm_validation) to learn about these warnings.]

.exquiz[
  Check `SM.fr` with setting `FeynmanGauge = True`, i.e., in Feynman gauge.
  ![:answer](Answer is found in Appendix II.)]

