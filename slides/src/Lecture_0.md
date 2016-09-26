# Tools for BSM Physics (0)

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
## Lecture 0: <br> Pre-course work
  1. [Mathematica basic](#mathematica_basic)
  2. [Installation : FeynArts+FormCalc+LoopTools and FeynRules](#install_feyn)
  3. [Installation : MadGraph_aMC@NLO](#install_mg5)
  4. [Built-in Tutorial of MadGraph_aMC@NLO](#mg5_tutorial)
  5. [Small Quizzes](#small_quizzes)
---
.note[
  This lecture slides have several "notes" like this.
  They are a bit advanced or digressed, and not covered in the lecture hours and expected to be read afterwards.]


.quiz[
  This is a quiz. Quizzes are covered in the lecture hours (as much as possible).  ]
.quiz[
  You throw a dice twice. What is the probability to have the sum = 7? ![:answer](1/6) ]

.exquiz[
  This is an extra quiz. Extra quizzes are "extra" just because they require some skill of programming. Not "advanced".  ]

.exquiz[
  Write a program (in any language) to display the sum of two dice rolls.
  Then, calculate the probability to have the sum = 7, and check it is the same as what you calculated just above.
  (You will see a solution in Lecture B-1.)]

---
name: mathematica_basic

### 1. Mathematica basic
.quiz[
  In this course we will use many Mathematica built-in functions, some of which you may be unfamiliar with.
  Not to be trapped in technical aspects and concepts, some of *Mathematica basic* is provided.

  Open `MathematicaBasic.pdf` (or `MathematicaBasic.txt`) and execute the lines one-by-one.
  Try to understand what is being done, and prepare your questions if you have.]

---
name: install_feyn

### 2. Installation : FA+FC+LT and FR

* Requires:
  - Mathematica
  - C compiler (clang, gcc, etc.) required by FormCalc and LoopTools
  - fortran compiler (gfortran etc.) required by LoopTools
  .note[
    For macos users it is a bit difficult to install fortran compiler.
    If you cannot install fortran compiler, you cannot use LoopTools, but even though you can do most part of the lecture materials. ]
* Download the archives from following websites:
  - FeynArts:  http://www.feynarts.de/           &nbsp; &nbsp; ([v3.9](http://www.feynarts.de/FeynArts-3.9.tar.gz))
  - FormCalc:  http://www.feynarts.de/formcalc/  &nbsp; &nbsp; ([v9.4](http://www.feynarts.de/formcalc/FormCalc-9.4.tar.gz))
  - LoopTools: http://www.feynarts.de/looptools/ &nbsp; &nbsp; ([v2.13](http://www.feynarts.de/looptools/LoopTools-2.13.tar.gz))
  - FeynRules: http://feynrules.irmp.ucl.ac.be/  &nbsp; &nbsp; ([latest](http://feynrules.irmp.ucl.ac.be/downloads/feynrules-current.tar.gz))

---
.note[
  You should be careful about which version of the packages you are using.
  In fact, FA/FC/LT's versioning scheme is `vN.N-DDMMMYY` (i.e., there are several versions for vX.X labelled by date), while it is `vN.N.N` for FR. ]
.note[
  You can install FA/FC/LT by an automatic installation script [`FeynInstall`](http://www.feynarts.de/) if you are using Mac or Cygwin.
  It is very convenient, but it might be better to install each package by hand because then you will learn what you are doing, and you will be able to install other packages by yourself.]
  
---
##### Install FeynArts

  - Unarchive the `tar.gz` file to a directory (for example, make a directory `~/codes` and put the files there):
```sh
> cd ~
> mkdir codes
> cd codes
> tar zxvf ~/Downloads/FeynArts-3.9.tar.gz
```
.note[
   If you are not familiar with the command line, you can click the `tar.gz` file to unarchive it.
   You can create a directory, e.g. `codes` on your desktop, and store all packages there.]

- Now you have `FeynArts.m` at some directory, e.g.,  in `~/codes/FeynArts-3.9`, or `~/Desktop/codes/FeynArts-3.9`.
  This is called *FeynArts path*.

---
- Now you have to tell the path to Mathematica.
  When we ask Mathematica to find a package, Mathematica searches the directories saved in the variable `$Path`.
  At first, it is something like
  ```mathematica
> $Path
```
```output
Out[]= {"/Applications/Mathematica.app/Contents/SystemFiles/Links",
            "/Users/misho/Library/Mathematica/Kernel",
            "/Users/misho/Library/Mathematica/Autoload",
            "/Users/misho/Library/Mathematica/Applications",  ...
```
  So you append *FeynArts path* to this variable. If `FeynArts.m` is found in `~/codes/FeynArts-3.9`, you will
```mathematica
> AppendTo[$Path, "~/codes/FeynArts-3.9"]
```
- Then you can load FeynArts. If successfully set up,
```mathematica
> <<FeynArts`
```
```output
FeynArts 3.9 (23 Sep 2015)
by Hagen Eck, Sepp Kueblbeck, and Thomas Hahn
```
  If it fails to find `FeynArts.m` in the directories of `$Path`, you will see
```output
Get::noopen: Cannot open FeynArts`.
```
  and you have to check again where you have put `FeynArts.m`.

---
##### Install FormCalc
First unarchive the downloaded file to some directory:
```sh
> cd ~/codes
> tar zxvf ~/Downloads/FormCalc-9.4.tar.gz
```
After that, you have to *compile* the FormCalc code, by executing `./compile` in the directory (i.e., the directory in which `FormCalc.m` locates.)
```sh
> cd FormCalc-9.4
> ./compile
```
Then you tell *FormCalc path* to Mathematica. For example, if `FormCalc.m` is located in `~/codes/FormCalc-9.4`,
```mathematica
> AppendTo[$Path, "~/codes/FormCalc-9.4"]
```
and you can load FormCalc:
```mathematica
> <<FormCalc`
```
```output
FormCalc 9.4 (7 Jun 2016)
by Thomas Hahn
```
---
If *compile* is not properly done, you will see an error message
```output
LinkOpen::linke: \!\(\*RowBox[{"\"Could not find MathLink executable\""}]\).
ReadForm::notcompiled: The ReadForm executable \!\(\*RowBox[{"\"((Your FormCalc path))/((Your OS))/
ReadForm\""}]\) could not be installed.  Did you run the compile script first?
```
If your path specification is invalid, it returns
```output
Get::noopen: Cannot open FormCalc`.
```

---
##### Install LoopTools
LoopTools needs compile, like FormCalc. You must execute `./configure` and `make` as follows:

```sh
> cd ~/codes
> tar zxvf ~/Downloads/LoopTools-2.13.tar.gz
> cd LoopTools-2.13
> ./configure
> make
```
When you `./configure`, it should display
```output
looking for make... /usr/bin/Make
looking for gcc... /usr/bin/clang
looking for g++... /usr/bin/clang++
looking for fortran... /usr/local/bin/gfortran
...
do we have MathLink... yes
creating makefile

now you must run Make
```
and then you can run `make`.

If `configure` could not find fortran compiler or Mathematica, it raises an error, and you are adviced to ask someone around you to prepare them.

---
After you `make`, you will see a directory "build", which contains an executable file `LoopTools`.
The path to this directory is your LoopTools path, which you tell to Mathematica as before.

.note[
  For example, if you extract LoopTools to `~/codes` and the file `LoopTools` locates in `~/codes/build/`, you will do
  ```mathematica
> AppendTo[$Path, "~/codes/build"]
  ```
  before you use LoopTools.]
  
You will call this file from Mathematica by
```mathematica
> Install["LoopTools"]
```
```output
Out[] = LinkObject[ ... ]
```
If your path specification is invalid or the file `LoopTools` is not there, an error is displayed:
```output
LinkOpen::linke: Could not find MathLink executable.
```

---
##### Install FeynRules
```sh
> cd ~/codes
> tar zxvf ~/Downloads/feynrules-current.tar.gz
```
In this example, the package file `FeynRules.m` is generated at `~/codes/feynrules-current`. Therefore
```mathematica
> $FeynRulesPath = "~/codes/feynrules-current"
> AppendTo[$Path, $FeynRulesPath]
> <<FeynRules`
```
```output
 - FeynRules - 
Version: 2.3.24 ( 12 August 2016).
Authors: A. Alloul, N. Christensen, C. Degrande, C. Duhr, B. Fuks

Please cite:
    - Comput.Phys.Commun.185:2250-2300,2014 (arXiv:1310.1921);
    - Comput.Phys.Commun.180:1614-1641,2009 (arXiv:0806.4194).

...
```
Note that the path should be set to `$FeynRulesPath`, in addition to being appended to `$Path`.

---
.note[
  The code instead can be written as
```mathematica
> $FeynRulesPath = "~/codes/feynrules-current"
> AppendTo[$Path, "~/codes/feynrules-current"]
> <<FeynRules`
```
  but it is redundant; we will have to modify two values when we move the FeynRules package to other directories.
  Avoiding such redundancy is called "DRY" (don't repeat yourself) principle.]

---
name: install_mg5

### 3. Installation : MadGraph_aMC@NLO

* Requires
   - Python 2.6 or 2.7
   - Fortran compiler (gfortran >= 4.6 is ok)
   - ROOT 5 or 6 (for `Delphes`)
* Download from [`https://launchpad.net/mg5amcnlo/`](https://launchpad.net/mg5amcnlo/).
---
Installation is simple: extract the file, and execute!
```sh
> tar xzvf MG5_aMC_v?????.tar.gz      # ????? should be replaced to the version number
> cd MG5_aMC_v?????
> ./bin/mg5_aMC
```
```output
************************************************************
*                                                          *
*                     W E L C O M E to                     *
*              M A D G R A P H 5 _ a M C @ N L O           *
*                                                          *
*                                                          *
*                 *                       *                *
*                   *        * *        *                  *
*                     * * * * 5 * * * *                    *
*                   *        * *        *                  *
*                 *                       *                *

...

Defined multiparticle vl = ve vm vt
Defined multiparticle vl~ = ve~ vm~ vt~
Defined multiparticle all = g u c d s u~ c~ d~ s~ a ve vm vt e- mu- ve~ vm~ vt~ e+ mu+ t b t~ b~ z w+
  h w- ta- ta+
MG5_aMC>
```
Now you are in madgraph interface (with a prompt `MG5_aMC>`). You can quit from madgraph interface to the terminal by `exit` or `quit`.
```mg5
> exit
```

---
In this course we will use `pythia-pgs`, `delphes` and `MadAnalysis`, which we can install by `install` command.
`help install` gives a help of this command.
```mg5
> help install
> install MadAnalysis
> install pythia-pgs
> install delphes
```
You will check your installation is done properly in the next section.

---
name: mg5_tutorial

### 4. Built-in Tutorial of MadGraph_aMC@NLO

.quiz[
  Try to do the built-in tutorial of MadGraph_aMC@NLO.
```mg5
> tutorial
```
  Check that you have installed `MadAnalysis` properly.
  If installed, you will see `plots` output in your `Results in the sm for p p > t t~ ` page.

  Then, see the plots, and check that all the histograms are what you expect. (What properties do you expect in $t\bar t$ production at the LHC?)
]

.quiz[
  Let's check that you have installed `pythia-pgs` and `Delphes` properly.
```mg5
> generate p p > t t~
> output try_delphes
> launch --laststep=delphes
```
If they are properly installed, you will see pythia output (`LOG` and `LHE`) and delphes output (`LOG`, `LHCO`, and `rootfile`), and corresponding plots.
]

---
.exquiz[
  Try to read the output files and logs.
```sh
> gunzip unweighted_events.lhe.gz
> less unweighted_events.lhe
```
  (In `less`, you can use `f`/`b` for forward/backward navigation, and `q` to quit.)

  You can browse `.root` files using `root`.
```sh
> root
```
```output
   ------------------------------------------------------------
  | Welcome to ROOT 6.06/00                http://root.cern.ch |
  |                               (c) 1995-2014, The ROOT Team |
  | Built for macosx64                                         |
  | From tag v6-06-00, 9 December 2015                         |
  | Try '.help', '.demo', '.license', '.credits', '.quit'/'.q' |
   ------------------------------------------------------------
```
```root
> TBrowser my_browser
> .q
```
  or more directly,
  ```sh
> root -l -e "TBrowser my_browser" tag_1_delphes_events.root
```
]

---
.note[

The most important principle in automated calculation or simulation is that **you should always be ready to reproduce your data used in your paper.**
Primarily "data" means figures and tables; figures should be created by scripts or Mathematica notebooks, not with graphic tools (Illustrator etc.).
Graphic tools should be used only to modify the axes, labels, etc. of the graphics.
Numbers in tables should also be calculated in scripts or spreadsheets (Microsoft Excel etc.) so that you can check the calculation any time.

Scripts are the "experiment notes" for theorists; in undergrad experiments we learned that we must keep eveything in the note.
Readers or referees may ask you to provide detailed information about your "experiments".
You should be ready to give them the scripts, which will tell them how you did your experiments.
Without such scripts your work will not be justified.
]

---
name: small_quizzes

### 5. Small Quizzes
.quiz[
  (For Lecture A-2)
  You know the Standard Model, so you can read the Standard Model file for FeynRules.
  Open `$FeynRulespath/Models/SM/SM.fr` and read it.
  What is written there?]
