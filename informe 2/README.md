# Introducción

Clases de LaTeX para generar artículos y programas de curso personalizados de una forma sencilla que puede incluir el logo y un encabezado de la UDP. 

Se provee de las siguientes tipos de documentos:
- Artículos (`udparticle`): Documentos generales de una o dos columnas conformados por secciones. Extiende `article` de LaTeX.
- Reportes (`udpreport`): Documentos generales conformados por capítulos. Extiende a `report` de LaTeX.
- Memo (`udpmemo`): Memos gneerales con logos institucionales, y generación de listas de copia automática.
- Exámenes (`udpexam`): Exámenes de preguntas abiertas. Permite generar paútas al escribir las respuestas dentro. Extiende a `exam` de LaTeX.
- Exámenes de opción múltiple (`udpamc`): Exámenes de opción múltiple. Permite generar preguntas de manera aleatoria, 
- Encuestas de opción múltiple (`udpsurvey`): Encuestas de opción múltiple en forma de tabla. Extiende la funcionalidad de `udpamc` para la generación de encuestas.
- Programas (`udpsyllabus`): Programas de cursos con generación de encabezados automática.

# Instalación

Los archivos de las distintas clases y estilos deben de desplegarse en un directorio que semeje su instalación de LaTeX. Por ejemplo, puede instalarlos en un directorio `~/texmf/tex/latex/udp`, donde el directorio `udp` puede tener el nombre que le parezca. Note que de no existir dicha estructura debe crearla.

# Plantillas para documentos generales

## `udparticle.cls`

La clase `udparticle.cls` es utilizada para generar artículos que incluyan el logo y formato de la UDP. La información del encabezado (título, autores, emails, etc.) se genera al inicio de la página de manera compacta, dando lugar al contenido inmediatamente.

```latex
\documentclass{udparticle}

%% Para incluir el logo puede usar una de las siguientes opciones:
%\usepackage{graphicx} % recuerde incluir este paquete para las imágenes
%% La imagen "udp-logo" debe existir en el folder
%\logo{\includegraphics[width=\linewidth]{udp-logo}}
%% De igual forma puede utilizar los logos embebidos en la plantilla
%\setlogo{EITFI}
%\setlogo{EIT}

\setlogo{EITFI}

% Define el encabezado en páginas siguientes y debajo del logo
\headertext{Coordinación de Práctica y Titulación}

% Define el título y el autor
\title{Título}
\author{Alguién}

\begin{document}
% Esto imprime el título y el logo
\maketitle
\end{document}
```

## `udpreport.cls`

La clase `udpreport.cls` es utilizada para generar documentos con mayor contenido que un artículo. Ésta permite el uso de capítulos, secciones, y subsecciones. Además, genera autmáticamente una portada (de una página).

```latex
\documentclass{udpreport}

% Podemos establecer el logo de alguna entidad o dejar el de la UDP (defecto)
%\setlogo{EITFI}

\title{Título del reporte}
\author{Alguién}
\email{alguien@mail.udp.cl}
\date{1 de diciembre de 1914}

% Además podemos establecer la facultad y escuela
% los valores por defecto son los siguientes:
%\udpschool{Escuela de Informática y Telecomunicaciones}
%\udpfaculty{Facultad de Ingeniería}
%\udpuniversity{Universidad Diego Portales}

\begin{document}
\maketitle

\tableofcontents

\chapter{Introducción}
El reporte puede tener capítulos que lo definan.

\section{¿Por qué necesito una sección?}

Cada capítulo a su vez se divide en secciones. A diferencia de un artículo cuyo elemento superior es solo una sección, este documento puede tener capítulos para organizar más información.

\chapter{Contenido}

Acá otro capítulo.

\end{document}
```

## `udpmemo.cls`

La clase `udpmemo.cls` genera memorandums de manera simple, permitiendo generar un encabezado oficial (incluyendo logos institucionales), así como agregar información de copias del memorandum.


