% This document class provides a simple memo for UDP users.
% It is based on texMemo by Rob Oakes, which is based on article.cls and inherits most of the functionality that class.
% 
% Author: Adin Ramirez

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{udpmemo}[2010/07/31 - Simple Memo Class for UDP]
\RequirePackage{palatino}

\usepackage{graphicx}

% Load the Base Class
\LoadClassWithOptions{article}

% Set the spanish system (ironically, the comments are in english, but.. who cares)
\RequirePackage{udpspanish}

% Add indent
\RequirePackage{parskip} % Adds spacing between paragraphs
\setlength{\parindent}{15pt} % Indent paragraphs

% Begin Requirements
\RequirePackage{ifthen}
\RequirePackage{etoolbox}
\RequirePackage{udp}

% Set description environment
\RequirePackage{enumitem}
%\SetLabelAlign{parright}{\parbox[t]{\labelwidth}{\raggedleft#1}}
\setlist[description]{style=multiline,topsep=10pt,leftmargin=1.8cm}

% Specialized memo Commands (To, From, Subject, Logo, Letterhead Address)
\def\@memoid{\relax}
\newcommand{\memoid}[1]{\gdef\@memoid{#1}}

\def\@memoto{\relax}
\newcommand{\memoto}[1]{\gdef\@memoto{#1}}

\def\@memofrom{\relax}
\newcommand{\memofrom}[1]{\gdef\@memofrom{#1}}

\def\@memosubject{\relax}
\newcommand{\memosubject}[1]{\gdef\@memosubject{#1}}

\def\@memodate{\relax}
\newcommand{\memodate}[1]{\gdef\@memodate{#1}}

\def\@memologo{\relax}
\newcommand{\logo}[1]{\gdef\@memologo{\protect #1}}

\def\@letterheadaddress{\relax}
\newcommand{\lhaddress}[1]{\gdef\@letterheadaddress{#1}}

\def\@memocc{\relax}
\def\@memoccsep{,}
\newcommand{\memocc}[2][,]{\gdef\@memocc{#2}\xdef\@memoccsep{#1}}

% Spaces for the signature and the cc text
\newlength{\sigspace}
\newlength{\ccspace}
\setlength{\sigspace}{3cm}
\setlength{\ccspace}{1cm}

% Custom Document Formatting
\newcommand\decorativeline[1][1pt]{
  \par\noindent%
  \rule[0.5ex]{\linewidth}{#1}\par
}

% Set the Paper Size and margins
\RequirePackage{geometry}
\geometry{margin=1.0in}

% Create the Letterhead and To/From Block

\renewcommand{\maketitle}{\makememotitle}
\newcommand\makememotitle{
  \ifthenelse{\equal{\@memologo}{\relax}}{}
  {% Create With Logo
  \begin{minipage}[t]{1\columnwidth}%
    \begin{flushright}
      \vspace{-0.6in}
      \@memologo
    \par\end{flushright}%
  \end{minipage}
  }
  {\vspace{-0.6in}\begin{center}
  \LARGE\bf
  M\textsc{emorándum\ifthenelse{\equal{\@memoid}{\relax}}{}{ \@memoid}}
  \end{center}}
  % To, From, Subject Block
  \begin{description}
    \ifthenelse{\equal{\@memoto}{\relax}}{}{\item [{Para:}] \@memoto}
    \ifthenelse{\equal{\@memofrom}{\relax}}{}{\item [{De:}] \@memofrom}
    \ifthenelse{\equal{\@memosubject}{\relax}}{}{\item [{Asunto:}] \@memosubject}
    \ifthenelse{\equal{\@memodate}{\relax}}{}{\item [{Fecha:}] \@memodate}
  \end{description}
  \decorativeline\bigskip{}
}

% set default logo
\logo{\getlogo}

% Set Carbon Copy (cc)
\newcommand{\cc}[2][,]{
  \renewcommand*{\do}[1]{\item[] ##1}
  \begingroup\edef\z{\endgroup\noexpand\DeclareListParser{\noexpand\mydocsvlist}{#1}}
  \z
  \begin{minipage}{\linewidth}
  cc:
  \begin{itemize}
  \expandafter\mydocsvlist\expandafter{#2}
  \end{itemize}
  \end{minipage}
}

\newcommand{\signature}[1]{%
  \def\nextitem{\def\nextitem{\\}}% Separator
  \renewcommand*{\do}[1]{\nextitem##1}%
  \begin{minipage}{.4\columnwidth}%
  \begin{center}%
  \expandafter\docsvlist\expandafter{#1}%
  \end{center}%
  \end{minipage}%
}

% Set the closing, add signature and cc
\AtEndDocument{%
\ifthenelse{\equal{\@memofrom}{\relax }}{}{~\\\vskip\sigspace\hspace{0.5\textwidth}\signature{\@memofrom}}%
\ifthenelse{\equal{\@memocc}{\relax }}{}{~\\[\ccspace]\footnotesize\cc[\@memoccsep]{\@memocc}}%
}

% Other commands
\RequirePackage{xspace}
\DeclareRobustCommand\onedot{\futurelet\@let@token\@onedot}
\newcommand\@onedot{\ifx\@let@token.\else.\null\fi\xspace}

% Style of page without numbers
\pagestyle{empty}