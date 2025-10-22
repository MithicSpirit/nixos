\RequirePackage[l2tabu,orthodox]{nag}

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{homework}[Personal package for typesetting homework]

\newif\if@sparse \@sparsetrue
\DeclareOption{sparse}{\@sparsetrue}
\DeclareOption{dense}{\@sparsefalse}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\if@sparse \PassOptionsToClass{titlepage}{article} \fi

\LoadClass[11pt]{article}


\RequirePackage{lmodern}
\RequirePackage{microtype}
\RequirePackage{geometry}
\RequirePackage{titlesec}
\RequirePackage{placeins}
\RequirePackage{indentfirst}

\RequirePackage{math}

\microtypesetup{protrusion=true,expansion=false}
\geometry{paper=letterpaper,hmargin=4cm,vmargin=3cm}
\hypersetup{colorlinks=true,bookmarksnumbered}
\mathtoolsset{showonlyrefs,showmanualtags}

\if@sparse
  \newcommand{\sectionbreak}{\clearpage}
\else
  \newcommand{\sectionbreak}{\pagebreak[1]}
\fi

\renewcommand{\thesection}{\arabic{section}}
\renewcommand{\thesubsection}{\alph{subsection}}
\renewcommand{\thesubsubsection}{\roman{subsubsection}}

\titleformat{\section}[hang]{\FloatBarrier\normalfont\large\bfseries}%
{\thetitle.}{1em}{}

\titleformat{\subsection}[runin]{\FloatBarrier\normalfont\normalsize\bfseries}%
{(\thetitle)}{0.5em}{}
\titlespacing{\subsection}{0pt}{0pt}{\parindent}

\titleformat{\subsubsection}[runin]{\FloatBarrier\normalfont\bfseries}%
{\thetitle.}{0.5em}{}
\titlespacing{\subsubsection}{0pt}{0pt}{\parindent}



\allowdisplaybreaks{}

\newcommand{\due}[3]{\year=#1 \month=#2 \day=#3 \date{Due: \today}}
