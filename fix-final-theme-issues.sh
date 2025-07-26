#!/bin/bash

# Final Theme Fixes Script
# This script fixes remaining AdaptiveTheme references and other issues

echo "🔧 Applying final theme fixes..."

# Function to fix AdaptiveTheme references
fix_adaptive_theme_references() {
    local file=$1
    echo "  🔄 Fixing AdaptiveTheme references in $file"
    
    # Replace all AdaptiveTheme references with AppTheme equivalents
    sed -i 's/AdaptiveTheme\./AppTheme\./g' "$file"
    
    # Remove unused import if it exists
    sed -i '/import.*modern_theme\.dart.*;/d' "$file"
    
    # Add the import back
    if grep -q "AppTheme\." "$file"; then
        if ! grep -q "import 'package:kointos/core/theme/modern_theme.dart';" "$file"; then
            # Find the last import and add our import after it
            sed -i '/^import /a import '\''package:kointos/core/theme/modern_theme.dart'\'';' "$file"
        fi
    fi
}

# Fix specific method issues
fix_specific_issues() {
    local file=$1
    echo "  🛠️  Fixing specific issues in $file"
    
    # Fix getCryptocurrencies method name
    sed -i 's/getCryptocurrencies(/getTopCryptocurrencies(/g' "$file"
    
    # Fix pulse method (remove if not available)
    sed -i 's/\.pulse(.*)/\.animate().scale(duration: const Duration(milliseconds: 200))/g' "$file"
    
    # Fix withOpacity calls that use integer values
    sed -i 's/\.withOpacity(25)/.withOpacity(0.25)/g' "$file"
    sed -i 's/AppTheme\.primaryWithAlpha(25)/AppTheme.primaryWithAlpha(0.25)/g' "$file"
}

# List of files with AdaptiveTheme references
declare -a adaptive_theme_files=(
    "lib/presentation/screens/communities_screen.dart"
    "lib/presentation/screens/privacy_policy_screen.dart"
    "lib/presentation/screens/real_time_chat_screen.dart" 
    "lib/presentation/screens/terms_of_service_screen.dart"
    "lib/presentation/widgets/advanced_crypto_chart.dart"
    "lib/presentation/widgets/community_post_widget.dart"
    "lib/presentation/widgets/interactive_tutorial_screen.dart"
)

# Fix AdaptiveTheme files
for file in "${adaptive_theme_files[@]}"; do
    if [ -f "$file" ]; then
        fix_adaptive_theme_references "$file"
    fi
done

# Fix specific method issues
declare -a method_fix_files=(
    "lib/presentation/widgets/floating_chatbot_widget.dart"
    "lib/presentation/screens/crypto_detail_screen.dart"
)

for file in "${method_fix_files[@]}"; do
    if [ -f "$file" ]; then
        fix_specific_issues "$file"
    fi
done

echo ""
echo "✅ Final theme fixes applied!"
echo ""
echo "🔍 Running flutter analyze to check remaining issues..."
flutter analyze --no-pub | head -50
