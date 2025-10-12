#!/bin/bash
# devenv - Development environment manager
# Author: WLUG Custom Commands
# Description: Quick setup and management of development environments and tools

# Function to display usage
usage() {
    echo "Usage: devenv [COMMAND] [OPTIONS]"
    echo ""
    echo "Manage development environment setup and tools"
    echo ""
    echo "Commands:"
    echo "  check          Check installed development tools and versions"
    echo "  setup <type>   Setup environment (python|node|java|cpp|web)"
    echo "  update         Update common development tools"
    echo "  clean          Clean temporary files and caches"
    echo "  versions       Show versions of all installed dev tools"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo ""
    echo "Examples:"
    echo "  devenv check"
    echo "  devenv setup python"
    echo "  devenv versions"
    exit 1
}

# Check for help flag
if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ -z "$1" ]; then
    usage
fi

COMMAND=$1
shift

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check tool version
check_tool() {
    local tool=$1
    local version_flag=$2

    if command_exists "$tool"; then
        version=$($tool $version_flag 2>&1 | head -n 1)
        echo "✅ $tool: $version"
    else
        echo "❌ $tool: Not installed"
    fi
}

# Check development tools
check_devtools() {
    echo "🔍 Checking Development Environment..."
    echo "======================================"
    echo ""

    echo "📦 Package Managers:"
    check_tool "apt" "--version"
    check_tool "npm" "--version"
    check_tool "pip" "--version"
    check_tool "pip3" "--version"
    echo ""

    echo "💻 Programming Languages:"
    check_tool "python" "--version"
    check_tool "python3" "--version"
    check_tool "node" "--version"
    check_tool "java" "-version"
    check_tool "javac" "-version"
    check_tool "gcc" "--version"
    check_tool "g++" "--version"
    echo ""

    echo "🔧 Development Tools:"
    check_tool "git" "--version"
    check_tool "docker" "--version"
    check_tool "code" "--version"
    check_tool "vim" "--version"
    check_tool "make" "--version"
    echo ""

    echo "🌐 Web Tools:"
    check_tool "curl" "--version"
    check_tool "wget" "--version"
    check_tool "nginx" "-v"
    echo ""
}

# Setup environment for specific language
setup_environment() {
    local env_type=$1

    echo "🚀 Setting up $env_type development environment..."
    echo "======================================"
    echo ""

    case $env_type in
        python)
            echo "📦 Installing Python development tools..."
            if command_exists apt; then
                sudo apt update
                sudo apt install -y python3 python3-pip python3-venv
                pip3 install --upgrade pip
                pip3 install virtualenv pylint black pytest
            fi
            echo "✅ Python environment setup complete"
            ;;

        node)
            echo "📦 Installing Node.js development tools..."
            if command_exists apt; then
                curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
                sudo apt install -y nodejs
                npm install -g npm@latest
                npm install -g nodemon eslint prettier
            fi
            echo "✅ Node.js environment setup complete"
            ;;

        java)
            echo "📦 Installing Java development tools..."
            if command_exists apt; then
                sudo apt update
                sudo apt install -y default-jdk maven gradle
            fi
            echo "✅ Java environment setup complete"
            ;;

        cpp)
            echo "📦 Installing C++ development tools..."
            if command_exists apt; then
                sudo apt update
                sudo apt install -y build-essential gdb cmake
            fi
            echo "✅ C++ environment setup complete"
            ;;

        web)
            echo "📦 Installing Web development tools..."
            if command_exists apt; then
                sudo apt update
                sudo apt install -y nodejs npm
                npm install -g live-server webpack webpack-cli
            fi
            echo "✅ Web environment setup complete"
            ;;

        *)
            echo "❌ Error: Unknown environment type '$env_type'"
            echo "Supported types: python, node, java, cpp, web"
            exit 1
            ;;
    esac

    echo ""
    echo "🎉 Setup completed!"
}

# Update development tools
update_tools() {
    echo "🔄 Updating development tools..."
    echo "======================================"
    echo ""

    if command_exists apt; then
        echo "📦 Updating system packages..."
        sudo apt update && sudo apt upgrade -y
    fi

    if command_exists npm; then
        echo "📦 Updating npm..."
        npm update -g
    fi

    if command_exists pip3; then
        echo "📦 Updating pip..."
        pip3 install --upgrade pip
    fi

    echo ""
    echo "✅ Update complete!"
}

# Clean temporary files and caches
clean_env() {
    echo "🧹 Cleaning development environment..."
    echo "======================================"
    echo ""

    # Python cache
    if command_exists python3; then
        echo "🗑️  Cleaning Python cache..."
        find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null
        find . -type f -name "*.pyc" -delete 2>/dev/null
        echo "✅ Python cache cleaned"
    fi

    # Node modules (not in node_modules folders)
    if command_exists npm; then
        echo "🗑️  Cleaning npm cache..."
        npm cache clean --force
        echo "✅ npm cache cleaned"
    fi

    # Maven cache
    if command_exists mvn; then
        echo "🗑️  Cleaning Maven target directories..."
        find . -type d -name "target" -exec rm -rf {} + 2>/dev/null
        echo "✅ Maven cache cleaned"
    fi

    # Build artifacts
    echo "🗑️  Cleaning build artifacts..."
    find . -type f -name "*.o" -delete 2>/dev/null
    find . -type f -name "*.out" -delete 2>/dev/null
    find . -type f -name "*.class" -delete 2>/dev/null

    # Docker cleanup (if installed)
    if command_exists docker; then
        echo "🗑️  Cleaning Docker unused resources..."
        docker system prune -f
        echo "✅ Docker cleanup complete"
    fi

    echo ""
    echo "✅ Environment cleanup complete!"
}

# Show versions
show_versions() {
    echo "📋 Development Tools Versions"
    echo "======================================"
    echo ""
    check_devtools
}

# Execute command
case $COMMAND in
    check)
        check_devtools
        ;;
    setup)
        if [ -z "$1" ]; then
            echo "❌ Error: Environment type required"
            echo "Usage: devenv setup <type>"
            exit 1
        fi
        setup_environment "$1"
        ;;
    update)
        update_tools
        ;;
    clean)
        clean_env
        ;;
    versions)
        show_versions
        ;;
    *)
        echo "❌ Error: Unknown command '$COMMAND'"
        usage
        ;;
esac
