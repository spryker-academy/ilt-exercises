#!/bin/bash
#
# Exercise Loader - Loads exercise code into the Spryker project
#
# Usage:
#   ./exercises/load.sh <package> <branch>
#
# Examples:
#   ./exercises/load.sh hello-world basics/hello-world-back-office/skeleton
#   ./exercises/load.sh supplier intermediate/back-office/skeleton
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
    echo "  basics/hello-world-back-office/skeleton"
    echo "  basics/hello-world-back-office/complete"
    echo "  basics/data-transfer-object/skeleton"
    echo "  basics/data-transfer-object/complete"
    echo "  basics/message-table-schema/skeleton"
    echo "  basics/message-table-schema/complete"
    echo "  basics/module-layers/skeleton"
    echo "  basics/module-layers/complete"
    echo ""
    echo "Supplier branches:"
    echo "  basics/supplier-table-schema/skeleton"
    echo "  intermediate/back-office/skeleton"
    echo "  intermediate/back-office/complete"
    echo "  intermediate/data-import/skeleton"
    echo "  intermediate/data-import/complete"
    echo "  intermediate/publish-synchronize/skeleton"
    echo "  intermediate/publish-synchronize/complete"
    echo "  intermediate/search/skeleton"
    echo "  intermediate/search/complete"
    echo "  intermediate/storage-client/skeleton"
    echo "  intermediate/storage-client/complete"
    echo "  intermediate/glue-storefront/skeleton"
    echo "  intermediate/glue-storefront/complete"
    echo "  intermediate/oms/skeleton"
    echo "  intermediate/oms/complete"
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
