import fitz
import os

def split_pdf_by_chapters(input_path: str, output_folder: str):
    doc = fitz.open(input_path)
    toc = doc.get_toc()
    total_pages = doc.page_count

    # Filtra nível 3 = CHAPTER X (estrutura deste PDF específico)
    chapters = [(title, page) for level, title, page in toc if level == 3]

    os.makedirs(output_folder, exist_ok=True)

    for i, (title, start_page) in enumerate(chapters):
        if i + 1 < len(chapters):
            end_page = chapters[i + 1][1] - 1
        else:
            end_page = total_pages

        chapter_doc = fitz.open()
        chapter_doc.insert_pdf(doc, from_page=start_page - 1, to_page=end_page - 1)

        safe_title = "".join(c for c in title if c.isalnum() or c in " _-").strip()
        output_path = os.path.join(output_folder, f"{i+1:02d}_{safe_title}.pdf")
        chapter_doc.save(output_path)
        chapter_doc.close()
        print(f"Salvo: {output_path} (páginas {start_page}–{end_page})")

    doc.close()

split_pdf_by_chapters( "Livro Completo.pdf", "capitulos/" )