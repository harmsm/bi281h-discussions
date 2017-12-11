# BI281H

Visuals for class discussions from BI281H, taught at the University of Oregon
in Fall, 2017.  

## Using:

### Locally:
 + Fork the project on github and then clone it locally.
 + Make any changes you want to the files.
 + Install [grunt](https://stackoverflow.com/questions/15703598/how-to-install-grunt-and-how-to-build-script-with-it)
   in the main repo directory.
 + In the cloned directory, type `grunt serve`.  This should load `index.html`
   in your default browser.

### On github:
If you have a `gh-pages` branch, github will host this material directory.
 + Fork the project on github and then clone it locally.
 + Make any changes you want to the files.
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
