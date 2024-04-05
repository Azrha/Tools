import PyPDF2

with open('PATH/TO/FILE', 'rb') as file:
    reader = PyPDF2.PdfReader(file)
    if reader.is_encrypted:
        print("The PDF is encrypted.")
    else:
        print("The PDF is not encrypted.")
