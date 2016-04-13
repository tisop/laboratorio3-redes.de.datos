% udpsyllabus.cls
% Syllabus for the UDP courses
% Adin Ramirez adin.ramirez (at) mail.udp.cl
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{udpsyllabus} [2013/10/30 v0.01 Syllabus of the UDP]


% --- Class structure: declaration of options part
% ---
% This class extends the udparticle class
% Read all the documentclass options; pass them to article,
% unless the file "<currentoption>.udp" exists, then it is loaded
\DeclareOption*{\InputIfFileExists{\CurrentOption.udp}{}{
%
\PassOptionsToClass{\CurrentOption}{udparticle}}}
% --- Class structure: execution of options part
% ---
\ProcessOptions \relax
% --- Class structure: declaration of options part
% ---
\LoadClass{udparticle}

% This style defines macros that facilitate the creation of syllabus
% my holders
\newcommand{\classname}[1]{\def\@classname{#1}}
\newcommand{\subtitle}[1]{\def\@subtitle{#1}}

\newcommand{\code}[1]{\def\@code{#1}}
\newcommand{\credits}[1]{\def\@credits{#1}}
\newcommand{\duration}[1]{\def\@duration{#1}}
\newcommand{\semester}[1]{\def\@semester{#1}}
\newcommand{\requirements}[1]{\def\@requirements{#1}}
\newcommand{\sessions}[1]{\def\@sessions{#1}}

% class id
\newcommand{\makecourseid}{%
  \begin{tabular}{p{0.3\textwidth}@{}p{0.65\textwidth}}
  Código: & \@code\\
  Créditos: & \@credits\\
  Duración: & \@duration\\
  Ubicación en plan de estudio: & \@semester\\
  Requisitos: & \@requirements\\
  Sesiones semanales: & \@sessions
  \end{tabular}
}

% contents
% the \ifstrempty checks whether the argument (string) is empty (it is from the etoolbox declared in udparticle)
\newcommand{\content}[2]{
  \item \ifstrempty{#2}{\textbf{#1}}{\textbf{#1}: #2}%
}

% Default values
\subtitle{\large PROGRAMA DE ASIGNATURA}
\title{\@classname\ifdefempty{\@subtitle}{}{\\{\@subtitle}}}
\author{%
  Facultad de Ingeniería\\
  Escuela de Informática y Telecomunicaciones
}
\date{}

\setlogo{EITFI}

\code{}
\credits{}
\duration{}
\semester{}
\requirements{}
\sessions{}