# Plantillas de evaluaciones

## `udpexam.cls`

La clase `udpexam.cls` permite crear examenes y solemnes usando el formato de la UDP. Extiende las mismas funcionalidades de [`exam.cls`](http://ctan.org/tex-archive/macros/latex/contrib/exam/)

```latex
\documentclass{udpexam}
% Descomentar para generar pauta (imprime las respuestas)
%\printanswers

%\setlogo{EIT}
\setlogo{FI}

\coursecode{CIT-1000}
\instructors{Prof. Mengano}
\title{Solemne de Curso}

% Establezco donde quiero los punteos
%\pointsinmargin
\pointsinrightmargin

\begin{document}
\maketitle

\begin{questions}

\question[50]
Demuestre $P = NP$.

\begin{parts}
\part[35]
Por inducción.
\part[35]
Por prueba directa.

\begin{solution}
La solución es obvia (por lo tanto se deja como ejercicio).
\end{solution}
\end{parts}

\question[50]
Resolver ecuaciones polinómicas en tiempo polinomial en el caso estándar.

\begin{solution}
La solución es obvia (por lo tanto se deja como ejercicio).
\end{solution}

\end{questions}

\end{document}
```

## `udpamc.cls`

La clase `udpamc.cls` permite crear examenes de opción múltiple, así como otros documentos de la misma índole (por ejemplo encuestas). Extiende las funcionalidades de [`auto multiple choice`](http://home.gna.org/auto-qcm/).

# Plantillas para encuestas
## `udpsruvey.cls`

La clase `udpsurvey.cls` está construida de tal manera que permite la extensión y creación de nuevas encuestas. La encuesta funciona a través del uso de un formulario de opción múltiple (usando [`auto multiple choice`](http://home.gna.org/auto-qcm/index.en)). Para este fin, se pueden definir las preguntas de manera manual dentro del macro `\onecopy` o bien siguiendo implementación automática iterando una lista de preguntas en un macro (ver la implementación `\questions` en la sección [Definición de preguntas](#definicion)).

En general, la iteración de elementos puede ser de cualquier elemento que pueda ser interpretado por `udpsurvey.cls` (definidos utilizando [`pgfkeys`](http://mirrors.ctan.org/graphics/pgf/base/doc/pgfmanual.pdf)).

### <a id="definicion"></a> Definición de preguntas

Para definir una nueva encuesta debe de definir un conjunto de elementos (similar a los contenidas en `questions.tex`), como

```tex
\def\questions{%
  element,
  {
    sub element of list,
    sub element of list,
    ...
    sub element of list
  },
  ...
  element
}
```

Los elementos pueden ser simples o un conjunto de ellos (denotados entre llaves: `{` y `}`).

Los elementos que están implementados en `udpsurvey.cls` son:

* Preguntas. Las preguntas se definen utilizando `question={<id>}{<text>}`. Note que las preguntas necesitan un identificador de `LaTeX` válido y único. Las preguntas deben tener un tipo definido por `type=<type>`. Por defecto las preguntas son de tipo opción múltiple (`oneitem`). Sin embargo, se puede cambiar el tipo agregando opciones que son procesadas dentro de un grupo.
  
  * Opción múltiple: definidas como `type=oneitem`.
  * Abiertas: definidas como `type=openitem`.
  * Opciones de las preguntas. Además del tipo se pueden definir opciones a cada una de las preguntas a través de `options={<option 1>, ..., <option N>}`. Por ejemplo, se puede establecer parámetros de las preguntas abiertas (usando las opciones de AMC): `options={lines=3, dots=true, lineheight=.3cm}`. 
* Secciones. La encuesta puede definir encabezados (o secciones) con un estilo específico. Para ello, se definen como `section=<text>`.
* Texto libre. Se puede agregar texto libre o instrucciones a la encuesta. Este tipo de elementos se define como `text=<text>`.
* Encabezado de opciones. Se puede agregar un encabezado a la tabla (arriba de cualquier fila) para nombrar las opciones existentes. Este puede mostrar solo las opciones si se ejecuta sin opciones o bien agregar texto a la izquierda de éstas: `header[=<text>]` (`=<text>` es opcional).
* Comandos. Se pueden ejecutar macros de LaTeX en la ejecución de a lista a través de `exec=<cmd>`.
* Administración del encabezado automático. Se puede colocar o remover el encabezado automáticamente utilizando las opciones `auto header on` y `auto header off`, respectivamente.

# Plantillas para cursos
## `udpsyllabus.cls`

Esta clase permite crear programas para cursos de la UDP.

```latex
% Para compilar: pdflatex - biber - pdflatex
\documentclass{udpsyllabus}

% bibliografia embebida en el mismo archivo
\usepackage{filecontents}% permite definir archivos dentro del mismo archivo
\begin{filecontents}{programa.bib}
@BOOK{Foo,
  author = {F. Foo},
  title = {Foo Book},
  publisher = {Foo Publisher},
  year = {2013},
  keywords={obligatorio}% aca definimos el tipo de referencia a incluir en el documento
}

@BOOK{Bar,
  author = {Bar, B.},
  title = {Bar Book},
  publisher = {Bar Publisher},
  year = {2013},
  edition = {2},
  keywords={complementario}
}
\end{filecontents}

% Incluimos el archivo de la bibliografía
\usepackage[backend=biber,style=ieee]{biblatex}
\addbibresource{programa.bib}

%% Parametros del título
% Definimos el nombre del curso
\classname{Nombre del curso}
% Valores predefinidos del título que pueden re-definirse usando los siguientes comandos
% \subtitle{\large PROGRAMA DE ASIGNATURA}
% \author{%
%   Facultad de Ingeniería\\
%   Escuela de Informática y Telecomunicaciones
% }
% \date{}

\begin{document}
% Generamos el encabezado del programa
\maketitle

\section{Identificación}
% Código del curso
\code{CIT-XXXX}
% Número de créditos del curso
\credits{X}
% Duración del curso
\duration{Semestral}
% Semestre en el que se imparte
\semester{Electivo}
% Pre-requisitos del curso
\requirements{CBM-1001, CBM-1002, CBE-2000}
% Sesiones
\sessions{2 cátedras, 1 ayudantía}
% Creamos la información del curso
\makecourseid

\section{Objetivos generales y específicos}

% Definición de los objetivos

\section{Descripción de contenidos}

% Contenidos

% Podemos utilizar un formato para generar los contenidos por items
\begin{enumerate}
\content{Tema 1}{Descripción.}
\content{Tema 2}{Descripción.}
\end{enumerate}

\section{Importancia del curso en el plan de estudios}

% Descripción de la importancia

\section{Metodología}

% Metodología

\section{Evaluación}

% Descripción de la evaluación 

% Tabular las ponderaciones
\begin{tabular}{lll}
\textbullet\quad Solemnes & 30\% & (15\% cada uno) \\
\textbullet\quad Examen & 30\% &\\
\textbullet\quad Tareas, ejercicios y asistencia & 10\% &\\
\textbullet\quad Proyectos & 30\% &(15\% cada uno) \\
\end{tabular}

% Esta sección es opcional y puede utilizar las referencias antes descritas
\section{Bibliografía básica de referencia}
\nocite{*}% Incluimos todas las referencias, o bien podemos citar las pertinentes
% Incluimos la bibliografía obligatoria
\printbibliography[keyword=obligatorio,title={Bibliografía obligatoria},heading=subbibliography]
% Incluimos la bibliografía complementaria
\printbibliography[keyword=complementario,title={Bibliografía complementaria},heading=subbibliography]
\end{document}
```

# Logos

Todos los documentos permiten el uso de el logo institucional, definido dentro de `udp.sty`. Este archivo define el comportamiento de la carga de los distintos logos utilizando las definiciones que se encuentran en la carpeta `logos`. Estos archivos deben siguir la convención `x.logo`, donde `x` es el nombre a utilizar para establecer el logo en el documento, y utilizar la extensión `.logo`. Noten que este último punto es importante, ya que el conjunto de macros actualmente buscará el archivo `.logo` únicamente.

Para facilitar el uso y extensión de los logos se pueden crear logos adicionales (siguiendo las instrucciones siguientes), y depositarlos en dicha carpeta para su utilización de manera directa.

## Uso de los logos

Los logos se utilizan con el comando `\setlogo{x}` donde `x` es el acrónimo que define el archivo a utilizar (es decir, debe existir un archivo `x.logo` dentro de la carpeta `logos` con el logo de la entidad `x`).

Actualmente se encuentran disponibles en la carpeta `logos` los logos de las siguientes entidades:
- **UDP.** Se puede utilizar el logo con color rojo (por defecto) o gris utilizando el acrónimo `UDPr` o `UDPg`, respectivamente. También se puede utilizar el acrónimo `UDP` que establece el color por defecto. Es decir, se debe llamar `\setlogo{UDP}` en el preámbulo de los documentos para establecer el logo en dicho documento.
- **Facultad de Ingeniería.** Se utiliza el acrónimo `FI` para establecer el logo de esta entidad.
- **Escuela de Informática y Telecomunicaciones.** Se puede utilizar el acrónimo `EIT` para establecer el logo. Adicionalmente, se cuenta con el acrónimo `EITFI` que establece el nombre de la escuela agregando "Facultad de Ingeniería" al conjunto.
- **Magíster en Ciencias de la Ingeniería.** Se puede utilizar el acrónimo `MCI` para establecer el logo. Adicionalmente, se cuenta con el acrónimo `MCIFI` que establece el nombre del magíster agregando "Facultad de Ingeniería" al conjunto.

## Instalación de nuevos logos

Los logos actuales utilizan [`tikz`](https://www.ctan.org/pkg/pgf?lang=en) para graficar los logos de manera nativa en los documentos.

Para poder instalar un logo se debe de generar primero el código en `tikz` de la imagen del logo. Para ello se recomienda el uso de [Inkscape](https://inkscape.org/en/) y de su extensión [`inkscape2tikz`](http://code.google.com/p/inkscape2tikz/) (que permite exportar PDFs o SVG a este lenguage).

Por ejemplo, si estamos trabajando el logo de la entidad `XYZ`, y queremos utilizar esas tres letras para el acrónimo (es decir, queremos llamar `\setlogo{XYZ}` en nuestro preambulo) debemos de generar el código en `tikz` (por ejemplo, usando las herramientas antes mencionadas). Una vez tengamos el código se debe de crear un archivo `XYZ.logo` con los contenidos siguientes

```latex
% Logo XYZ Xcuela Ygrofónica de Zumba

\providecommand{\@logoXYZ}{% esta linea debe de cambiarse por el acrónimo correspondiente en lugar de XYZ
% acá inicia el código obtenido por inkscape2tikz
\begin{tikzpicture}
% código omitido por espacio
\end{tikzpicture}
}
```

Posteriormente, debemos de copiar (o mover) el archivo `XYZ.logo` a la carpeta `logos` donde clonamos este repositorio. La sola existencia del archivo `XYZ.logo` permitirá al conjunto de macros encontrar el nuevo logo y poder mostrarlo en nuestro sistema.


## Colores institucionales

Adicionalmente, se proveen de los colores `redudp` y `grayudp` que tienen los colores estándares de la UDP. Esto permite que en el código `tikz` generado anteriormente puedan reemplazar los colores de los logos por estos nombres de color (equivalentes a los nombres de color de LaTeX), y podrán mantener una vista institucional adecuada.
