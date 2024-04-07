# text_extract

A helper Makefile for extracting text from PDFs using different methods.

## Initial setup

* For all targets:

  ```
  sudo apt-get install poppler-utils  # For pdftotext and pdfimages.
  ```
* For Tesseract:

  ```
  sudo apt-get install tesseract
  sudo apt-get install colorized-logs  # For ansi2txt.
  ```

* For [AWS Textract](https://aws.amazon.com/textract/):

  Set up the AWS account and authorization for [AWS CLI](https://aws.amazon.com/cli/).
  ```
  sudo apt-get install pipx && pipx install amazon-textract-helper
  ```

## Usage

```
git clone https://github.com/sadkingbilly/text_extract.git
cd text_extract
mkdir pdfs  # Place your input PDFs here.
make all
```
