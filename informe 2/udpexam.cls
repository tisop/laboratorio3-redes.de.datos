% udpexam.cls
% Exam for the UDP courses
% Adin Ramirez adin.ramirez (at) mail.udp.cl
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{udpexam} [2013/11/18 v0.01 Exam for the UDP]


% --- Class structure: declaration of options part
% ---
% This class extends the udparticle class
% Read all the documentclass options; pass them to article,
% unless the file "<currentoption>.udp" exists, then it is loaded
\DeclareOption*{\InputIfFileExists{\CurrentOption.udp}{}{
%
\PassOptionsToClass{\CurrentOption}{udpexam}}}
% --- Class structure: execution of options part
% ---
\ProcessOptions \relax
% --- Class structure: declaration of options part
% ---
\LoadClass{exam}

\RequirePackage{calc}

% UDP logos and other internal stuff
\RequirePackage{udp}

% Set the spanish system (ironically, the comments are in english, but.. who cares)
\RequirePackage{udpspanish}

% Holders for info
% course codes
\def\@coursecode{}
\newcommand{\coursecode}[1]{\def\@coursecode{#1}}
% professors/instructors
\def\@instructors{}
\newcommand{\instructors}[1]{\def\@instructors{#1}}
\def\@instructor{}
\newcommand{\instructor}[1]{\def\@instructor{#1}}
% name of the course
\def\@title{}
\renewcommand{\title}[1]{\def\@title{#1}}

\def\@nametext{}
\newcommand{\nametext}[1]{\def\@nametext{#1}}
\nametext{Nombre:}

\def\@idtext{}
\newcommand{\idtext}[1]{\def\@idtext{#1}}
\idtext{RUT:}

\def\@sectiontext{}
\newcommand{\sectiontext}[1]{\def\@sectiontext{#1}}
\sectiontext{Sección:}

\newif\ifsectiontext
\sectiontextfalse

% % Style
\pagestyle{headandfoot}
\header{\@logo}{\vfil\@title\vfil}{\vfil\@coursecode\vfil}
\footer{%
  \ifdefempty{\@instructors}{%
    \ifdefempty{\@instructor}{}{%
      Profesor: \@instructor%
    }%
  }{%
    Profesores: \@instructors%
  }%
}{}{\thepage/\numpages}

% Name and section commands
\RequirePackage{xparse}
\newcommand{\name}[1][\textwidth]{\hbox to #1{Nombre:\enspace\hrulefill}\vspace{0.2 in}}

% Uses three optional arguments to define the size of name, id, and section
\DeclareDocumentCommand{\makename}{O{0.5\textwidth} O{0.24\textwidth} O{0.24\textwidth}}{%
\hbox{%
\ifsectiontext%
  \hbox to #1{\@nametext\enspace\hrulefill}
  \hbox to #2{\@idtext\enspace\hrulefill}\vspace{0.2 in}
  \hbox to #3{\@sectiontext\enspace\hrulefill}\vspace{0.2 in}
\else%
  \newlength\len%
  \setlength{\len}{#1+#3}%
  \hbox to \len{\@nametext\enspace\hrulefill} 
  \hbox to #2{\@idtext\enspace\hrulefill}\vspace{0.2 in}
\fi%
}%
}

% Re-define the title
\def\maketitle{%
  \header{\@logo}{}{}
  \newpage
%  \vspace*{-\topskip}      % remove the initial space
  \begingroup\centering    % instead of \begin{center}
  \let \footnote \thanks
  \hrule height \z@        % to avoid the insertion of lineskip glue
    {\LARGE \@title \par}%
    \vskip 1.5em 
    {\large
      \lineskip .5em 
      \begin{tabular}[t]{c}%
        \@author
      \end{tabular}\par}%
%    \vskip 1em 
%    {\large \@date}%
  \par\endgroup            % instead of \end{center}
  \vskip 1.5em             % <--- modify this to adjust the separation
}


% redefinition of the keywords
\pointpoints{punto}{puntos}
\renewcommand{\solutiontitle}{\noindent\textbf{Solución:}\enspace}

% droppoints
\totalformat{Total para Pregunta~\thequestion: (\totalpoints)}

% grade table
\vqword{Pregunta}
\vpgword{Página}
\vpword{Puntos}
\vsword{Nota}

\hqword{Pregunta}
\hpgword{Página}
\hpword{Puntos}
\hsword{Nota}

\RequirePackage{listings}
\RequirePackage{bold-extra}%enabled ttfamily bold fonts 

\lstset{
basicstyle=\ttfamily,
inputencoding=utf8,
extendedchars=true,
frameround=tttt,
basicstyle=\small\ttfamily,
keywordstyle=\bfseries,
showstringspaces=false,
frame=single,
breaklines=true,
postbreak=\raisebox{0ex}[0ex][0ex]{\ensuremath{\color{red}\hookrightarrow\space}},
literate=%
    {á}{{\'{a}}}1
    {é}{{\'{e}}}1
    {í}{{\'{i}}}1
    {ó}{{\'{o}}}1
    {ú}{{\'{u}}}1
    {ñ}{{\~{n}}}1
    {Ñ}{{\~{N}}}1
}
