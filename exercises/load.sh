#!/bin/bash
#
# Exercise Loader - Loads exercise code into the Spryker project
#
# Usage:
#   ./exercises/load.sh <package> <branch>
#
# Examples:
#   ./exercises/load.sh hello-world ilt/202512.0/basics/hello-world-back-office/skeleton
#   ./exercises/load.sh supplier ilt/202512.0/intermediate/back-office/skeleton
#
# First run will clone the repos and configure the project automatically.
#

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
REPOS_DIR="$SCRIPT_DIR/repos"

HELLO_WORLD_REPO="https://github.com/spryker-academy/hello-world.git"
SUPPLIER_REPO="https://github.com/spryker-academy/supplier.git"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

usage() {
    echo "Usage: ./exercises/load.sh <package> <branch>"
    echo ""
    echo "Packages: hello-world, supplier"
    echo ""
    echo "Hello World branches:"
    echo "  ilt/202512.0/basics/hello-world-back-office/skeleton"
    echo "  ilt/202512.0/basics/hello-world-back-office/complete"
    echo "  ilt/202512.0/basics/data-transfer-object/skeleton"
    echo "  ilt/202512.0/basics/data-transfer-object/complete"
    echo "  ilt/202512.0/basics/message-table-schema/skeleton"
    echo "  ilt/202512.0/basics/message-table-schema/complete"
    echo "  ilt/202512.0/basics/module-layers/skeleton"
    echo "  ilt/202512.0/basics/module-layers/complete"
    echo ""
    echo "Supplier branches:"
    echo "  ilt/202512.0/basics/supplier-table-schema/skeleton"
    echo "  ilt/202512.0/intermediate/back-office/skeleton"
    echo "  ilt/202512.0/intermediate/back-office/complete"
    echo "  ilt/202512.0/intermediate/data-import/skeleton"
    echo "  ilt/202512.0/intermediate/data-import/complete"
    echo "  ilt/202512.0/intermediate/publish-synchronize/skeleton"
    echo "  ilt/202512.0/intermediate/publish-synchronize/complete"
    echo "  ilt/202512.0/intermediate/search/skeleton"
    echo "  ilt/202512.0/intermediate/search/complete"
    echo "  ilt/202512.0/intermediate/storage-client/skeleton"
    echo "  ilt/202512.0/intermediate/storage-client/complete"
    echo "  ilt/202512.0/intermediate/glue-storefront/skeleton"
    echo "  ilt/202512.0/intermediate/glue-storefront/complete"
    echo "  ilt/202512.0/intermediate/oms/skeleton"
    echo "  ilt/202512.0/intermediate/oms/complete"
    exit 1
}

