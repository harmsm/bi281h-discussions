# BI281H: Biochemistry and Cellular Physiology

Visuals for class discussions from BI281H, taught at the University of Oregon
in Fall, 2017. 

## Course objectives 

 + Survey the key molecular and cellular features shared by all organisms on
   earth, revealing how life can be understood in physical and chemical terms.
 + Begin to develop intuition and analytical tools to think about life
   quantitatively and molecularly.
 + Introduce several key, universal systems that are shared across organisms:
    + Serine protease
    + Hemoglobin
    + Glycolysis/gluconeogenesis
    + Citric Acid Cycle
    + Electron transport chain
    + ATP synthase

## How to use this repo:

### View currently hosted material:

[View visuals](https://harmsm.github.io/bi281h-discussions/)

### Download and host locally:
 + Fork the project on github and then clone it locally.
 + Run `install-grunt.sh` in the man directory.  Hit `Enter` at all prompts. 
   This will install grunt dependencies in the directory. I have tested this on
   an Ubuntu machine. You might have to tweak npm install for your environment.
 + In the cloned directory, type `grunt serve`.  This should load `index.html`
   in your default browser.

### Download and host on github:
If you have a `gh-pages` branch, github will host this material directory.
 + Fork the project on github and then clone it locally.
 + Push changes to the `gh-pages` branch: `git push origin gh-pages`
 + Access via `https://harmsm.github.com/bi281h-discussions`, replacing `harmsm`
   with your own user name.

## Organization:
The base directory has `discussion_xx.html` that are (basically) a slideshow 
for that class session.  The material that goes into that discussion -- images,
videos, etc. -- are all in the `presentation-data/xx/` directory for that 
discussion.

## License:
Course material is made available under the [unlicense](unlicense.org). I have 
attempted to credit all source material I used to construct the visuals where
appropriate. Reveal.js presentation technology is released under their own
license (see LICENSE_reveal.js).

## Notes:
This is built on the reveal.js platform (check it out!):
https://github.com/hakimel/reveal.js/
