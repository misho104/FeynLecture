# Tools for BSM Physics (A)

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
  Try to replace `FermionChains -> VA` by `FermionChains -> Chiral`.
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
name: QCD_amplitudes

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
name: feynrules

### 2. Create your own model by FeynRules

#### `Lecture2-1.nb`: FeynRules
FeynRules: **single file for many packages**.

 * Input: "FeynRules files" (*.fr), which contains Lagrangian.
 * Output:
  - *FeynArts / FormCalc*
  - Universal FeynRules Output (for *MadGraph5_aMC@NLO* etc.)
  - CalcHep / CompHep
  - ASperGe
  - Sherpa
  - Whizard
  - TeX

---
#### FeynRules input file

Open `Models/SM/SM.fr`.
You can see that the input file has

  - 3 gauge symmetries,
  - 5 indices (labels of color, generation, etc.),
  - 26 particle classes,
    - unphysical fields (gauge eigenstates)
    - physical fields (mass eigenstates)
  - 29 parameters,
  - Interactions (embedded in a Lagrangian),
  - etc.

*You have to write all of them if you want to implement your model.*
**...boring, complicated, difficult grammer, and huge risk of bugs.**

.note[
  There is one more key ingredient of FeynRules model file, `Mixing`; it is not used in the SM.
  You have to read the manual when you handle a model with mixings.]

.note[
  FeynRules can handle superspace and superfields (but it is far beyond the scope of this lecture).]

---
##### Strategy
 * Do not create a model file by your own! : Risk of bugs.
 * Use pre-installed models; they are made by professionals.
 * Append your particles/interaction to those pre-installed models.
   - Do not append everything. Physically interesting particles only.
 * If you write from scratch, you need to verify the files carefully.

---
#### Let's read the simplest model: $\phi^4$ theory

`SM.fr` is very long and difficult to read.
In this lecture we read the model files for $\phi^4$ theory,
$$ \mathcal L = \frac{1}{2}(\partial^\mu\phi)(\partial_\mu\phi) - \frac{\lambda}{4!}\phi^4 - \frac{m^2}{2}\phi^2.$$

Open `phi4.fr` and read it.

