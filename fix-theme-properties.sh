#!/bin/bash

# Fix Theme Property References Script
# This script maps old theme properties to modern theme equivalents

echo "🎨 Fixing theme property references across the codebase..."

# Common property mappings
declare -A property_mappings=(
    # Old AppTheme properties -> New AppTheme properties
    ["AppTheme.backgroundColor"]="AppTheme.primaryBlack"
    ["AppTheme.accentColor"]="AppTheme.cryptoGold"
    ["AppTheme.textSecondaryColor"]="AppTheme.greyText"
    ["AppTheme.primaryColor"]="AppTheme.pureWhite"
    ["AppTheme.positiveChangeColor"]="AppTheme.successGreen"
    ["AppTheme.negativeChangeColor"]="AppTheme.errorRed"
    ["AppTheme.primaryWithAlpha("]="AppTheme.pureWhite.withOpacity("
    
    # AdaptiveTheme properties -> AppTheme properties
    ["AdaptiveTheme.webPrimaryColor"]="AppTheme.pureWhite"
    ["AdaptiveTheme.mobilePrimaryColor"]="AppTheme.pureWhite"
    ["AdaptiveTheme.webAccentColor"]="AppTheme.cryptoGold"
    ["AdaptiveTheme.mobileAccentColor"]="AppTheme.cryptoGold"
    ["AdaptiveTheme.webBackgroundColor"]="AppTheme.primaryBlack"
    ["AdaptiveTheme.mobileBackgroundColor"]="AppTheme.primaryBlack"
    ["AdaptiveTheme.webSurfaceColor"]="AppTheme.secondaryBlack"
    ["AdaptiveTheme.mobileSurfaceColor"]="AppTheme.secondaryBlack"
    ["AdaptiveTheme.webTextColor"]="AppTheme.pureWhite"
    ["AdaptiveTheme.mobileTextColor"]="AppTheme.pureWhite"
    ["AdaptiveTheme.webSecondaryTextColor"]="AppTheme.greyText"
    ["AdaptiveTheme.mobileSecondaryTextColor"]="AppTheme.greyText"
    ["AdaptiveTheme.webCardColor"]="AppTheme.cardBlack"
    ["AdaptiveTheme.mobileCardColor"]="AppTheme.cardBlack"
)

# List of files to fix
declare -a files_to_fix=(
    "lib/presentation/screens/crypto_detail_screen.dart"
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

# Function to fix properties in a file
fix_properties() {
    local file="$1"
    echo "  🔄 Fixing properties in $file"
    
    # Apply property mappings
    for old_prop in "${!property_mappings[@]}"; do
        new_prop="${property_mappings[$old_prop]}"
        sed -i "s|${old_prop}|${new_prop}|g" "$file"
    done
    
    # Fix special cases
    sed -i 's|AppTheme\.pureWhite\.withOpacity(25)|AppTheme.pureWhite.withOpacity(0.25)|g' "$file"
    sed -i 's|\.withOpacity(25)|.withOpacity(0.25)|g' "$file"
}

# Fix each file
for file in "${files_to_fix[@]}"; do
    if [ -f "$file" ]; then
        fix_properties "$file"
    else
        echo "  ⚠️  File not found: $file"
    fi
done

echo ""
echo "✅ Theme property fixes completed!"
echo ""
echo "🔍 Running flutter analyze to check for remaining issues..."
flutter analyze --no-pub
