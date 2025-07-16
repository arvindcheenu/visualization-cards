#!/bin/bash
# Unified script to generate index.js files for both cards and scenarios directories
# Function to generate cards index
generate_cards() {
    local CARDS_DIR="cards"
    local OUTPUT_FILE="$CARDS_DIR/index.js"
    # Check if cards directory exists
    if [ ! -d "$CARDS_DIR" ]; then
        echo "✗ Failed to generate cards/index.js - directory not found"
        return 1
    fi
    # Create the index.js file
    echo "// Auto-generated file - do not edit manually" > "$OUTPUT_FILE"
    echo "// Last generated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    echo "export const files = [" >> "$OUTPUT_FILE"
    # Find all PNG files and add them to the array
    find "$CARDS_DIR" -name "*.png" -type f | sort | while read -r file; do
        # Get just the filename without the directory path
        filename=$(basename "$file")
        echo "  \"$filename\"," >> "$OUTPUT_FILE"
    done
    echo "];" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    echo "export const lastGenerated = \"$(date -u +"%Y-%m-%dT%H:%M:%SZ")\";" >> "$OUTPUT_FILE"
    local count=$(find "$CARDS_DIR" -name "*.png" -type f | wc -l | tr -d ' ')
    echo "✓ Generated $OUTPUT_FILE with $count files"
    return 0
}
# Function to generate scenarios index
generate_scenarios() {
    local SCENARIOS_DIR="scenarios"
    local OUTPUT_FILE="$SCENARIOS_DIR/index.js"
    # Check if scenarios directory exists
    if [ ! -d "$SCENARIOS_DIR" ]; then
        echo "✗ Failed to generate scenarios/index.js - directory not found"
        return 1
    fi
    # Create the index.js file
    echo "// Auto-generated file - do not edit manually" > "$OUTPUT_FILE"
    echo "// Last generated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    echo "export const files = [" >> "$OUTPUT_FILE"
    # Find all image files (PNG, JPG, JPEG) and add them to the array
    find "$SCENARIOS_DIR" \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" \) -type f | sort | while read -r file; do
        # Get just the filename without the directory path
        filename=$(basename "$file")
        echo "  \"$filename\"," >> "$OUTPUT_FILE"
    done
    echo "];" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    echo "export const lastGenerated = \"$(date -u +"%Y-%m-%dT%H:%M:%SZ")\";" >> "$OUTPUT_FILE"
    local count=$(find "$SCENARIOS_DIR" \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" \) -type f | wc -l | tr -d ' ')
    echo "✓ Generated $OUTPUT_FILE with $count files"
    return 0
}
# Main execution
cards_success=0
scenarios_success=0
# Generate both indices
generate_cards && cards_success=1
generate_scenarios && scenarios_success=1
if [ $cards_success -eq 1 ] || [ $scenarios_success -eq 1 ]; then
    echo "Index files have been generated. You can now use the ViBBS application."
    exit 0
else
    echo "No index files were generated. Please check that cards/ and/or scenarios/ directories exist."
    exit 1
fi