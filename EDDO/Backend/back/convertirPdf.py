from docx import Document
from docx2pdf import convert
import os

def generar_constancia(
    docente,
    filiacion,
    fecha_contratacion,
    clave_presupuestal,
    fecha_escrita,
    dia_mes,
    fecha_esc_2
):
    ruta_docx = r"C:\\VisualStudio\\Python\\EDDO\\EDDO\\EDDO\\Backend\\documentos\\doc1.docx"
    salida_docx = r"C:\\VisualStudio\\Python\\EDDO\\EDDO\\EDDO\\Backend\\documentos\\constancia_generada1.docx"
    salida_pdf = r"C:\\VisualStudio\\Python\\EDDO\\EDDO\\EDDO\\Backend\\documentos\\constancia_generada.pdf"
    # Leer plantilla Word
    doc = Document(ruta_docx)

    # Función auxiliar que reemplaza texto en todos los párrafos (sin perder formato)
    def reemplazar_texto(documento, buscar, reemplazar):
        for p in documento.paragraphs:
            if buscar in p.text:
                for run in p.runs:
                    if buscar in run.text:
                        run.text = run.text.replace(buscar, reemplazar)
        for tabla in documento.tables:
            for fila in tabla.rows:
                for celda in fila.cells:
                    reemplazar_texto(celda, buscar, reemplazar)

    # Reemplazar todas las variables
    reemplazar_texto(doc, "VARIABLE_DOCENTE", docente)
    reemplazar_texto(doc, "VARIABLE_FILACION", filiacion)
    reemplazar_texto(doc, "VAR_FECHA_CONTRATACION", fecha_contratacion)
    reemplazar_texto(doc, "VAR_CLAVE_PRESUNTUAL", clave_presupuestal)
    reemplazar_texto(doc, "VAR_FECHA_ESCRITA", fecha_escrita)
    reemplazar_texto(doc, "VAR_DIA_MES", dia_mes)
    reemplazar_texto(doc, "VAR_FECHA_ESC_2", fecha_esc_2)

    # Guardar el nuevo documento
    doc.save(salida_docx)

    # Convertir el Word a PDF (mantiene formato e imágenes)
    convert(salida_docx, salida_pdf)
    if os.path.exists(salida_docx):
        os.remove(salida_docx)
        print("🗑️ Archivo eliminado correctamente.")
    else:
        print("⚠️ El archivo no existe:", salida_docx)

    print(f"✅ PDF generado correctamente en:\n{salida_pdf}")

# Ejemplo de uso:
generar_constancia(
    docente="Juan Pérez López",
    filiacion="123456",
    fecha_contratacion="15 de marzo de 2018",
    clave_presupuestal="C12345",
    fecha_escrita="9 de junio de 2025",
    dia_mes="1 de enero de 2024",
    fecha_esc_2="9 de junio de 2025"
)
