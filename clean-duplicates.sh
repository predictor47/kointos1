#!/bin/bash

# Clean Duplicate Imports Script
# This script removes duplicate imports that were created during the fixing process

echo "🧹 Cleaning up duplicate imports..."

# Function to remove duplicate imports
clean_duplicates() {
    local file=$1
    echo "  🔄 Cleaning duplicates in $file"
    
    # Create temp file without duplicates
    awk '!seen[$0]++' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
}

# Files with duplicate imports
declare -a files_with_duplicates=(
    "lib/presentation/screens/communities_screen.dart"
    "lib/presentation/screens/real_time_chat_screen.dart" 
    "lib/presentation/widgets/advanced_crypto_chart.dart"
    "lib/presentation/widgets/community_post_widget.dart"
)

# Clean each file
for file in "${files_with_duplicates[@]}"; do
    if [ -f "$file" ]; then
        clean_duplicates "$file"
    fi
done

echo ""
echo "✅ Duplicate imports cleaned!"
echo ""
echo "📊 Final analysis summary:"
flutter analyze --no-pub 2>/dev/null | grep -E "(error|warning|info)" | head -10
