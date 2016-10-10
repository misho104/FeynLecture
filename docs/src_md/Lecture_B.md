# Tools for BSM Physics (B)

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
name: introduction

### 0. Introduction: What is Monte Carlo simulation?

 * [Wikipedia](https://en.wikipedia.org/wiki/Monte_Carlo_method) :
  > computational algorithms that rely on repeated random sampling to obtain numerical results
 * Why do we need MC?
  - Uncertainty principle : quantum physics is probabilistic.

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
.topright[![:width 35%](imgs/sin_exp_x.png)]
#### Example 2 (Numerical integration)

$$
 \int_0^1 \sin(\mathrm e^x){\mathrm d}x=\ ?
$$

Answer: As the integrand &le; 1, we can calculate the integral as the probability that an arrow thrown into the square hits below the line.
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
  Note that 0 &le; sin(e<sup>x</sup>) &le; 1 (for the integrated range 0 &le; x &le; 1) is the crucial information in this calculation.
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
name: sm

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
##### Importance of scripting

At an early stage of your project, you may try-and-error on the MG5 user-friendly interactive interface.
However, the MG5 interface **should not** be used for your final materials.

*All materials you use in your paper should be generated from scripts*, because it makes debugging easier.
Also,
 * your collaborators can check, review and validate your procedure,
 * you can re-use the script in your next project,
 * when someone finds your work interesting and ask you to send the data, you can send the script.

---
#### Theoretical background (review)

The crosssection $\sigma(pp\to t\bar t)$ is given by 
$$ \sigma(pp\to t\bar t) = \sum\sub{a,b}\int_0^1\dd x\sub a \int_0^1 \dd x\sub b\
                           f\sub a(x\sub a,\mu\w F) f\sub b(x\sub b,\mu\w F)\sigma(ab\to t\bar t)$$
where
 - $a,b=g, u, \bar u, d, \bar d, ...$ is a parton,
 - $f_a(x, \mu\w F)$ is the parton distribution function, which describes the probability that a parton $a$ with an energy $x E\w{beam}$ is pulled out from a proton.
 - $\mu\w F$ is the factorization scale.
 - $\sigma(ab\to t\bar t)$ is the partonic cross section with $E\sub a = x\sub a E\w{beam}$ etc.:

$$\sigma(ab\to t\bar t) = \frac{1}{2 E\sub a E\sub b |v\sub a-v\sub b|} \int\w{phase space}\dd\Pi\sub 2 \left|\mathcal M(ab\to t\bar t)\right|^2.$$

.exquiz[
  Look up "parton luminosity" in literatures, e.g., Ellis-Stirling-Webber Chapter 7.]
  
---
name: models

### 2. MadGraph5 basic+: Use other models

#### How to use models
The art of MadGraph5_aMC@NLO: **we can calculate processes in any models!**
 - pre-installed models
 - UFO from FeynRules

.quiz[
  Which models are pre-installed MadGraph5_aMC@NLO?]

---
Pre-installed models are stored in `models` directory of your MG5_aMC installation:
```shlarge
> ls models/
```
```output
2HDM/    4Gen/     DY_SM/   EWdim6/
...
mssm/    mssm_v4/  nmssm/   sextet_diquarks/    sm/
...
```
You may find `sm` directory, in which the `sm` model, which we used in the last section, is stored.
.quiz[
  In which format are the `sm` models written?
  ![:answer](The UFO format. Note that the UFO format is explained in Lecture A-2.)]
.exquiz[
  Who are the authors of the `sm` directory?
  ![:answer](N. Christensen and C. Duhr, as is written in __init__.py)]

Also you may find `mssm` directory.
Yes, the MSSM is pre-installed!
Let's try to use it!

---
#### MSSM crosssections

A model can be loaded by `import` command:
```mg5large
> import model mssm
```
```output
INFO: Restrict model mssm with file ../models/mssm/restrict_default.dat .
INFO: Run "set stdout_level DEBUG" before import for more information.
INFO: Change particles name to pass to MG5 convention
Kept definitions of multiparticles l- / j / vl / l+ / p / vl~ unchanged
Defined multiparticle all = g u c d s u~ c~ d~ s~ a ve vm vt e- mu- ve~ vm~ vt~ e+ mu+
  go ul cl t1 ur cr t2 dl sl b1 dr sr b2 ul~ cl~ t1~ ur~ cr~ t2~ dl~ sl~ b1~ dr~ sr~ b2~
  t b t~ b~ z w+ h1 h2 h3 h+ sve svm svt el- mul- ta1- er- mur- ta2- w- h- sve~ svm~ svt~
  el+ mul+ ta1+ er+ mur+ ta2+ n1 n2 n3 n4 x1+ x2+ ta- x1- x2- ta+
```
.quiz[
  Which particles can you find in the MSSM model? ]
.quiz[
  How can we identify a particle? For example, what is the particle `sve`?]

---
Now you are ready to calculate MSSM cross sections!

In this section we assume $m\sub{\tilde e\w L} = m\sub{\tilde e\w R} = 200\GeV$, ignoring the left-right mixing.
.quiz[
  Calculate $\sigma\w{LO}(pp\to \tilde e^+\w L \tilde e^-\w L)$ at the 8 TeV and 13 TeV LHC.
  (You can ignore the left-right mixing.)]
.quiz[
  To verify your results, compare either of them (8 or 13 TeV) with literatures.]
.quiz[
  Calculate $\sigma\w{LO}(e^+ e^- \to \tilde e^+\w L\tilde e^-\w L)$ at the ILC with $E\w{beam}=250\GeV$, assuming that all the neutralinos ($\tilde \chi^0_{1,2,3,4}$, or `n1`&ndash;`n4`) are decoupled (extremely heavy and ignorable).  ]

.exquiz[
  Calculate the previous crosssection, assuming that $\tilde\chi^0\sub 1$ is a pure-Bino ($\tilde B$) with a mass $100\GeV$, and that the other neutralinos are decoupled.]

---
.exquiz[
  We can consider any models once we have prepared FeynRules model, even $\phi^4$-theory:
  $$ \mathcal L = \frac{1}{2}(\partial^\mu\phi)(\partial_\mu\phi) - \frac{\lambda}{4!}\phi^4 - \frac{m^2}{2}\phi^2.$$
  Let us imagine we have $\phi\phi$ collider with $E\w{beam}=100\GeV$, and $m=1\GeV$ and $\lambda = 0.1$.
  Prepare the UFO format files for this model (See [Lecture A-2](Lecture_A.html#feynrules)) and calculate $\sigma\w{LO}(\phi\phi\to\phi\phi)$ at this collider.]

---
##### Solutions to the quizzes

We can see the particles by the command `display`.
```mg5large
> display particles
```
```output
Current model contains 48 particles:
w+/w- x1+/x1- x2+/x2- h+/h- ve/ve~ vm/vm~ vt/vt~ e-/e+ mu-/mu+ ta-/ta+ u/u~ c/c~ t/t~ d/d~
s/s~ b/b~ sve/sve~ svm/svm~ svt/svt~ el-/el+ mul-/mul+ ta1-/ta1+ er-/er+ mur-/mur+ ta2-/ta2+
ul/ul~ cl/cl~ t1/t1~ ur/ur~ cr/cr~ t2/t2~ dl/dl~ sl/sl~ b1/b1~ dr/dr~ sr/sr~ b2/b2~
a z g n1 n2 n3 n4 go h1 h2 h3
```

```mg5large
> display particles sve
```
```output
Particle sve has the following properties:
{
    'name': 'sve',
    'antiname': 'sve~',
    'spin': 1,
    'color': 1,
    'charge': 0.00,
    'mass': 'mdl_Msn1',
    'width': 'mdl_Wsn1',
    'pdg_code': 1000012,
...
}
```
Note that it is scalar (s=0) because `spin`=2s+1.

---
You can check interactions:
```mg5large
> display interactions sve
```
```output
Interactions 92 : e+ x1- sve  has the following property:
{
    'id': 102,
    'particles': [-11,-1000024,1000012],
    'color': [1 ],
    'lorentz': ['FFS1'],
    'couplings': {(0, 0): 'GC_388'},
    'orders': {'QED': 1},
    'loop_particles': None,
    'type': 'base',
    'perturbation_type': None
}
...
```
Then, what is `GC_388`?
```mg5large
> display couplings GC_388
```
```output
Note that this is the UFO informations.
 "display couplings" present the actual definition
prints the current states of mode
name   	: GC_388
value  	: -((ee*complex(0,1)*I89x11*VV1x1)/sw)
order  	: {'QED': 1}
```

---
Of course, you can also look up the particles / interactions / parameter by directly reading the UFO model files.

.exquiz[
  Read the help of `display` by
  ```mg5
> help display
  ```]

---
Now calculate $\sigma\w{LO}(pp\to \tilde e^+\w L\tilde e^-\w L)$.
(You can check which particle is $\tilde e^\pm$ by using `display particles el+` etc.)
```mg5large
> import model mssm
> generate p p > el+ el-
> output pp2elel
```
Let us see the diagrams by `display diagrams` (or `open index.html`).
You will find four diagrams:

.center[
  ![:width 50%](imgs/pp2elel.png)]

---
We know that $\tilde e\w L^\pm$ is the only relevant particle, and in `param_card.dat` we need to modify only the mass of $\tilde e\w L$.
Therefore,
```mg5large
> launch
> 0
```
```output
Do you want to edit a card (press enter to bypass editing)?
  1 / param      : param_card.dat
  2 / run        : run_card.dat
...
 [0, done, 1, param, 2, run, enter path][60s to answer]..
```
```mg5large
> 1
```
![:code_title](param_card.dat)
```mg5card
...
      1000005 5.130652e+02 # msd3
      1000006 3.996685e+02 # msu3
      1000011    200       # set of param :1*msl1, 1*msl2
      1000012 1.852583e+02 # set of param :1*msn1, 1*msn2
      1000015 1.344909e+02 # msl3
      1000016 1.847085e+02 # msn3
...
```

---
Then modify the beam energy for 8 TeV LHC:
```output
Do you want to edit a card (press enter to bypass editing)?
 [0, done, 1, param, 2, run, enter path][60s to answer]..
```
```mg5large
> 2
```
![:code_title](run_card.dat)
```mg5card
...
     1        = lpp1    ! beam 1 type 
     1        = lpp2    ! beam 2 type
     4000.0     = ebeam1  ! beam 1 total energy in GeV
     4000.0     = ebeam2  ! beam 2 total energy in GeV
...
```
```output
Do you want to edit a card (press enter to bypass editing)?
 [0, done, 1, param, 2, run, enter path][60s to answer]..
```
```mg5large
> 0
```
And you will see the crosssection:
```output
  === Results Summary for run: run_01 tag: tag_1 ===

     Cross-section :   0.00619 +- 1.09e-05 pb
     Nb of events :  10000
```

---
You can also use the `set` command (or write a script):
```mg5large
> import model mssm
> generate p p > el+ el-
> output pp2elel
> launch --laststep=parton
> set mass 1000011 200
> set ebeam 4000
> 0
```

.note[
  In fact, you can use the variable name in the "comment" part:
![:code_title](param_card.dat)
```mg5card
      1000011    200       # set of param :1*msl1, 1*msl2
```
  i.e., `set msl1 200` instead of `set mass 1000011 200`.
  But I do not recommend to use this feature because it needs the comment line is correctly written, and very dangerous!]

---
.note[
  You can use `set lhc 8` instead of `set ebeam 4000`:
```mg5
> set lhc 8
```
```output
INFO: modify parameter lpp1 of the run_card.dat to 1
INFO: modify parameter lpp2 of the run_card.dat to 1
INFO: modify parameter ebeam1 of the run_card.dat to 4000.0
INFO: modify parameter ebeam2 of the run_card.dat to 4000.0
```
  This will be useful in scripting.]

---
Then you are asked to compare your results with literatures so that you can be confident.

If you are lazy enough, you google `slepton LHC cross section` and [find several plots](https://www.google.co.kr/search?q=slepton+LHC+cross+section&amp;tbm=isch).
For example, [this figure](https://www.google.co.kr/search?q=slepton+LHC+cross+section&amp;tbm=isch&amp;imgrc=Nsy9FkD76jYgFM%3A) will be sufficient for this purpose.

If you are a bit more careful, you will reach [LHC SUSY Cross Section Working Group](https://twiki.cern.ch/twiki/bin/view/LHCPhysics/SUSYCrossSections), or [arXiv:1310.2621](https://arxiv.org/abs/1310.2621), and find that
 $$\sigma\w{LO} = 7.3^{+0.3}\w{-1.4}\fb
   \quad
   \left(18.84^{+0.24}\sub{-0.30}\fb\right)$$
for 8 TeV (13 TeV) and start to worry because your results are a bit smaller.
However they are roughly comparable, and we accept this result.

.note[
  I am actually not sure why my results, which are 6.2 fb and 15.8 fb for 8 TeV and 13 TeV, are a bit smaller than the values above by Benjamin .arxiv_link[[1310.2621](https://arxiv.org/abs/1310.2621)].
  I'd like you to tell me why if you find, but anyway this difference (about 20 %) is not so bad for LO calculation (because of scale or PDF uncertainties).]

---
For ILC cross section you execute `import model mssm` and
```mg5
> generate e+ e- > el+ el-
```
Here, `display diagrams` gives many diagrams:

.center[
  ![:width 80%](imgs/ee2elel.png)]

As we assume `n1`&ndash;`n4` are heavy and ignorable, we want to consider only the first two diagrams.

---
This can be done by `/` option of `generate` command.
So the solution is:
```mg5large
> import model mssm
> generate e+ e- > el+ el- / n1 n2 n3 n4
> output ee2elel
```
.quiz[
  Check that you get diagrams as you want by `display diagrams`.]
.exquiz[
  Read the help of generate (`help generate`).]

Then everything else is as before:
```mg5large
> launch --laststep=parton
> set ilc 500
> set mass 1000011 200
> 0
```
and you will get the crosssection. ![:answer](I obtained 25.9fb.)

---
.note[
  You can manually edit the files instead of `set`:
![:code_title](param_card.dat)
```mg5card
...
      1000011    200       # set of param :1*msl1, 1*msl2
...
```
![:code_title](run_card.dat)
```mg5card
...
#*********************************************************************
# Collider type and energy                                           *
# lpp: 0=No PDF, 1=proton, -1=antiproton, 2=photon from proton,      *
#                                         3=photon from electron     *
#*********************************************************************
  0	= lpp1 ! beam 1 type 
  0	= lpp2 ! beam 2 type
  250.0	= ebeam1 ! beam 1 total energy in GeV
  250.0	= ebeam2 ! beam 2 total energy in GeV
...
```
]


---
##### Solutions to the extra quizzes

The neutralino $\tilde\chi^0\sub{1,2,3,4}$ is a mixture of $(\tilde B, \tilde W^3, \tilde H\w d, \tilde H\w u)$.
You are asked to set the mixing angle so that $\tilde\chi^0\sub 1\equiv \tilde B$.

As `param_card.dat` follows [SLHA](https://arxiv.org/abs/hep-ph/0311123), the mixing should be written in `NMIX` block as
$$\tilde\chi^0 = N\begin{pmatrix}-\ii\tilde B \\\\ -\ii\tilde W^3 \\\\ \tilde H\w d \\\\ \tilde H\w u\end{pmatrix}$$
with $N$ being an unitary matrix.

So, it is easy to set $N$ as a unit matrix.

---
Therefore, `generate` is now
```mg5large
> generate e e > el+ el- / n2 n3 n4
```
and `param_card.dat` should be

![:code_title](param_card.dat)
```mg5card
BLOCK MASS #
...
      1000011    200       # set of param :1*msl1, 1*msl2
...
      1000022    100       # mneu1
...
BLOCK NMIX # 
      1 1     1         # rnn1x1
      1 2     0         # rnn1x2
      1 3     0         # rnn1x3
      1 4     0         # rnn1x4
      2 1     0         # rnn2x1
      2 2     1         # rnn2x2
      2 3     0         # rnn2x3
      2 4     0         # rnn2x4
      3 1     0         # rnn3x1
      3 2     0         # rnn3x2
      3 3     1         # rnn3x3
      3 4     0         # rnn3x4
      4 1     0         # rnn4x1
      4 2     0         # rnn4x2
      4 3     0         # rnn4x3
      4 4     1         # rnn4x4
...
```

---
Now you can go straightforwardly. ![:answer](I obtained 8.69fb.)

---
To calculate the process of $\phi^4$-theory, you need to generate the UFO from `phi4.fr`the UFO files from `phi4.fr` as explained in [Lecture A-2](Lecture_A.html#feynrules).

Then you move the UFO files to `models` directory of MG5_aMC installation.
```sh
> mv phi_to_four_theory_UFO (your path to MG5)/models/
> cd (your path to MG5)
> ls models/
```
```output
2HDM/      4Gen/    DY_SM/    EWdim6/
...
phi_to_four_theory_UFO/
...
```
(or you can rename `phi_to_four_theory_UFO` to `phi4` etc.)

Now you are ready!
```mg5large
> import model phi_to_four_theory_UFO
> generate phi phi > phi phi
> output phiphi2phiphi
> launch
```

---
The cards should be:
![:code_title](param_card.dat)
```mg5card
Block hoge 
    1   0.1        # lam 
    3 1.000000e+02 # mmm 

Block mass 
  9000001 1 # mphi 
```
and
![:code_title](run_card.dat)
```mg5card
     0         = lpp1    ! beam 1 type 
     0         = lpp2    ! beam 2 type
     100.0     = ebeam1  ! beam 1 total energy in GeV
     100.0     = ebeam2  ! beam 2 total energy in GeV
```

---
Compare your results with the theoretical cross section!

$$
\sigma
= \frac{1}{4E\sub a E\sub b |v\sub a-v\sub b|}\int\dd\Pi_2/2 \ |\mathcal M|^2
$$
with $E\sub a=E\sub b=100\GeV$, $|v\sub a-v\sub b|=2|v\sub a|=1.9999$, and $\mathcal M=\lambda=0.1$.
The phase space is halved because the final state particles are identical particles:
$$
\int\dd\Pi_2/2 = \frac{1}{2}\int\frac{\dd\Omega}{4\pi}\frac{1}{8\pi}\frac{2|p\w{final}|}{E\w{cm}}
= 0.01989.
$$
Finally,
$$
\sigma\w{LO}(\phi\phi\to\phi\phi) = 2.486\times 10^{-9}\GeV^{-2} = 0.968\pb.
$$