.note[
  The file is also found in [GitHub repository](https://github.com/misho104/FeynLecture) : [phi4.fr](https://github.com/misho104/FeynLecture/blob/master/phi4.fr).]
 
---
The file starts with *Information* block.

![:code_title](phi4.fr)
```mathematica
M$ModelName = "phi to four theory";
M$Information = {
              Authors -> "Sho Iwamoto",
              Version -> "0.1",
              Date    -> "Feb. 9, 2011",
              Institutions -> "Technion",
              Emails  -> "sho@physics.technion.ac.il",
              URLs    -> "http://www.misho-web.com/"
              };
```

This information tells you that you must write to them when you find bugs.

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
Then parameters $\lambda$ and $m$ are defined.
(3-point coupling $\kappa$ is commented-out.)

![:code_title](phi4.fr)
```mathematica
M$Parameters = {
  lam == {
         ParameterType -> External,
         BlockName     -> HOGE,
         OrderBlock    -> {1},
         Value         -> 0.1,
         Description   -> "Scalar 4-point coupling"},
  mmm    == {
         ParameterType -> External,
         BlockName     -> HOGE,
         OrderBlock    -> {3},
         Value         -> 100,
         Description   -> "Scalar 2-point coupling"}
};
```

Note these are `External` parameter.
Default values are specified, but (as they are `External`) users can set the values in a SLHA parameter file, like
```
Block hoge
    1 1.000000e-01 # lam
    3 1.000000e+02 # mmm
```
(as specified by `BlockName` and `OrderBlock`).

---
Next, particles are declared:
![:code_title](phi4.fr)
```mathematica
M$ClassesDescription = {
  S[1] == {
        ClassName -> phi,
        SelfConjugate -> True,
        Mass -> {mphi, 100},
        Width -> 0,
        PropagatorLabel -> phi,
        PropagatorType -> S,
        PropagatorArrow -> None,
        FullName -> "Scalar"}
};
```
The name `S[1]` shows it is a scalar particles.

---
Finally the interactions are defined as Lagrangian:
![:code_title](phi4.fr)
```mathematica
Lagrangian = del[phi,mu]del[phi,mu]/2-(lam/24) phi^4 - (mmm^2/2) phi^2;
```
You may easily understand the syntax by comparing this with the Lagrangian
$$ \mathcal L = \frac{1}{2}(\partial^\mu\phi)(\partial_\mu\phi) - \frac{\lambda}{4!}\phi^4 - \frac{m^2}{2}\phi^2.$$

---
.exquiz[
  If you are really interested in FeynRules, you should read `SM.fr` like this.
  Go to [Appendix II](Appendices.html#feynrules_sm_file), and try to decrypt the Standard Model file.]

---
name: feynrules_phi4_validation

#### How to use FeynRules (1) Validation

Now we are going to create *UFO* (for MG5_aMC) and *FeynArts output* of $\phi^4$ theory.
Before creating the output, **we should validate** the model files.

Open `phi4_feynrules.wl` in Mathematica.

.note[
  Though the file has an extension `.wl` (for "Wolfram language package), it is not a package file but intended to use as an usual notebook.
  I like to use `.wl` extension for my code because `.wl` files can be read with text editors.]

---
The first part is for validation.
![:code_title](phi4_feynrules.wl)
```mathematica
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
```
* First line sets the working directory as `NotebookDirectory[]`.
  - Thus output files will be generated in the notebook directory.
* Parallelize is disabled. It is good for calculation speed but sometimes unstable.
* Then `phi4.fr` is loaded, and indices are expanded.

---
There are 6 tests.
You will find that
 - `The Lagrangian is hermitian.`
 - `All mass terms are diagonal.`
 - Analytical values (calculated from Lagrangian) and Model-file values (`Mass -> {mphi, 100}`) of masses are in agreement.
 - `All kinetic terms are diagonal.`
 - `All kinetic terms are correctly normalized.`
 - `All quadratic terms are diagonal.`

The file is now validated.

---
name: feynrules_phi4_output

#### How to use FeynRules (2) Output

Now the main part: generate *UFO* and *FeynArts* output.

In the procedure I have three recommendation:

* You should **quit the kernel** before each output.
 - You can quit the kernel by `Quit[]`, or from the menu: Evaluation > Quit kernel > Local (or your kernel).
* You should execute the whole code *in a single block* (single execution).
 - Otherwise sometimes FeynRules goes unstable. (I don't know why.)
* *Disabling parallelization* (`FR$Parallelize = False`) makes the calculation slower but stable.

---
![:code_title](phi4_feynrules.wl)
```mathematica
SetDirectory[NotebookDirectory[]];
<<FeynRules`;
FR$Parallelize = False;
LoadModel["phi4.fr"];
WriteUFO[Lagrangian];
```
```output
 - FeynRules - 
Version: 2.3.24 ( 12 August 2016).
Authors: A. Alloul, N. Christensen, C. Degrande, C. Duhr, B. Fuks
...
This model implementation was created by
Sho Iwamoto
...
 --- Universal FeynRules Output (UFO) v 1.1 ---
Warning: no electric charge defined. Putting all electric charges to zero.
Starting Feynman rule calculation.
Expanding the Lagrangian...
Collecting the different structures that enter the vertex.
1 possible non-zero vertices have been found -> starting the computation: 1 / 1.
1 vertex obtained.
Flavor expansion of the vertices: 1 / 1
   - Saved vertices in InterfaceRun[ 1 ].
Computing the squared matrix elements relevant for the 1->2 decays: 
0 / 0
Squared matrix elent compute in 0.000655 seconds.
Decay widths computed in 0.000067 seconds.
Preparing Python output.
    - Splitting vertices into building blocks.
    - Optimizing: 1/1 .
    - Writing files.
Done!
```

---
![:code_title](phi4_feynrules.wl)
```mathematica
SetDirectory[NotebookDirectory[]];
<<FeynRules`;
FR$Parallelize = False;
LoadModel["phi4.fr"];
WriteFeynArtsOutput[Lagrangian];
```
```output
 - FeynRules - 
Version: 2.3.24 ( 12 August 2016).
Authors: A. Alloul, N. Christensen, C. Degrande, C. Duhr, B. Fuks
...
This model implementation was created by
Sho Iwamoto
...
Model phi to four theory loaded.

 - - - FeynRules interface to FeynArts - - -
      C. Degrande C. Duhr, 2013
      Counterterms: B. Fuks, 2012
Calculating Feynman rules for L1
Starting Feynman rules calculation for L1.
Expanding the Lagrangian...
Collecting the different structures that enter the vertex.
1 possible non-zero vertices have been found -> starting the computation: 1 / 1.
1 vertex obtained.
Writing FeynArts model file into directory phi_to_four_theory_FA
Writing FeynArts generic file on phi_to_four_theory_FA.gen.
```

---
We set the working directory as `NotebookDirectory[]`.
So the output files are generated in the directory of `phi4_feynrules.wl`:
 * `phi_to_four_theory_UFO`
 * `phi_to_four_theory_FA`

.quiz[
  Read the log file for UFO, `phi_to_four_theory_UFO/phi_to_four_theory_UFO.log` and check no errors/warnings are raised.]

.quiz[
  Open and read the following files and try to find what is written:
  - `phi_to_four_theory_FA/phi_to_four_theory_FA.mod`
  - `phi_to_four_theory_FA/phi_to_four_theory_FA.pars`
  - `phi_to_four_theory_UFO/particles.py`
  - `phi_to_four_theory_UFO/parameters.py`
  - `phi_to_four_theory_UFO/couplings.py`
  - `phi_to_four_theory_UFO/vertices.py`
  - `phi_to_four_theory_UFO/lorentz.py`
]

.exquiz[
  Read the other files.]

---
#### How to use FeynRules (3) Use in FeynArts/FormCalc (`Lecture2-2.nb`)

Now you can calculate the matrix element of $\phi^4$-theory.

.quiz[
  Open `Lecture2-2.nb` and try to calculate $|\mathcal M(\phi\phi\to\phi\phi)|^2$, which should be $|\lambda|^2$.
  How is the model file specified in the notebook?]

---
In FeynArts, we can specify the model through `Model` and `GenericModel` options of `InsertFields`:

```mathematica
diag = InsertFields[topo, {S[1], S[1]} -> {S[1], S[1]}, 
  InsertionLevel -> {Classes}, Model -> model, GenericModel -> model]
```
You should remember that we have defined the particle $\phi$ is defined as `S[1]`.

As we do not have color, helicity, or polarization, you will easily have
```output
lam (lamSuperscript[*])
```
or in FullForm, `Times[lam, Conjugate[lam]]`, which is $|\lambda|^2$.


---
name: feynrules_sm_validation

#### SM model file (1) Validation

Now we move to `SM.fr`: validation, and creating the output.
Note that you can choose the gauge:
  * `FeynmanGauge = False` for unitary gauge ($\xi=\infty$),
  * `FeynmanGauge = True` for Feynman gauge ($\xi=1$).

---
.quiz[
  Open `models/SM/SM.wl` and validate `SM.fr` **in unitary gauge**.]
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
---
We ignore this warning for now, because **I know the file is valid** in unitary gauge :)

.note[
  A more detailed description is in [Appendix III](Appendices.html#feynrules_sm_validation).]

.exquiz[
  Do this validation of `SM.fr` in Feynman gauge.
  Solution may be found in [Appendix III](Appendices.html#feynrules_sm_validation).]

---
name: feynrules_sm_output

#### SM model file (2) Output

Now the main part: generate the output of `SM.fr`.

.note[
  If you use FeynRules in your work, it is strongly recommended to read Section 6 of FeynRules manual.]

.quiz[
  Open `models/SM/SM.wl` and try to generate the following output:
   * UFO in unitary gauge
   * UFO in Feyman gauge
   * FeynRules output in Feynman gauge
]

.exquiz[
  Why is Feynman gauge chosen for FeynArts output?
  ![:answer](Because FeynRules manual says:\n\nFormCalc only supports Feynman gauge. Therefore, FeynRules models can be ex- ported to be used with FormCalc only if they are written in Feynman gauge.)]

---
![:code_title](models/SM/SM.wl)
```mathematica
(* Execute this block to generate UFO in Unitary gauge *)
SetDirectory[NotebookDirectory[]];
<<FeynRules`;
FR$Parallelize = False;

LoadModel["SM.fr"];
FeynmanGauge = False;
(*LoadRestriction["Cabibbo.rst", "Massless.rst"]*)
WriteUFO[LSM, Output->"Standard_Model_UFO_Unitary"];
```
```output
 - FeynRules - 
Version: 2.3.24 ( 12 August 2016).
...
This model implementation was created by
N. Christensen
C. Duhr
B. Fuks
Model Version: 1.4.6
...
Model Standard Model loaded.
 --- Universal FeynRules Output (UFO) v 1.1 ---
Starting Feynman rule calculation.
Expanding the Lagrangian...
Collecting the different structures that enter the vertex.
36 possible non-zero vertices have been found -> starting the computation: 36 / 36.
31 vertices obtained.
Flavor expansion of the vertices: 31 / 31
   - Saved vertices in InterfaceRun[ 1 ].
Computing the squared matrix elements relevant for the 1->2 decays: 
48 / 48
Squared matrix elent compute in 1.54369 seconds.
Decay widths computed in 0.020233 seconds.
Preparing Python output.
    - Splitting vertices into building blocks.
    - Optimizing: 75/75 .
    - Writing files.
Done!
```

---
You will see UFO files generated in a directory `Standard_Model_UFO_Unitary`:
```output
CT_couplings.py    Standard_Model_UFO_Unitary.log        __init__.py    coupling_orders.py
couplings.py       decays.py       function_library.py   lorentz.py     object_library.py
parameters.py      particles.py    propagators.py        vertices.py    write_param_card.py
```
and FeynArts output files in `Standard_Model_FA`.
```output
Standard_Model_FA.gen    Standard_Model_FA.mod    Standard_Model_FA.pars
```
.exquiz[
  Open the files and try to understand what is written.]

.note[
  You may have noticed a line is commented-out: `(*LoadRestriction["Cabibbo.rst", "Massless.rst"]*)`.
  The files `*.rst` are called *restriction files*, which simplify the model parameters **in order to reduce computation time**.]

 .exquiz[
   Open `Massless.rst` and try to find what it does.]

 .exquiz[
   Generate FeynArts output with restrictions `Cabibbo.rst` and `Massless.rst`.
   What is the difference between this restricted output and the previous one? Especially, which files are different?
   ![:answer](In FeynArts output, only the \'pars\' file is affected. Many parameters such as ymup or CKM3x3 are removed in the restricted output.)]

---
#### SM model file (3) Use in FeynArts/FormCalc (`Lecture2-3.nb`)

To learn how to use the FeynArts output `Standard_Model_FA`, let us calculate the QCD two-jet cross section, which [we calculated in `Lecture1-4.nb`](#QCD_amplitudes), again.

.quiz[
  Open `Lecture2-3.nb`, in which we calculate $\sigma(qq'\to qq')$ with `Standard_Model_FA` output files instead of the built-in SM files.
  Evaluate the lines one by one and check whether the same result is obtained.]

---
name: looptools

### 3. One-loop level calculation with LoopTools

#### `Lecture3-1.nb` : QCD one-loop calculation

The last topic: * **LoopTools** for numerical evaluation of one-loop integrals. *

We consider $\sigma_{\text{1-loop}}(u\bar u\to c\bar c)$ as an example to learn how to use LoopTools, and we will see a subtlety in this evaluation.

.quiz[
  How many one-loop diagrams does the process have? ![:answer](Two diagrams, which are box diagrams with gluons.) ]
.quiz[
  What kind of subtlety do we expect? ![:answer](Infrared divergence, because the gluon may have zero-momentum.) ]

---
.quiz[
  Open `Lecture3-1.nb` and evaluate the lines one by one, paying attention to
   * how to include one-loop level diagrams in the calculation,
   * what is special in the amplitude of one-loop level diagrams,
   * how to load `LoopTools`,
   * how we can numerically evaluate the "special functions" in the one-loop amplitudes, and
   * how we can check the presence of IR divergence.
]

---
One-loop level diagrams can be included by introducing one-loop level topologies:
![:code_title](Lecture3-1.nb)
```mathematica
topo0 = CreateTopologies[0, 2 -> 2];
topo1 = CreateTopologies[1, 2 -> 2, ExcludeTopologies -> {Internal}];
topologies = Join[topo1, topo0];
```
Then using `topologies` we can generate both tree and one-loop diagrams.

.exquiz[
  Which diagrams are excluded by this `ExcludeTopologies`?]

---
The one-loop level amplitude has special functions, `C0i[...]` and `D0i[...]`:
```output
...
Alfas2 (
    7/3 C0i[cc0, S, MC2, MC2, 0, 0, MC2]
  - 7/2 D0i[dd00, S, MC2, T, MU2, MC2, MU2, 0, 0, MC2, MU2]
  + 5/3 C0i[cc0, S, MC2, MC2, 0, 0, MC2]
  + ... )
```
They are Passarino-Veltman integrals .ref[[Nucl. Phys. *B160* (1979) 151](http://dx.doi.org/10.1016/0550-3213%2879%2990234-7)].

.quiz[
  Find the definition of these functions in the LoopTools manual.]

**LoopTools numerically evaluates these integrals.**
We can load it by
![:code_title](Lecture3-1.nb)
```mathematica
> Install["LoopTools"]
```
if `$Path` is correctly provided.
After the installation, the Passarino-Veltman integrans can be evaluated, e.g.,
![:code_title](Lecture3-1.nb)
```mathematica
> D0i[dd1, 5, 1, -2, 1, 1, 1, 1, 1, 1, 1]
```
```output
Out[]:= -0.0331433 - 0.235571 I
```

---
As we (should) have noticed, this crosssection
$\sigma_{\text{1-loop}}(u\bar u\to c\bar c)$
has IR divergence, because one of the gluons in the loop can have $k=0$ and its propagator
$$
\frac{-\ii}{k^2 + \ii \epsilon }
$$
falls in a pole.

LoopTools may detect the divergence and output a message, like

![:code_title](Lecture3-1.nb)
```output
 ffxc0i: infra-red divergent threepoint function, working with a cutoff    1.00000000000
 ffxdbd: using IR cutoff lambda^2 =    1.00000000000
```
but also we can check the presence of IR divergence by ourselves by varying the Pauli-Villarss mass parameter $\lambda^2$:
![:code_title](Lecture3-1.nb)
```mathematica
SetLambda[10^2];
```
The matrix element should not depend on Λ but does, which means it is IR-divergent.

---
.exquiz[
  Read the LoopTools manual to find how to use `SetLambda`.]

.note[
  In this lecture we have used the *Mathematica interface* of LoopTools.
  LoopTools can also be used in FORTRAN or C (C++) codes, which will reduce the computation time.
  It is recommended to use FORTRAN or C for complicated process.]

.exquiz[
  Try to evaluate `B0[1000, 50, 80]` by using FORTRAN or C interface as well as on Mathematica, and verify the same result is obtained.
  ![:hint](Solution can be found in LoopTools manual. The numerical value should be -4.40593 + 2.70414 I.) ]

---
#### `Lecture3-hgg.nb` : $\Gamma(h\to\gamma\gamma)$

Now you can easily calculate the decay rate of $h\to\gamma\gamma$!

.quiz[
  Verify that the partial decay rate is given by
  $$ \Gamma(h\to\gamma\gamma) = \frac{1}{32\pi m_h}\left|\mathcal M\right|^2.$$]
.quiz[
  Open `Lecture3-hgg.nb` and evaluate.
  Calculate the partial decay rate of $h\to\gamma\gamma$ and compare with literatures, such as [CERN Yellow Report 3 (2013)](https://twiki.cern.ch/twiki/bin/view/LHCPhysics/CERNYellowReportPageBR2014).  ]

---
.exquiz[
  Check that this calculation is
  ![:hint](
    To verify UV finiteness, you should look up `UVDivergentPart` in the FormCalc manual.
    For IR finiteness, `SetLambda` in the LoopTools manual will help you.)
   * UV finite,
   * IR finite,
   * gauge invariant.]
.exquiz[
  What does `PaVeReduce -> True` mean?
  ![:hint](Read the FormCalc manual!)]

---
#### `Lecture3-ex-eevh.nb` [Exercise] Higgs production at the ILC

Now it's time to do everything by yourself!

We want to calculate the production cross section of Higgs boson at the ILC ($e^+ e^-$ collider with $\sqrt s = E\w{MC} = 250\GeV$).

.quiz[
  How can we produce Higgs boson at the ILC?
  Which process will be dominant? ]


.quiz[
  Open `Lecture3-ex-eevh.nb`, and calculate $\sigma\w{tree}(ee\to hZ)$ and $\sigma\w{tree}(ee\to h\gamma)$ with FeynArts/FormCalc.]

.quiz[
  Find the cross section in reliable literatures, and compare your result with them.]
  
.exquiz[
  Calculate the crosssections at the one-loop level.]
