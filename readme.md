FeynLecture
===========

## Overview

An introductory tutorial of tools for high-energy physics beyond the Standard Model:

  - Lecture A: automated calculation of Feynman diagrams with [FeynArts](http://www.feynarts.de/) / [FormCalc](http://www.feynarts.de/formcalc/) / [LoopTools](http://www.feynarts.de/looptools/) / [FeynRules](http://feynrules.irmp.ucl.ac.be/)
  - Lecture B: Monte Carlo simulation of collider physics with [MadGraph5_aMC@NLO](https://launchpad.net/mg5amcnlo)

Lecture slides are available at [http://misho104.github.io/FeynLecture/](http://misho104.github.io/FeynLecture/).



## Getting Started

See [Lecture slides](http://misho104.github.io/FeynLecture/).

Lecture A uses the following tools:
* FeynArts: http://www.feynarts.de/
* FormCalc: http://www.feynarts.de/formcalc/
* LoopTools: http://www.feynarts.de/looptools/
* FeynRules: http://feynrules.irmp.ucl.ac.be/

Lecture B uses
* MadGraph5_aMC@NLO: https://launchpad.net/mg5amcnlo

This tutorial is tested under:

* Mathematica 10.3.0.0
* FeynArts 3.9 (23 Sep 2015)
* FormCalc 9.4 (7 Jun 2016)
* LoopTools v2.13 (28 Sep 2016)
* FeynRules v2.0.31 (11 Nov 2014)
* MadGraph5_aMC@NLO v2.4.3


## Further information

On this tutorial set, please feel free to contact me via GitHub or via [my website](http://en.misho-web.com/).

On the packages, see the manuals:

* FeynArts: http://www.feynarts.de/FA3Guide.pdf
* FormCalc: http://www.feynarts.de/formcalc/FC8Guide.pdf
* LoopTools: http://www.feynarts.de/looptools/LT28Guide.pdf
* FeynRules: http://feynrules.irmp.ucl.ac.be/attachment/wiki/WikiStart/Manual_a4.pdf


## File structure

 - `/docs` contains the source code of the [lecture slides](http://misho104.github.io/FeynLecture/).
 - `readme.md` is the readme.
 - `MathematicaBasic.*` are material files for [Mathematica precourse tutorial](http://misho104.github.io/FeynLecture/Lecture_0.html#mathematica_basic).
 - `Lecture1-1.nb` etc. are the lecture note of Lecture A-1 to A-3.
 - `phi4.fr` and `phi4_feynrules.wl` are a model file of φ^4 theory for FeynRules used in Lecture A-2. 


## License

Program codes are licensed under MIT license (`*.nb`, `*.fr`, `and MathematicaBasic.*`), except for
  - models/SM/*.rst, models/SM/SM.fr, which are taken from FeynRules package.

[Lecture notes](http://misho104.github.io/FeynLecture/) are licensed under a [Creative Commons Attribution-NonCommercial 4.0 International License](https://creativecommons.org/licenses/by-nc/4.0/).

Permissions beyond the scope of this license may be available; see http://www.misho-web.com/ to contact them.


## History

 - Feb 2012: Lecture A is given at [Osaka University](http://www-het.phys.sci.osaka-u.ac.jp/) based on [v20120210](https://github.com/misho104/FeynLecture/releases/tag/v20120210)
 - Oct 2016: Lecture A+B is given at [Yonsei University](https://sites.google.com/site/yonseihepcosmo/) based on [v20161011](https://github.com/misho104/FeynLecture/releases/tag/v20161011)

Python codes in the lecture slides are automatically tested by [Travis CI](https://travis-ci.org/): [![Build Status](https://travis-ci.org/misho104/FeynLecture.svg?branch=master)](https://travis-ci.org/misho104/FeynLecture)

