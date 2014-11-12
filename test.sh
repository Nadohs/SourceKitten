#!/bin/sh

CURRENT_PATH=$(pwd)

sh install.sh

# Test Syntax Text

syntax_text_result="$(sourcekitten --syntax-text 'import Foundation // Hello World!')"
syntax_text_expected="$(cat tests/syntax_text.json)"
if [ "$syntax_text_result" == "$syntax_text_expected" ]; then
    echo "syntax_text passed"
else
    echo "syntax_text failed"
    echo "$syntax_text_result"
    exit 1
fi

# Test Syntax

echo 'import Foundation // Hello World' > syntax.swift
syntax_result="$(sourcekitten --syntax ${CURRENT_PATH}/syntax.swift)"
if [ "$syntax_result" == "$syntax_text_expected" ]; then
    echo "syntax passed"
else
    echo "syntax failed"
    echo "$syntax_result"
    exit 1
fi
rm syntax.swift

# Test Structure

echo 'class MyClass { var variable = 0 }' > structure.swift
structure_result="$(sourcekitten --structure ${CURRENT_PATH}/structure.swift | jsonlint -s)"
structure_expected="$(cat tests/structure.json | jsonlint -s)"
if [ "$structure_result" == "$structure_expected" ]; then
    echo "structure passed"
else
    echo "structure failed"
    echo "$structure_result"
    exit 1
fi
rm structure.swift

# Test Bicycle

bicycle_result="$(sourcekitten --single-file ${CURRENT_PATH}/tests/Bicycle.swift -j4 ${CURRENT_PATH}/tests/Bicycle.swift | jsonlint -s)"
bicycle_expected="$(cat tests/Bicycle.json | jsonlint -s)"
if [ "$bicycle_result" == "$bicycle_expected" ]; then
    echo "bicycle passed"
else
    echo "bicycle failed"
    echo "$bicycle_result"
    exit 1
fi