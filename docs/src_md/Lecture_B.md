# Tools for BSM Physics (B-1)

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
  &copy; 2012-2016 <a href="http://www.misho-web.com">Sho Iwamoto</a>

  These lecture slides are licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">Creative Commons Attribution-NonCommercial 4.0 International License</a>.

  Lecture materials are available at [https://github.com/misho104/FeynLecture/](https://github.com/misho104/FeynLecture/).

  <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/"><img alt="Creative Commons License" style="border-width:0" src="assets/cc_by_nc.png" /></a>
]

---
## Lecture B: <br> Monte Carlo simulation

  * MadGraph_aMC@NLO
    - Pythia
    - Delphes (internally used packages: FastJet, ExRootAnalysis, ...)
  * MadAnalysis
  * CheckMATE

.note[
  This lecture includes contents from the following materials/tutorials:
   - MadGraph5_aMC@NLO tutorial by Marco Zaro, Hua-Sheng Shao, Benoit Hespel, Antony Martini, and Joannis Tsinikos.
]

---
### 0. Introduction: What is Monte Carlo simulation?

 * [Wikipedia](https://en.wikipedia.org/wiki/Monte_Carlo_method) :
  > computational algorithms that rely on repeated random sampling to obtain numerical results
 * Why do we need MC?
  - Uncertainty principle : microscopic physics is probabilistic.

---
#### Example 1 (Rolling Dice)

You throw a dice twice.
What is the probability to get the sum = 7?

Answer: *~~1/6~~* ...with the following `python2` code, the probability is *approximately* 16.35%.

```python
import random    # we will use 'random' module
samples = 10000

trials = 0
successes = 0
for i in range(0, samples):     # loop for "samples"-times
  throw1 = random.randint(1, 6)
  throw2 = random.randint(1, 6)
  sum = throw1 + throw2

  trials += 1
  if sum == 7:
    successes += 1

print successes * 1.0 / trials # ==> 0.1635
```

.exquiz[
  Try on your computer or on [repl.it](https://repl.it/languages/python).
  Change `samples` from 10000 to 100, or 50000.
  Try to calculate the probability of having sum = 12.]

---
#### Example 1a (Rolling Dice)

You throw a dice twice.
What is the probability to get the sum = 7?
*But here, if the sum is < 7, you do the third throw.*

Answer: With the following `python2` code, *approximately* 24%.

```python
import random    # we will use 'random' module
samples = 10000

trials = 0
successes = 0
for i in range(0, samples):     # loop for "samples"-times
  throw1 = random.randint(1, 6)
  throw2 = random.randint(1, 6)
  sum = throw1 + throw2

  if throw1 + throw2 < 7: # the new condition
    throw3 = random.randint(1, 6)
    sum += throw3

  trials += 1
  if sum == 7:
    successes += 1

print successes * 1.0 / trials # ==> 0.2382
```

---
.topright[![:width 35%](assets/sin_exp_x.png)]
#### Example 2 (Numerical integration)

$$
 \int_0^1 \sin(\mathrm e^x){\mathrm d}x=?
$$

Answer: As the integrand <= 1, we can calculate the integral as the probability that an arrow thrown into the square hits below the function.
With the following python2 code, *approximately 0.87*.
.clear[
```python
import random
import math
samples = 10000

trials = 0
successes = 0
for i in range(0, samples):     # loop for "samples"-times
  x = random.random()           # returns 0 <= x < 1
  y = random.random()

  trials += 1
  if y < math.sin(math.exp(x)):
    successes += 1

print successes * 1.0 / trials # ==> 0.8716
```
]

.exquiz[
  Calculate $\pi$ by MC.
  (Hint: Throw dirts to a circle.)
  Can you do this without trigonometric functions (sin etc.)?]

---
.note[
  Note that $0 \le \sin(\mathrm e^x) \le 1$ (for the integrated range $0\le x\le 1$) is the crucial information in this calculation.
  In practice we do not know the range of integrand, and we have to figure it out.]
.note[
  If the integrand has a peak, you will need many `samples` to converge the integral.
  This is a difficulty of numerical integration in practice.
  *The art of MadGraph5 is that it solves this problem in a sophisticated way.*

  .exquiz[Try to integrate Breit-Wigner distribution with $m=0.5$ and $\Gamma=0.01$ with MC method:
          $$ \int_0^1\frac{1}{(x-m)^2 + \Gamma^2/4}\dd x.$$]
]
---
The results are *approximately* correct.
=> **statistical uncertainty!**

Usually statistical fluctuation is explained by Poisson distribution.
In the first example, the "`successes`" has an uncertainty
$$\text{successes} \pm \sqrt{\text{successes}}.$$
So the obtained probability will be
$$\frac{1}{6}\pm \frac{1}{\sqrt{6\times\text{(samples)}}}$$

.exquiz[
  Write a code to compute the uncertainty of Example 1 code, and verify the uncertainty is given by this formula (in Mathematica or your favorite code).]
.exquiz[
  Check that, to obtain the probability of sum = 12 with the same level of accuracy, you need more `samples` than in sum = 7 case.]
.exquiz[
  Why the uncertainty is given by this formula? i.e., Why Poisson distribution? ]



---
### 1. MadGraph5 basic: Standard Model tree-level

#### $pp\to t\bar t$, the most boring example

We calculate $\sigma\w{tree}$ (or $\sigma\w{LO}$) of $pp\to t\bar t$ in the Standard Model.
Type the following command on MadGraph5_aMC@NLO.

```mg5large
> generate p p > t t~
> output pp2tt_tree
> launch
```

You will have an HTML file open, where some cross section is displayed.

Yes, this is all! ...but what did you actually do?

---
.quiz[
  Open `param_card.dat` and `run_card.dat`, and confirm the values you used in this simulation.]
.quiz[
  Is your crosssection consistent with literatures?]
.quiz[
  Which partonic subprocesses (diagrams) are calculated?]
.quiz[
  Which diagrams are NOT included in the calculation?
  They are not included because smaller contribution.
  Why, and how small?
  (Do an estimate before actual MC simulation!)
  Then, include those diagrams into the calculation.
  How much does the crosssection change?]
.quiz[
  Modify the parameters. For example, try to calculate the cross section at the 8TeV LHC ($E\w{beam}$=4000GeV) with $m_t$ = 180GeV.]

---
.exquiz[
  Are b-quarks included as the initial partons? If not, how can we include them?]
.exquiz[
  Recompute $\sigma\w{LO}(pp\to t\bar t)$ for $m_t$ = 170, 172, ..., 180 GeV at the 14 TeV LHC.]
.exquiz[
  Read `param_card.dat` and `run_card.dat`, and try to understand the parameter as much as possible.
  Theorists are expected to understand the parameters `param_card.dat` you should know all the parameters.
  Meanwhile, one does not have to understand all the parameters of `run_card.dat`, but try to understand as much as possible; at least you should know there are those parameters.]

---
#### Solutions to Quizzes

![:code_title](param_card.dat)
```mg5card
###################################
## INFORMATION FOR MASS
###################################
Block mass
    5 4.700000e+00 # MB
    6 1.730000e+02 # MT
```

![:code_title](run_card.dat)
```mg5card
#*********************************************************************
# Collider type and energy                                           *
# lpp: 0=No PDF, 1=proton, -1=antiproton, 2=photon from proton,      *
#                                         3=photon from electron     *
#*********************************************************************
     1        = lpp1    ! beam 1 type
     1        = lpp2    ! beam 2 type
     6500.0     = ebeam1  ! beam 1 total energy in GeV
     6500.0     = ebeam2  ! beam 2 total energy in GeV
```

You should also have noticed a message in `output` command. It says:
```output
Loading default model: sm
INFO: Restrict model sm with file ....../models/sm/restrict_default.dat .
```
Now you know you used the `sm` model files in this `models` directory, and it is restricted by `restrict_default.dat`.

---
```output
  === Results Summary for run: run_01 tag: tag_1 ===

     Cross-section :   505.6 +- 1.046 pb
     Nb of events :  10000
```
*INCONSISTENT* with experiment data (e.g. $818\pm36\pb$ ![:arxiv 1606.02699]), because of **NLO corrections**.

To compensate this difference, we often *"weight" each event* by **K-factor**,
$$K := \frac{\sigma\w{NLO}}{\sigma\w{LO}}.$$
Note that this is an approximation: *it ignores the difference of kinematic distributions between LO and higher-order.*
.note[
  Needless to say, you can use the experimental value $\sigma\w{exp}$ etc. instead of $\sigma\w{NLO}$ as the "scaled" crosssection.]

---
Partonic processes can be viewed in the generated HTML files ("Process Information" in the main page), or by
```mg5large
> display processes
```
```output
Process: g g > t t~ WEIGHTED<=2 @1
Process: u u~ > t t~ WEIGHTED<=2 @1
```

Feynman diagrams can be found in the HTML files, or by
```mg5large
> display diagrams
```

---
QCD diagrams are all included, but non-QCD diagrams (Z- or photon-mediated S-channel) are not. This is because
 * non-QCD diagrams need $\bar q$ from proton, while QCD uses gluons,
 * QCD couplings are larger: $(\alpha_s/\alpha\w{EM})^2\sim10$) (and color factor 3),
 * non-QCD diagrams have the s-channel propagator.

So non-QCD contribution is smaller by 30, but should be smaller by far because of the $\bar q$-PDF.


You can include them, and find $\sigma\w{LO}$ is barely modified, by
```mg5large
> generate p p > t t~ QCD=2 QED=2
```

.note[
  `generate p p > t t~ QCD=0 QED=2` to check the non-QCD contribution, but note that the interference is ignored:
  $$\left|\mathcal M\right|^2 = \left|\mathcal M\w{QCD} + \mathcal M\w{QED+EW}\right|^2$$
  .exquiz[
    Find the contribution of the process `P1_qq_ttx` in the generated HTML files, and compare the contribution in QCD-only and non-QCD-only calculation.]
  ]

---
Two ways to edit the parameters:
```mg5large
> generate p p > t t~
> output pp2tt_tree
> launch
```
```output
generate_events run_02
The following switches determine which programs are run:
 1 Run the pythia shower/hadronization:                              pythia=NOT INSTALLED
 2 Run PGS as detector simulator:                                       pgs=NOT INSTALLED
 3 Run Delphes as detector simulator:                               delphes=NOT INSTALLED
 4 Decay particles with the MadSpin module:                         madspin=OFF
 5 Add weights to the events based on changing model parameters:   reweight=OFF
  Either type the switch number (1 to 5) to change its default setting,
  or set any switch explicitly (e.g. type 'madspin=ON' at the prompt)
  Type '0', 'auto', 'done' or just press enter when you are done.
 [0, 4, 5, auto, done, madspin=ON, madspin=OFF, madspin, reweight=ON, ... ][60s to answer]
```
```mg5large
> 0
```
```output
Do you want to edit a card (press enter to bypass editing)?
  1 / param      : param_card.dat
  2 / run        : run_card.dat
```
and *type 1 (2)* to edit `param_card.dat` (`run_card.dat`).

Or...

---
```output
Do you want to edit a card (press enter to bypass editing)?
  1 / param      : param_card.dat
  2 / run        : run_card.dat
 you can also
   - enter the path to a valid card or banner.
   - use the 'set' command to modify a parameter directly.
     The set option works only for param_card and run_card.
     Type 'help set' for more information on this command.
   - call an external program (ASperGE/MadWidth/...).
     Type 'help' for the list of available command
```
```mg5large
> set MT 180
> set EBEAM1 4000
> set EBEAM2 4000
> 0
```
(Type `help set` to know more!)

The program will answer to you, like
```output
INFO: modify param_card information BLOCK mass with id (6,) set to 180.0
```
```output
INFO: modify parameter ebeam2 of the run_card.dat to 4000
```

---
#### Solutions to Extra Quizzes
Is $bb\to t t~$ included?
```mg5large
> generate p p > t t~
> display processes
```
```output
Process: g g > t t~ WEIGHTED<=2 @1
Process: u u~ > t t~ WEIGHTED<=2 @1
Process: c c~ > t t~ WEIGHTED<=2 @1
Process: d d~ > t t~ WEIGHTED<=2 @1
Process: s s~ > t t~ WEIGHTED<=2 @1
```
No! b-quarks are not considered as initial partons. This is just because
```mg5large
> display multiparticles
```
```output
Multiparticle labels:
all = g u c d s u~ c~ d~ s~ a ve vm vt e- mu- ve~ vm~ vt~ e+ mu+ t b t~ b~ z w+ h w- ta- ta+
l- = e- mu-
j = g u c d s u~ c~ d~ s~
vl = ve vm vt
l+ = e+ mu+
p = g u c d s u~ c~ d~ s~
vl~ = ve~ vm~ vt~
```

---
So all you have to do is
```mg5large
> define p = g u c d s u~ c~ d~ s~ b b~
> generate p p > t t~
```
---
Finally, let's calculate $\sigma\w{LO}(pp\to t\bar t)$ for $m_t$ = 170, 172, ..., 180 GeV at the 14 TeV LHC.
Open your favorite editor and create a file `myinput.txt`, like
![:code_title](myinput.txt)
```mg5input
generate p p > t t~
output pp2tt_tree_2
launch -n run_14TeV_MT170 --laststep=parton
set ebeam1 7000
set ebeam2 7000
set mt 170
done
launch -n run_14TeV_MT172 --laststep=parton
set mt 172
done
launch -n run_14TeV_MT174 --laststep=parton
set mt 174
done
launch -n run_14TeV_MT176 --laststep=parton
set mt 176
done
launch -n run_14TeV_MT178 --laststep=parton
set mt 178
done
launch -n run_14TeV_MT180 --laststep=parton
set mt 180
done
```

---
**We will use this file as script**. Execute from the terminal,
```shlarge
> bin/mg5_aMC myinput.txt
```
Then all the crosssections you want are *automatically* calculated.

---
#### Importance of scripting

At an early stage of your project, you may try-and-error on the MG5 user-friendly interactive interface.
However, the MG5 interface **should not** be used for your final materials.

*All materials you use in your paper should be generated from scripts*, because it makes debugging easier.
Also,
 * your collaborators can check, review and validate your procedure,
 * you can re-use the script in your next project,
 * when someone finds your work interesting and ask you to send the data, you can send the script.

