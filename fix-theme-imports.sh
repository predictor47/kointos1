#!/bin/bash

# Fix Theme Import Issues Script
# This script fixes all the theme import issues after removing redundant theme files

echo "🔧 Fixing theme import issues across the codebase..."

# List of files that need theme import fixes
declare -a files_to_fix=(
    "lib/presentation/widgets/floating_chatbot_widget.dart"
    "lib/presentation/widgets/advanced_crypto_chart.dart"
    "lib/presentation/screens/real_time_chat_screen.dart"
    "lib/presentation/widgets/portfolio_summary_card.dart"
    "lib/presentation/widgets/crypto_list_item.dart"
    "lib/presentation/widgets/market_header.dart"
    "lib/presentation/widgets/post_card.dart"
    "lib/presentation/widgets/portfolio_asset_item.dart"
    "lib/presentation/screens/feed_screen.dart"
    "lib/presentation/screens/article_detail_screen.dart"
    "lib/presentation/screens/auth_screen.dart"
    "lib/presentation/screens/article_editor_screen.dart"
    "lib/presentation/screens/portfolio_screen.dart"
    "lib/presentation/widgets/interactive_tutorial_screen.dart"
    "lib/presentation/widgets/community_post_widget.dart"
    "lib/presentation/screens/terms_of_service_screen.dart"
    "lib/presentation/screens/communities_screen.dart"
    "lib/presentation/screens/privacy_policy_screen.dart"
)

# Function to fix imports in a file
fix_imports() {
    local file="$1"
    echo "  📝 Fixing imports in $file"
    
    # Replace app_theme.dart import with modern_theme.dart
    sed -i "s|import 'package:kointos/core/theme/app_theme.dart';|import 'package:kointos/core/theme/modern_theme.dart';|g" "$file"
    
    # Replace adaptive_theme.dart import with modern_theme.dart
    sed -i "s|import 'package:kointos/core/theme/adaptive_theme.dart';|import 'package:kointos/core/theme/modern_theme.dart';|g" "$file"
}

# Fix each file
for file in "${files_to_fix[@]}"; do
    if [ -f "$file" ]; then
        fix_imports "$file"
    else
        echo "  ⚠️  File not found: $file"
    fi
done

echo ""
echo "✅ Theme import fixes completed!"
echo ""
echo "⚠️  Note: You'll still need to manually update theme property references:"
echo "   - AppTheme.* -> AppTheme.* (check property names in modern_theme.dart)"
echo "   - AdaptiveTheme.* -> AppTheme.* (replace with equivalent modern theme properties)"
echo ""
echo "🔍 Run 'flutter analyze' to see remaining issues to fix"
