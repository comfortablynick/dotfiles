function getignore --description 'Get ignore file from gitignore.io'
    curl -SsL https://www.gitignore.io/api/$argv 2>/dev/null
end
