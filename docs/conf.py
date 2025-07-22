# -- Import setup -------------------------------------------------------------

from os import path
import os

# -- Project information ------------------------------------------------------

repository = 'adi-kuiper-gen'
project = 'Kuiper'
copyright = '2025, Analog Devices, Inc.'
author = 'Analog Devices, Inc.'

# Version from environment variable or fallback
version = os.environ.get('ADOC_DOC_VERSION', 'latest')

# -- General configuration ----------------------------------------------------

extensions = [
    'sphinx.ext.todo',
    'adi_doctools',
    'rst2pdf.pdfbuilder',
]

needs_extensions = {
    'adi_doctools': '0.3.47'
}

exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']
source_suffix = '.rst'

# -- Numbered references configuration ----------------------------------------

numfig = True
numfig_format = {
    'figure': 'Figure %s',
    'table': 'Table %s',
    'code-block': 'Listing %s',
    'section': 'Section %s'
}

# -- External docs configuration ----------------------------------------------

interref_repos = ['doctools', 'documentation', 'pyadi-iio']

# -- Custom extensions configuration ------------------------------------------

hide_collapsible_content = True
validate_links = False

# -- todo configuration -------------------------------------------------------

todo_include_todos = True
todo_emit_warnings = True

# -- Options for HTML output --------------------------------------------------

html_theme = 'cosmic'
html_static_path = ['sources']
html_favicon = path.join("sources", "icon.svg")

html_theme_options = {
    "light_logo": "logo.svg",
    "dark_logo": "logo.svg",
}

# -- Options for PDF output ---------------------------------------------------

pdf_documents = [
    ('index', project, project, author),
]
