from pdf2docx import Converter

pdf_file = 'PATH/TO/FILES'
docx_file = 'PATH/TO/DESTINATION'

cv = Converter(pdf_file)
cv.convert(docx_file, start=0, end=None)
cv.close()
