\def\fileversion{1.0}
\def\filedate{2014/05/02}

\typeout{Package: `udpamc (udp automultiplechoice)' \fileversion\space <\filedate>}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{udpamc}[\filedate\space\fileversion]

\RequirePackage{pgfkeys}
\RequirePackage{pgfopts}
\RequirePackage{etoolbox}
% Package options
\def\article@classoptions{letter}% list all options that should be passed to article here
\def\amc@packageoptions{box, lang=ES}% list all default options passed to amc

\newif\ifudpamc@circle%
\pgfkeys{%
  /udpamc/.cd,
  circle/.is if={udpamc@circle},
  circle/.default=true,
  article/.code={\edef\article@classoptions{\article@classoptions,#1}},
  % unknown keys are assumed to be options to be passed to the amc package
  .unknown/.code={\edef\amc@packageoptions{\amc@packageoptions,\pgfkeyscurrentname=#1}},
}

% defaults
\pgfkeys{%
  /udpamc/.cd,
  circle,
}

% process options key-value
\ProcessPgfOptions{/udpamc}
% process options code
\ifudpamc@circle%
  \gdef\udpamc@opt{\AMCboxDimensions{shape=oval,width=2.5ex,height=2.5ex}}%
\else%
  \gdef\udpamc@opt{}%
\fi%

\LoadClass[\article@classoptions]{article}
\RequirePackage[\amc@packageoptions]{automultiplechoice}
\RequirePackage{tikz}
% load my options
\AtBeginDocument{\udpamc@opt}


% for patching
\RequirePackage{etoolbox}
\RequirePackage{regexpatch}

% for logos
\RequirePackage{udp}
\setlogo{EITFI}

% Set the spanish system (ironically, the comments are in english, but.. who cares)
\RequirePackage{udpspanish}

% for using square and blacksquare in instructions
\RequirePackage{amssymb}

% My variables for holding information
\def\@instructions{}
\newcommand{\instructions}[1]{\def\@instructions{#1}}

\def\@rightheader{}
\def\@leftheader{}
\newcommand{\rightheader}[1]{\def\@rightheader{#1}}
\newcommand{\leftheader}[1]{\def\@leftheader{#1}}

% depracated (message)
\newcommand{\coursecode}[1]{\PackageWarning{udpamc}{\noexpand\coursecode is deprecated, prefer \noexpand\leftheader or \noexpand\rightheader commands}\def\@rightheader{#1}}
\newcommand{\testname}[1]{\PackageWarning{udpamc}{\\testname is deprecated, prefer \\leftheader or \\rightheader commands}\def\@leftheader{#1}}

% patch the definition of NAC in the spanish toolbox
\AMCtext{none}{Ninguna de estas respuestas es correcta.}
\AMCtext{explain}{\textit{\textbf{Explicación: }}}
\def\nac{\AMC@loc@none}

% patch the question beginning (question sheet)
\def\AMCbeginQuestion#1#2{\vspace{\AMCformVSpace}\par\noindent{\bf #1.} #2}
% patch the question beginning (form answer)
\def\AMCformQuestion#1{\vspace{\AMCformVSpace}\par{\bf Pregunta \makebox[1.5em][l]{#1:}}}
% patch the space before every question
\def\AMCbeforeQuestion{\vspace{\AMCformVSpace}\par}
% patch indent on the elements
\patchcmd{\element}{{#2}}{{\par#2}}{}{}

% patch space
\AMCinterBquest=1.5ex
% patch AMCOpen white space after
\renewcommand\AMCopenShow[4]{
  \ifAMC@ensemble\def\AMCid@name{#3}\AMCid@quest=#4\fi%
  \ifAMC@ensemble\ifAMCformulaire@dedans%
    \AMC@amclog{AUTOQCM[Q=\the\AMCid@quest]^^J}%
  \fi\fi%
  {\setkeys{AMCOpen}{#1}%
    \ifKV@AMCOpen@lineup%
      \ifAMC@ensemble\else\par\fi%
      \ifAMC@correc\smash{\AMCopen@answer}\fi\dotfill%
    \else%
      \hspace*{.5em}\linebreak[1]\hspace*{\fill}%
    \fi%
    {\AMCnoCompleteMulti%
      \def\AMCbeginAnswer{}\def\AMCendAnswer{}%
      \def\AMCanswer##1##2{\ifAMC@ensemble ##1\else%
          \ifAMC@inside@box ##1\else{\AMCboxOutsideLetter{##1}{##2}}\fi\fi%
        \hspace{\AMCopen@Hspace}}%
      \fboxsep=\AMCopen@boxmargin%
      \fboxrule=\AMCopen@boxframerule%
      \fcolorbox{\AMCocol@BoxFrameRule}{\AMCocol@Background}{%
        \ifAMC@ensemble\AMCopen@question%
          \ifx\@empty\AMCopen@question\@empty\else\hspace{\AMCopen@Hspace}\fi%
        \fi%
        \begin{choicescustom}[o]%
          \ifx\AMCocol@Foreground\@empty\@empty\else%
            \def\AMC@boxcolor{\AMCocol@Foreground}%
          \fi%
          #2%
          \ifKV@AMCOpen@scan\else\AMCdontScan\fi%
          \ifKV@AMCOpen@annotate\else\AMCdontAnnotate\fi%
        \end{choicescustom}%
        \ifx\@empty\AMCotextReserved\@empty%
          \hspace{-\AMCopen@Hspace}%
        \else%
          \ifx\AMCocol@Foreground\@empty\@empty%
            \AMCotextReserved%
          \else%
            \textcolor{\AMCocol@Foreground}{\AMCotextReserved}%
          \fi%
        \fi%
      }}%
    \ifKV@AMCOpen@lineup\else%
      \par\nobreak\noindent%
      \hspace*{\fill}{%
        \fboxrule=\AMCopen@framerule%
        \fcolorbox{\AMCocol@FrameRule}{white}{%
          \csname\AMCopen@contentcommand\endcsname
        }}%
      \vspace{0mm}\par%
    \fi%
  }%
  \ifAMC@ensemble\ifAMCformulaire@dedans%
  \AMC@amclog{AUTOQCM[FQ]^^J}%
  \fi\fi%
}

% creates the header for the automultichoice
\newcommand{\makename}{%
  \fancyhead[C]{\begin{minipage}{0.3\textwidth}\getlogo\end{minipage}\hspace{0.2\textwidth} \begin{minipage}{0.3\textwidth}\AMCIDBoxesABC\end{minipage}}%
  % código del curso
  \def\@test@{\@rightheader\@leftheader}
  \def\@myhead{%
  \ifdefempty{\@test@}{}{% at least one is not empty
    \noindent{\bf \@leftheader \hfill \@rightheader}%
  }
  \vspace{10pt}\\%<- this enter is needed
  \ifdefempty{\@instructions}{}{\noindent\textbf{Instrucciones.} \@instructions}
  \vspace{10pt}\\%<- this enter is needed
  % Identification
  % Sets the new aspect for the students code 
  \let\oldAMChspace\AMCcodeHspace
  \let\oldAMCvspace\AMCcodeVspace
  \AMCcodeHspace=.2em
  \AMCcodeVspace=.2em
  {\setlength{\parindent}{0pt}\hspace*{\fill}\AMCcode{rut}{8}\hspace*{\fill}
  % Restate the old values
  \AMCcodeHspace=\oldAMChspace
  \AMCcodeVspace=\oldAMCvspace
  \begin{minipage}[b]{6.5cm}
  $\longleftarrow{}$ Marque su RUT sin d\'igito verificador (el n\'umero despu\'es del gui\'on), y escriba sus nombres y apellidos abajo.
  \vspace{3ex}%
  \hfill\namefield{\fbox{ % leave one space
      \begin{minipage}{.9\linewidth}
        Nombre(s) y apellido(s):\\\\
        \vspace*{.5cm}\dotfill\\
        \vspace*{.5cm}\dotfill
        \vspace*{1mm}
      \end{minipage}
    }}\hfill\vspace{1ex}\end{minipage}\hspace*{\fill}%
  }%
  \vspace{10pt}}%
  % setup depending number of columns
  \if@twocolumn%
    \twocolumn[\@myhead]%
  \else%
    \@myhead%
  \fi%
}

% Header with instructions alone
\newcommand{\makeinstructions}{%
  \fancyhead[C]{\begin{minipage}{0.3\textwidth}\getlogo\end{minipage}\hspace{0.2\textwidth} \begin{minipage}{0.3\textwidth}\AMCIDBoxesABC\end{minipage}}%
  % código del curso
  \def\@test@{\@rightheader\@leftheader}
  \def\@myhead{%
  \ifdefempty{\@test@}{}{% at least one is not empty
    \noindent{\bf \@leftheader \hfill \@rightheader}%
  }
  \vspace{10pt}\\%<- this enter is needed
  \ifdefempty{\@instructions}{}{\noindent\textbf{Instrucciones.} \@instructions}
  \vspace{10pt}\\}%<- this enter is needed
  % setup depending number of columns
  \if@twocolumn%
    \twocolumn[\@myhead]%
  \else%
    \@myhead%
  \fi%
}

% patch the onecopy to reset automatically figures and tables
\let\oldonecopy\onecopy
\renewcommand{\onecopy}[2]{\oldonecopy{#1}{%
  % reset
  \setcounter{figure}{0}%
  \setcounter{table}{0}%
  % content
  #2%
}}

% patch for two column answers
% patch multicol answers
\RequirePackage{multicol}
\def\twocolanswers{%
  \BeforeBeginEnvironment{choices}{\setlength{\multicolsep}{3pt}\begin{multicols}{2}\AMCBoxedAnswers}%
  \AfterEndEnvironment{choices}{\end{multicols}}%
}

% patch ~ in AMC, so when using spanish it doesn't break
\patchcmd{\AMCopen@lines}{~ }%<- this space is needed
{\hspace*{0pt}}
{}{}

% macro to draw marks in instructions
\newcommand{\@AMC@answer@box}[4]{%
\ifcsname AMC@answerBox@\endcsname% manage new version
    \AMC@answerBox@{#1}{#2}{#3}{#4}%
  \else% manage old version
    \AMC@boxedchar{#1}{#4}{#3}{#2}%
  \fi%
}
\newcommand{\emptybox}{\raisebox{-.2ex}{\@AMC@answer@box{}{}{}{}}}
\newcommand{\fillbox}{\raisebox{-.2ex}{\@AMC@answer@box{}{1}{}{}}}

% macro for changing form on solutions
\let\ifsolutions\ifAMC@correchead

% patch AMCOpen to hide boxes on solutions
\let\oldAMCopenShow\AMCopenShow
\renewcommand{\AMCopenShow}[4]{%
\ifsolutions%
  \oldAMCopenShow{#1, lines=0,lineheight=0pt,dots=false,framerulecol=white}{#2}{#3}{#4}%
\else%
  \oldAMCopenShow{#1}{#2}{#3}{#4}%
\fi%
}

% Add functionality to hold boxes
% http://tex.stackexchange.com/q/195005/7561
% Mi código para generar cajas para código automaticamente
\newcounter{myboxcounter}
\setcounter{myboxcounter}{0}
\newenvironment{specialbox}[1][]{%
  \ifstrempty{#1}{%
    \addtocounter{myboxcounter}{1}%
    \expandafter\newsavebox\csname foobox\roman{myboxcounter}\endcsname%
    \global\expandafter\setbox\csname foobox\roman{myboxcounter}\endcsname\hbox\bgroup\color@setgroup\ignorespaces%
  }{%
    \expandafter\newsavebox\csname foobox#1\endcsname%
    \global\expandafter\setbox\csname foobox#1\endcsname\hbox\bgroup\color@setgroup\ignorespaces%
  }
}{%
  \color@endgroup\egroup
}

\newcommand{\insertbox}[1][]{%\stepcounter{myboxcounter}%
  \ifstrempty{#1}%
  {\expandafter\usebox\csname foobox\roman{myboxcounter}\endcsname}%
  {\expandafter\usebox\csname foobox#1\endcsname}%
}

% Add functionality for group of questions
\newcommand{\groupopen}{$\triangleright$}
\newcommand{\groupclose}{$\triangleleft$}
\newcommand{\groupelement}[2]{%
\element{#1}{%
\noindent\groupopen\hspace{.8ex}
#2 %<- the enter is needed (i.e., the space) in order to force a new line
\groupclose}}

% Table question
\newdimen\@AMCtableL
\newdimen\@AMCtableTextL
\newdimen\@AMCtableC
\newdimen\@AMCtableCh
\newcount\@AMCtableI
\newcount\@AMCtableColNum
\newcount\@AMColdCount
% whether each answer should have more than one correct answer
\newbool{@AMCusemultianswer}% \newif\if@AMCusemultianswer equivalent
% whether we should use the number of options given as answers to convert the question to multiple answer one
\newbool{@AMCuseoptionsnumbers}% \newif\if@AMCuseoptionsnumber equivalent
\newbool{@multiques}
\newbool{@multioptions}

\def\headerLeft{}
\def\headerChoices{}
\newcommand\@makeheader[2]{\par\noindent\begin{minipage}{\@AMCtableL}\colorbox{white}{#1#2}\end{minipage}\par}
\def\makeheader{\@makeheader{\headerLeft}{\headerChoices}}

\pgfkeys{%
  table width/.default=\linewidth,
  table width/.code={\@AMCtableL=#1},
  left text width/.code={\@AMCtableTextL=#1},
  left text width/.default=-1000pt,
  set text width/.code={\ifdim\@AMCtableTextL=-1000pt \@AMCtableTextL=\dimexpr\@AMCtableL-\@AMCtableColNum\@AMCtableC\relax\fi},
  num columns/.default=1,
  num columns/.code={\@AMCtableColNum #1\relax},
  column width/.default=1cm,
  column width/.code={\@AMCtableC=#1},
  column height/.default=1.1em,
  column height/.code={\@AMCtableCh=#1},
  % header of table
  table header/.code={\global\def\headerChoices{#1}},
  table header/.default=,
  table header left text/.code={\global\def\headerLeft{#1}},
  table header left text={\AMCtableLeft{\hfil}},
  score/.default=1,
  score/.store in=\@AMCrowChoiceScore,
  use multi answer/.default=true,
  use multi answer/.is if=@AMCusemultianswer,
  use options number/.default=true,
  use options number/.is if=@AMCuseoptionsnumbers,
}

\newif\if@added
% #1 pgfkeys options (optional)
% #2 range of options to turn on
% #3 max number of options to create
\newcommand{\@AMCrowchoices}[3][]{%
  \pgfkeys{#1}%
  \def\@@tmp{}%
  \foreach \i in {0,...,\numexpr#3-1\relax}{%
    \global\@addedfalse%
    \foreach \j in #2{%
      \ifnum\i=\j%
        % using \n from onerow macro
        \xappto\@@tmp{\noexpand\correctchoice{\i}\if@multiques\noexpand\scoring{b=\@AMCrowChoiceScore,m=0}\fi}%
        \global\@addedtrue%
      \fi%
    }%
    \if@added\else%
       \xappto\@@tmp{\noexpand\wrongchoice{\i}\if@multiques\noexpand\scoring{m=0,b=0}\fi}%
    \fi%
  }%
\@@tmp%
}

\newenvironment{tablequestion}[1][]{%
  \pgfkeys{table width, num columns, column width, column height, score, left text width, use options number, #1, set text width}
  \let\oldAMCbeginAnswer\AMCbeginAnswer%
  \def\AMCbeginAnswer{}%
  \let\oldAMCendAnswer\AMCendAnswer%
  \def\AMCendAnswer{}%
  \let\oldAMCanswer\AMCanswer%
  \def\AMCanswer##1##2{\AMCtableCol{##1}}%
  \let\oldAMCbeginQuestion\AMCbeginQuestion%
  
  \@AMColdCount=\theAMCquestionaff\relax%
  \def\AMCbeginQuestion##1##2{\par\noindent}%
  \global\@AMCtableI=0%
}{%
  \let\AMCbeginAnswer\oldAMCbeginAnswer%
  \let\AMCendAnswer\oldAMCendAnswer%
  \let\AMCanswer\oldAMCanswer%
  \let\AMCbeginQuestion\oldAMCbeginQuestion%
  \setcounter{AMCquestionaff}{\@AMColdCount}%
}

\newcommand{\AMCtableLeft}[1]{\begin{minipage}{\@AMCtableTextL}#1\end{minipage}}
\newcommand{\AMCtableCol}[1]{\begin{minipage}{\@AMCtableC}\centering\scriptsize #1\end{minipage}}

\newcommand{\multiitem}[4][]{%
  \pgfkeys{#1}%
  \global\advance\@AMCtableI by 1%
  \ifodd\@AMCtableI%
    \global\def\AMCtableColor{gray!25}%
  \else%
    \global\def\AMCtableColor{white}%
  \fi%
  \par\noindent\begin{minipage}{\@AMCtableL}\colorbox{\AMCtableColor}{%
    \foreach \i [count=\n] in #4{}%
    \ifnum\n>1 \booltrue{@multioptions}\else\boolfalse{@multioptions}\fi%
    \ifboolexpr{bool{@AMCusemultianswer} and ( not bool{@AMCuseoptionsnumbers} or bool{@multioptions} )}{\booltrue{@multiques}}{\boolfalse{@multiques}}%
    \def\content{%
      \AMCtableLeft{#3}%
      \begin{choicescustom}[o]
        \scoring{%
          v=0,% v: non answers (blank), e: incoherent (many checked)
          \if@multiques b=0\else b=\@AMCrowChoiceScore, e=0, m=0\fi%
        }%
        \@AMCrowchoices[#1]{#4}{\@AMCtableColNum}%
      \end{choicescustom}%
    }%
    \ifbool{@multiques}{%
       \begin{questionmult}{#2}\content\end{questionmult}%
    }{%
      \begin{question}{#2}\content\end{question}%
    }%
  }%
  \end{minipage}
}
