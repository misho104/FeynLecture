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
