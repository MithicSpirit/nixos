\RequirePackage[l2tabu,orthodox]{nag}

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{writeup}[Personal package for larger writeups]

\LoadClass[11pt]{article}

\RequirePackage{lmodern}
\RequirePackage{microtype}
\RequirePackage{geometry}
\RequirePackage{titlesec}
\RequirePackage{float}
\RequirePackage{minted}
\RequirePackage{biblatex}

\RequirePackage{math}

\microtypesetup{protrusion=true,expansion=false}
\geometry{paper=letterpaper,hmargin=4cm,vmargin=3cm}

\newcommand{\sectionbreak}{}

\newcommand{\maketoc}{\tableofcontents\clearpage%
  \@ifstar{\renewcommand\sectionbreak{\clearpage}}{}}
\newcommand{\makeappendix}{\clearpage\appendix%
  \@ifstar{}{\renewcommand\sectionbreak{\clearpage}}}
\newcommand{\makebib}{\clearpage\printbibliography[heading=bibintoc]%
  \@ifstar{}{\makeappendix}}

\mathtoolsset{showonlyrefs,showmanualtags}

\pgfplotsset{enlargelimits=true}

\setminted{breaklines=true,linenos=true}