# Validate arguments
if [ $# -ne 2 ]; then
    usage
fi

PACKAGE="$1"
BRANCH="$2"

if [ "$PACKAGE" != "hello-world" ] && [ "$PACKAGE" != "supplier" ]; then
    echo -e "${RED}Error: Package must be 'hello-world' or 'supplier'${NC}"
    usage
fi

# Determine repo URL
if [ "$PACKAGE" = "hello-world" ]; then
    REPO_URL="$HELLO_WORLD_REPO"
else
    REPO_URL="$SUPPLIER_REPO"
fi

REPO_DIR="$REPOS_DIR/$PACKAGE"

# Clone repo if not present
if [ ! -d "$REPO_DIR" ]; then
    echo -e "${YELLOW}Cloning $PACKAGE repository...${NC}"
    mkdir -p "$REPOS_DIR"
    git clone "$REPO_URL" "$REPO_DIR"
fi

# Fetch latest and checkout branch
echo -e "${YELLOW}Switching to branch: $BRANCH${NC}"
cd "$REPO_DIR"
git fetch origin
git checkout "$BRANCH" 2>/dev/null || git checkout -b "$BRANCH" "origin/$BRANCH"
git pull origin "$BRANCH" 2>/dev/null || true
cd "$PROJECT_DIR"

# Verify the branch has src/SprykerAcademy
if [ ! -d "$REPO_DIR/src/SprykerAcademy" ] && [ ! -d "$REPO_DIR/src/Pyz" ]; then
    echo -e "${YELLOW}Note: This branch has no src/ files (empty skeleton).${NC}"
fi

# Clean previous exercise files
echo -e "${YELLOW}Cleaning previous exercise files...${NC}"
rm -rf "$PROJECT_DIR/src/SprykerAcademy"

# Copy SprykerAcademy source files
if [ -d "$REPO_DIR/src/SprykerAcademy" ]; then
    cp -R "$REPO_DIR/src/SprykerAcademy" "$PROJECT_DIR/src/SprykerAcademy"
fi

# Copy Pyz overrides if present (e.g., supplier package)
if [ -d "$REPO_DIR/src/Pyz" ]; then
    cp -R "$REPO_DIR/src/Pyz/"* "$PROJECT_DIR/src/Pyz/" 2>/dev/null || true
fi

# Copy config and data files for supplier package
if [ "$PACKAGE" = "supplier" ]; then
    [ -f "$REPO_DIR/config/Zed/navigation.xml" ] && cp "$REPO_DIR/config/Zed/navigation.xml" "$PROJECT_DIR/config/Zed/navigation.xml"
    [ -f "$REPO_DIR/config/Zed/oms/Demo01.xml" ] && mkdir -p "$PROJECT_DIR/config/Zed/oms" && cp "$REPO_DIR/config/Zed/oms/Demo01.xml" "$PROJECT_DIR/config/Zed/oms/Demo01.xml"
    [ -f "$REPO_DIR/data/import/supplier.csv" ] && mkdir -p "$PROJECT_DIR/data/import" && cp "$REPO_DIR/data/import/supplier.csv" "$PROJECT_DIR/data/import/supplier.csv"
    [ -f "$REPO_DIR/data/import/supplier_location.csv" ] && cp "$REPO_DIR/data/import/supplier_location.csv" "$PROJECT_DIR/data/import/supplier_location.csv"
fi

# One-time setup: add SprykerAcademy to autoload if not present
if ! grep -q '"SprykerAcademy\\\\": "src/SprykerAcademy/"' "$PROJECT_DIR/composer.json"; then
    echo -e "${YELLOW}Adding SprykerAcademy namespace to composer autoload...${NC}"
    sed -i.bak '/"Pyz\\\\": "src\/Pyz\/"/a\
            "SprykerAcademy\\\\": "src/SprykerAcademy/",' "$PROJECT_DIR/composer.json"
    rm -f "$PROJECT_DIR/composer.json.bak"
fi

# One-time setup: add SprykerAcademy to PROJECT_NAMESPACES if not present
if ! grep -q "'SprykerAcademy'" "$PROJECT_DIR/config/Shared/config_default.php"; then
    echo -e "${YELLOW}Adding SprykerAcademy to PROJECT_NAMESPACES in config_default.php...${NC}"
    sed -i.bak "s/\$config\[KernelConstants::PROJECT_NAMESPACES\] = \[/\$config[KernelConstants::PROJECT_NAMESPACES] = [\n    'SprykerAcademy',/" "$PROJECT_DIR/config/Shared/config_default.php"
    rm -f "$PROJECT_DIR/config/Shared/config_default.php.bak"

    # Also add to Glue Backend namespaces
    sed -i.bak "s/\$config\[GlueBackendApiApplicationConstants::PROJECT_NAMESPACES\] = \[/\$config[GlueBackendApiApplicationConstants::PROJECT_NAMESPACES] = [\n    'SprykerAcademy',/" "$PROJECT_DIR/config/Shared/config_default.php"
    rm -f "$PROJECT_DIR/config/Shared/config_default.php.bak"
fi

# Count files
FILE_COUNT=$(find "$PROJECT_DIR/src/SprykerAcademy" -type f 2>/dev/null | wc -l | tr -d ' ')

echo ""
echo -e "${GREEN}Exercise loaded successfully!${NC}"
echo -e "  Package: ${GREEN}$PACKAGE${NC}"
echo -e "  Branch:  ${GREEN}$BRANCH${NC}"
echo -e "  Files:   ${GREEN}$FILE_COUNT${NC} files in src/SprykerAcademy/"
echo ""
echo -e "Next steps (run inside ${YELLOW}docker/sdk cli${NC}):"
echo "  composer dump-autoload"
echo "  console transfer:generate"
echo "  console propel:install"
