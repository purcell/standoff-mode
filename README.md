# standoff-mode#

`standoff-mode` is a major mode for
[GNU Emacs](http://www.gnu.org/software/emacs/) that lets you create
annotations and markup for read-only text files in a stand-off
manner. It is written for use in the field of digital humanities and
the manual annotation of training data for named-entity recognition.

There are several tools for creating stand-off markup. Most of them
need to be deployed on a server in a network environment, which may be
a barrier. In contrast `standoff-mode` does not need a networking
environment. It wants to enable one to get hands on annotating texts
right away.

Markup can be stored in several formats with `standoff-mode`:
including dumped lisp-expressions,
[BRAT](http://brat.nlplab.org/standoff.html)'s plain-text format, a
(remote or local) SQL-Database or as RDF-triples in a SPARQL-endpoint
following the emerging standard defined in the
[OpenAnnotation](http://www.openannotation.org/spec/core/) ontology.

It does not want to be everything under one hood. It's just a tool for
the manual annotation of texts. Statistics must be done by another
tool.

Since it was written for the field of digital humanities, literature
studies in particular, `standoff-mode` works not only with plain text
input (source) files, but also with XML. So semantic stand-off markup
produced with it may reference structural markup coded in TEI/P5,
which may be of advantage for further processing.

## Stand-off Markup ##

Stand-off markup is also known as external markup and means:

- stand-off markup refers to a source document by some kind of
  pointers (`standoff-mode` uses character offsets)

- it is contained in an external document 

- the source document is left unchanged and may be read-only

- the source document may contain markup too, called internal markup

Cf. the
[TEI/P5 guidelines on stand-off markup](http://www.tei-c.org/release/doc/tei-p5-doc/de/html/NH.html#NHSO)
and the [OpenAnnotation](http://www.openannotation.org/spec/core/)
ontology.

## Features ##

- allows discontinuous markup

- allows relations between markup elements (rdf-like directed graphs)

- allows attributes on markup

- allows text annotations anchored on one or several markup elements

- restrictiveness of the type of markup, relation-predicate or
  attribute can be customized (restriction to schema definition, all
  in use, free)

- easy customization of schema and highlighting

- everything can be done with the keyboard an key-codes

- several pluggable back-ends (under development) 

## Roadmap ##

`standoff-mode` is under active development. Currently only a
non-persistent dummy back-end exists. Here's the roadmap:

- dumped lisp-expressions as back-end

- BRAT-like back-end

- text annotations

- SPARQL back-end

- SQL back-end

## Requirements ##

Only [GNU Emacs](http://www.gnu.org/software/emacs/#Obtaining) is
required. After the installation of the editor the `standoff-mode`
package has to be installed. It was tested on Windows, Linux and Mac,
with versions 24.3 and 24.5.

If you want to store your markup in SQL-tables or as RDF-triples, a
RDBMS or a SPARQL-endpoint is required.

## Configuration ##

will be filled soon