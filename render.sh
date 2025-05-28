#!/bin/bash
set -e

echo "📄 Rendering sustainability report..."

# Inputs
INPUT_CSV="acme.csv"
OUTPUT_PDF="reports/acme_report.pdf"

# Render PDF using Quarto
quarto render template.qmd \
  --to pdf \
  --output "$OUTPUT_PDF" \
  --parameter file="$INPUT_CSV"

echo "✅ Report generated: $OUTPUT_PDF"

echo "📧 Sending report to $EMAIL_TO..."

# Send via mutt + msmtp
echo "Attached is your sustainability report." | \
  mutt -s "Acme Sustainability Report" \
       -a "$OUTPUT_PDF" -- "$EMAIL_TO"

echo "✅ Email sent to $EMAIL_TO"

