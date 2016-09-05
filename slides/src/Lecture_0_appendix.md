# Tools for BSM Physics: Appendix

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
name: organize_codes

### Appendix:<br> How should we organize the codes?

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

$FeynRulesPath = "~/codes/FeynArts";
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
