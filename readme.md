FeynLecture
===========

### Overview

An introductory tutorial of [FeynArts](http://www.feynarts.de/) and [FormCalc](http://www.feynarts.de/formcalc/) (and, to some extent, [LoopTools](http://www.feynarts.de/looptools/) and [FeynRules](http://feynrules.irmp.ucl.ac.be/)).

This material was originally prepared for an informal lecture I gave in February 2012 at [Osaka University](http://www-het.phys.sci.osaka-u.ac.jp/).

### Introduction

This lecture included the following topics:

* Automated generation of Feynman diagrams with Mathematica / FeynArts.
* Automated calculation of the scattering amplitude for the diagrams with Mathematica / FormCalc, LoopTools.
* Implementing your own model with Mathematica / FeynRules (and automated calculation with the model).


### Getting Started

#### Download Packages

You at least need FeynArts and FormCalc:

* FeynArts: http://www.feynarts.de/
* FormCalc: http://www.feynarts.de/formcalc/

Later you might need the following packages:

* LoopTools: http://www.feynarts.de/looptools/
* FeynRules: http://feynrules.irmp.ucl.ac.be/

This tutorial is tested under:

* Mathematica 10.0.2 + MacOS 10.9.5
* FeynArts v3.9 (15 Jan 2015)
* FormCalc v8.4 (27 Nov 2014)
* FeynRules v2.0.31 (11 Nov 2014)
* LoopTools v2.12 (3 Sep 2014)


#### Load the packages

If your Mathematica holds the directory of FeynArts/FormCalc in the variable `$Path`, you can load those by


```Mathematica
<<FeynArts`
<<FormCalc`
```

Therefore, first you have to tell the location of your packages to Mathematica by `AppendTo[$Path, /the/directory/of/the/packages]`.

You can invoke this command in your notebook and evaluate every time, but if you are lazy, you can add these `AppendTo` commands into the "initialization file" found in `$HOME/.Mathematica/Kernel/init.m` or  `$HOME/Library/Mathematica/Kernel/init.m`, etc., depending on the platform.

##### A tip for very lazy guys

I am actually a very lazy person. So I install all the packages I use in `$HOME/Documents/Mathematica/lib/`, and wrote the following command in `init.m`; this command adds all the directories `$HOME/Documents/Mathematica/lib/*` into `$Path`.


```Mathematica
Global`$LibDirectory=FileNameJoin[{$HomeDirectory, "Documents", "Mathematica", "lib"}]
AppendTo[$Path, Global`$LibDirectory];
$Path = Join[$Path, Select[FileNames["*", Global`$LibDirectory], FileType[#] == Directory &]];
```

### Further information

On this tutorial set, please feel free to contact me via GitHub or via [my website](http://en.misho-web.com/).

On the packages, see the manuals:

* FeynArts: http://www.feynarts.de/FA3Guide.pdf
* FormCalc: http://www.feynarts.de/formcalc/FC8Guide.pdf
* LoopTools: http://www.feynarts.de/looptools/LT28Guide.pdf
* FeynRules: http://feynrules.irmp.ucl.ac.be/attachment/wiki/WikiStart/Manual_a4.pdf

### Lisense

Program codes are licensed under MIT license (`*.nb`, `*.fr`, `and MathematicaBasic.*`), except for
  - models/SM/*.rst, models/SM/SM.fr, which are taken from FeynRules package.

Lecture notes are licensed under a Creative Commons Attribution-NonCommercial 4.0 International License.

Permissions beyond the scope of this license may be available; see http://www.misho-web.com/ to contact them.

