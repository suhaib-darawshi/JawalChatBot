import sys
import pdfplumber

def is_green(text_color):
    # Assuming green is not pure black; adjust the actual green RGB values accordingly
    return text_color != (0, 0, 0)  # Assumes non-black text is green; update as needed with actual green color

def extract_questions_by_color(pdf_file_path, output_txt_path):
    with pdfplumber.open(pdf_file_path) as pdf, open(output_txt_path, 'w', encoding='utf-8') as output_file:
        text_buffer = ""  # Buffer to store continuous text of the same color
        previous_color_green = False  # Track if the previous character was green
        last_x0 = 0  # To track the horizontal position of the last character

        for page in pdf.pages:
            for char in page.chars:
                current_color_green = is_green(char['non_stroking_color'])

                # Check if there is a significant horizontal gap, indicating a new word or line
                if char['x0'] > last_x0 + 2:  # Adjust as needed
                    text_buffer += ' '

                if current_color_green == previous_color_green:
                    # If the color state hasn't changed, continue appending characters
                    text_buffer += char['text']
                else:
                    # If the color changes from green to black or vice versa, process the buffer
                    if previous_color_green:
                        # If switching from green to black, add a newline
                        output_file.write(text_buffer + '\n')
                    else:
                        # If switching from black to green, add two newlines (to separate questions)
                        output_file.write(text_buffer + '\n\n')

                    # Reset buffer with the new character and update color tracking
                    text_buffer = char['text']
                    previous_color_green = current_color_green

                # Update last_x0 to the current character's position
                last_x0 = char['x1']

            # Ensure any remaining text in the buffer is written out after the last character
            output_file.write(text_buffer + '\n')
            text_buffer = ""  # Reset buffer at the end of each page
            previous_color_green = False  # Reset color tracking at the end of each page

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python script.py <input_pdf_path> <output_txt_path>")
        sys.exit(1)
    input_pdf_path = sys.argv[1]
    output_txt_path = sys.argv[2]
    extract_questions_by_color(input_pdf_path, output_txt_path)
