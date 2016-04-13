% This file provides a simple interface to create surveys using a table-like look
% and feel to the questions.
%
% It relies on the AMC package to work
%
% Bugs and reports to: Adin Ramirez (adin.ramirez@mail.udp.cl)
\def\fileversion{1.2}
\def\filedate{2015/12/06}

\typeout{Package: `udpsurvey (udp for surveys)' \fileversion\space <\filedate>}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{udpsurvey}[\filedate\space\fileversion]

\RequirePackage{pgfkeys}
\RequirePackage{pgfopts}

\def\udpamc@classoptions{noshuffle, circle}
\pgfkeys{%
  /udpsurvey/.cd,
  % unknown keys are assumed to be options to be passed to the amc package
  .unknown/.code={\edef\udpamc@classoptions{\udpamc@classoptions,\pgfkeyscurrentname=#1}},
}

% defaults
\pgfkeys{%
  /udpsurvey/.cd,
}

% process options key-value
\ProcessPgfOptions{/udpsurvey}

\LoadClass[\udpamc@classoptions]{udpamc}


\RequirePackage{pgffor,pgfkeys}
% path the foreach to accept enters (new paragraphs)
% http://tex.stackexchange.com/a/280177/7561
\patchcmd[\long]{\pgffor@normal@list}{}{}{}{}
\patchcmd[\long]{\pgffor@scanone}{}{}{}{}
\patchcmd[\long]{\pgffor@dots@in@}{}{}{}{}

% to add the hook for other pages
\usepackage{atbegshi}

\newcommand{\AMCtableHeader}[1][]{%
%  \show\headerChoices
  \@makeheader{\AMCtableLeft{#1\hfill}}{\headerChoices}%
}

% 'if' to control Shipout only when in table
\newif\ifoutoftable
\outoftabletrue

% add the header to every next page
\newcommand{\printHeader}{\makeheader}

\AtBeginShipout{\ifoutoftable\else\printHeader\fi}

% patch onecopy to discard extra pages produced by AtBeginShipout
\let\wrongonecopy\onecopy
\renewcommand{\onecopy}[2]{\wrongonecopy{#1}{#2}\AtBeginShipout\AtBeginShipoutDiscard}

%% Definitions for table
\newif\iffirstheader

% Keys for the question format
\pgfkeys{%
  % elements
  section/.code = {\noitem{\textbf{#1}}},
  type/.initial = multiitem,
  options/.initial =,
  question/.code 2 args = {\csname \pgfkeysvalueof{/type}\expandafter\endcsname\expandafter[\expandafter{\romannumeral-`\x\pgfkeysvalueof{/options}}]{#1}{#2}},
  text/.code = {\noitem[is text]{#1}},
  % typeset the header on demand
  header/.code = {\AMCtableHeader[#1]},
  header/.default =,
  % control the shipout style
  auto header off/.code={\global\let\printHeader\relax},
  auto header on/.code={\global\let\printHeader\makeheader},
  exec/.code={#1},
  % process the macros
  style/.estyle = {#1},
  % conditionals
  first header/.is if=firstheader,
  first header/.default=true,
  % setters for the table using survey
  first header,
  column width/.default=1.5cm,% use default because the table is set after this set of keys
}


% patch the table
\renewenvironment{tablequestion}[1][]{%
  \outoftablefalse
  \pgfkeys{table width, num columns, column width, column height, score, left text width, use options number, #1, set text width}
  \let\oldAMCbeginAnswer\AMCbeginAnswer%
  \def\AMCbeginAnswer{}%
  \let\oldAMCendAnswer\AMCendAnswer%
  \def\AMCendAnswer{}%
  \let\oldAMCanswer\AMCanswer%
  \def\AMCanswer##1##2{\AMCtableCol{##1}}%
  \let\oldAMCbeginQuestion\AMCbeginQuestion%
%  
  \@AMColdCount=\theAMCquestionaff\relax%
  \def\AMCbeginQuestion##1##2{\par\noindent}%
  \global\@AMCtableI=0%
%  
  \iffirstheader\makeheader\fi%
}{%
  \outoftabletrue
  \let\AMCbeginAnswer\oldAMCbeginAnswer%
  \let\AMCendAnswer\oldAMCendAnswer%
  \let\AMCanswer\oldAMCanswer%
  \let\AMCbeginQuestion\oldAMCbeginQuestion%
  \setcounter{AMCquestionaff}{\@AMColdCount}%
}

\renewcommand{\AMCtableLeft}[1]{\noindent\parbox{\@AMCtableTextL}{#1}}
\renewcommand{\AMCtableCol}[1]{\parbox{\@AMCtableC}{\centering\scriptsize #1}}

\renewcommand{\multiitem}[3][]{%
  \pgfkeys{#1}%
  \global\advance\@AMCtableI by 1%
  \ifodd\@AMCtableI%
    \global\def\AMCtableColor{gray!25}%
  \else%
    \global\def\AMCtableColor{white}%
  \fi%
  \par\noindent\colorbox{\AMCtableColor}{\makebox[\@AMCtableL]{%
  \def\content{%
    \AMCtableLeft{#3}%
    \begin{choicescustom}[o]\QuestionIndicative%
      \scoring{%
        auto=1, v=0, e=0% v: non answers (blank), e: incoherent (many checked)
      }%
      \@AMCrowchoices[#1]{0}{\@AMCtableColNum}%
    \end{choicescustom}%
  }%
     \begin{question}{#2}\content\end{question}%
  }%
  }%
}

\newif\ifistext
\pgfkeys{%
%/udp/.cd,
is text/.is if=istext,
is text/.default=true,
}
\newcommand{\noitem}[2][]{%
  \pgfkeys{is text=false, #1}
%  \global\advance\@AMCtableI by 1%
  \ifodd\@AMCtableI%
    \global\def\tableColor{gray!25}%
  \else%
    \global\def\tableColor{white}%
  \fi%
  \par\noindent%
%  \ifnum#1=1%
  \ifistext%
    \parbox{\linewidth}{\medskip#2}\smallskip%
  \else%
    \colorbox{black}{\parbox{\linewidth}{\smallskip\color{white}#2}}%
  \fi%
}

\newcommand{\openitem}[3][]{%
  \global\advance\@AMCtableI by 1%
  \ifodd\@AMCtableI%
    \global\def\tableColor{gray!25}%
  \else%
    \global\def\tableColor{white}%
  \fi%
  \par\noindent%
  \begin{minipage}{\linewidth}
  \colorbox{\tableColor}{%
  \begin{question}{#2}\QuestionIndicative\parbox{\linewidth}{#3}\vspace{-5pt}%
    \AMCOpen{lines=3,lineheight=.8cm,dots=false,width=.98\linewidth,boxmargin=0pt,foregroundcol=\tableColor,#1}{}%
  \end{question}%
  }%
  \end{minipage}
}

