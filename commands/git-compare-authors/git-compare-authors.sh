#!/bin/bash
# git-compare-authors.sh
# Usage: git compare-authors <author1> <author2>

if [ "$#" -ne 2 ]; then
    echo "Usage: git compare-authors <author1> <author2>"
    exit 1
fi

AUTHOR1=$1
AUTHOR2=$2

# Function to get commit count
get_commits() {
    git log --author="$1" --pretty=format:"%h" | wc -l
}

# Function to get lines added and deleted
get_line_stats() {
    git log --author="$1" --pretty=tformat: --numstat | \
    awk '{added+=$1; deleted+=$2} END {print added, deleted}'
}

COMMITS1=$(get_commits "$AUTHOR1")
COMMITS2=$(get_commits "$AUTHOR2")

STATS1=($(get_line_stats "$AUTHOR1"))
STATS2=($(get_line_stats "$AUTHOR2"))

ADDED1=${STATS1[0]:-0}
DELETED1=${STATS1[1]:-0}

ADDED2=${STATS2[0]:-0}
DELETED2=${STATS2[1]:-0}

echo ""
echo "📊 Git Author Comparison Report"
echo ""
printf "%-15s %-10s %-15s %-15s\n" "Author" "Commits" "Lines Added" "Lines Deleted"
echo "------------------------------------------------------------"
printf "%-15s %-10s %-15s %-15s\n" "$AUTHOR1" "$COMMITS1" "$ADDED1" "$DELETED1"
printf "%-15s %-10s %-15s %-15s\n" "$AUTHOR2" "$COMMITS2" "$ADDED2" "$DELETED2"
