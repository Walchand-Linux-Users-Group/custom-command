#!/bin/bash
# coderun - Universal code runner for multiple languages
# Author: WLUG Custom Commands
# Description: Automatically detect and run code files in various languages

# Function to display usage
usage() {
    echo "Usage: coderun <file> [arguments]"
    echo ""
    echo "Universal code runner - detects and executes code automatically"
    echo ""
    echo "Supported Languages:"
    echo "  Python (.py)"
    echo "  Java (.java)"
    echo "  C++ (.cpp, .cc)"
    echo "  C (.c)"
    echo "  JavaScript (.js)"
    echo "  Bash (.sh)"
    echo "  Go (.go)"
    echo "  Rust (.rs)"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -c, --compile  Compile only (for compiled languages)"
    echo "  -t, --time     Show execution time"
    echo "  -m, --memory   Show memory usage"
    echo ""
    echo "Examples:"
    echo "  coderun solution.cpp"
    echo "  coderun --time program.py"
    echo "  coderun --compile main.c"
    exit 1
}

# Check for help flag
if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ -z "$1" ]; then
    usage
fi

# Parse options
COMPILE_ONLY=false
SHOW_TIME=false
SHOW_MEMORY=false
FILE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -c|--compile)
            COMPILE_ONLY=true
            shift
            ;;
        -t|--time)
            SHOW_TIME=true
            shift
            ;;
        -m|--memory)
            SHOW_MEMORY=true
            shift
            ;;
        *)
            if [ -z "$FILE" ]; then
                FILE=$1
            else
                ARGS="$ARGS $1"
            fi
            shift
            ;;
    esac
done

# Check if file exists
if [ ! -f "$FILE" ]; then
    echo "❌ Error: File '$FILE' not found"
    exit 1
fi

# Get file extension
EXT="${FILE##*.}"
BASENAME="${FILE%.*}"

echo "🚀 Running: $FILE"
echo "======================================"

# Prepare time and memory commands if needed
TIME_CMD=""
if [ "$SHOW_TIME" = true ]; then
    TIME_CMD="/usr/bin/time -f '\n⏱️  Time: %E\n💾 Memory: %M KB'"
fi

# Execute based on file type
case $EXT in
    py)
        echo "🐍 Detected: Python"
        if command -v python3 &> /dev/null; then
            $TIME_CMD python3 "$FILE" $ARGS
        else
            echo "❌ Error: Python3 not installed"
            exit 1
        fi
        ;;
        
    java)
        echo "☕ Detected: Java"
        if ! command -v javac &> /dev/null; then
            echo "❌ Error: Java compiler not installed"
            exit 1
        fi
        
        echo "🔨 Compiling..."
        javac "$FILE"
        if [ $? -ne 0 ]; then
            echo "❌ Compilation failed"
            exit 1
        fi
        
        if [ "$COMPILE_ONLY" = false ]; then
            echo "▶️  Executing..."
            CLASSNAME=$(basename "$BASENAME")
            $TIME_CMD java "$CLASSNAME" $ARGS
            rm -f "${CLASSNAME}.class"
        else
            echo "✅ Compilation successful"
        fi
        ;;
        
    cpp|cc|cxx)
        echo "⚡ Detected: C++"
        if ! command -v g++ &> /dev/null; then
            echo "❌ Error: g++ not installed"
            exit 1
        fi
        
        OUTPUT="${BASENAME}.out"
        echo "🔨 Compiling..."
        g++ -std=c++17 -O2 -Wall "$FILE" -o "$OUTPUT"
        if [ $? -ne 0 ]; then
            echo "❌ Compilation failed"
            exit 1
        fi
        
        if [ "$COMPILE_ONLY" = false ]; then
            echo "▶️  Executing..."
            $TIME_CMD "./$OUTPUT" $ARGS
            rm -f "$OUTPUT"
        else
            echo "✅ Compilation successful: $OUTPUT"
        fi
        ;;
        
    c)
        echo "🔧 Detected: C"
        if ! command -v gcc &> /dev/null; then
            echo "❌ Error: gcc not installed"
            exit 1
        fi
        
        OUTPUT="${BASENAME}.out"
        echo "🔨 Compiling..."
        gcc -std=c11 -O2 -Wall "$FILE" -o "$OUTPUT" -lm
        if [ $? -ne 0 ]; then
            echo "❌ Compilation failed"
            exit 1
        fi
        
        if [ "$COMPILE_ONLY" = false ]; then
            echo "▶️  Executing..."
            $TIME_CMD "./$OUTPUT" $ARGS
            rm -f "$OUTPUT"
        else
            echo "✅ Compilation successful: $OUTPUT"
        fi
        ;;
        
    js)
        echo "📜 Detected: JavaScript"
        if command -v node &> /dev/null; then
            $TIME_CMD node "$FILE" $ARGS
        else
            echo "❌ Error: Node.js not installed"
            exit 1
        fi
        ;;
        
    sh)
        echo "🐚 Detected: Bash Script"
        chmod +x "$FILE"
        $TIME_CMD bash "$FILE" $ARGS
        ;;
        
    go)
        echo "🔷 Detected: Go"
        if ! command -v go &> /dev/null; then
            echo "❌ Error: Go not installed"
            exit 1
        fi
        
        if [ "$COMPILE_ONLY" = true ]; then
            go build "$FILE"
            echo "✅ Compilation successful"
        else
            $TIME_CMD go run "$FILE" $ARGS
        fi
        ;;
        
    rs)
        echo "🦀 Detected: Rust"
        if ! command -v rustc &> /dev/null; then
            echo "❌ Error: Rust not installed"
            exit 1
        fi
        
        OUTPUT="${BASENAME}"
        echo "🔨 Compiling..."
        rustc "$FILE" -o "$OUTPUT"
        if [ $? -ne 0 ]; then
            echo "❌ Compilation failed"
            exit 1
        fi
        
        if [ "$COMPILE_ONLY" = false ]; then
            echo "▶️  Executing..."
            $TIME_CMD "./$OUTPUT" $ARGS
            rm -f "$OUTPUT"
        else
            echo "✅ Compilation successful: $OUTPUT"
        fi
        ;;
        
    *)
        echo "❌ Error: Unsupported file type '.$EXT'"
        echo "Supported: .py, .java, .cpp, .c, .js, .sh, .go, .rs"
        exit 1
        ;;
esac

echo ""
echo "✅ Execution completed!"
