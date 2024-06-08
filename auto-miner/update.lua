-- Specify the GitHub directory URL here
local githubURL = "https://github.com/LuunaVR/ftb-presents-fam-cc-scripts/tree/main/auto-miner"
 
-- Extract user, repository, branch, and directory path from the URL
local githubUser, repoName, branchName, dirPath = string.match(githubURL, "https?://github.com/(.-)/(.-)/tree/(.-)/(.+)")
 
local function getGitHubFileList()
    local apiUrl = string.format("https://api.github.com/repos/%s/%s/contents/%s?ref=%s", githubUser, repoName, dirPath, branchName)
    local response = http.get(apiUrl)
    if not response then
        print("Failed to connect to GitHub API")
        return {}
    end
 
    local files = {}
    local result = textutils.unserializeJSON(response.readAll())
    response.close()
 
    for _, file in ipairs(result) do
        if file.type == "file" then
            table.insert(files, file.path)
        end
    end
 
    return files
end
 
local function deleteExistingFiles(files)
    for _, file in ipairs(files) do
        local filename = file:gsub("%.lua$", "")
        filename = fs.getName(filename)
        if fs.exists(filename) then
            fs.delete(filename)
            print("Deleted existing file: " .. filename)
        end
    end
end
 
local function downloadFiles(files)
    for _, path in ipairs(files) do
        local filename = fs.getName(path)
        filename = filename:gsub("%.lua$", "")
        local url = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", githubUser, repoName, branchName, path)
        local request = http.get(url)
        if request then
            local response = request.readAll()
            local fileHandle = fs.open(filename, "w")
            fileHandle.write(response)
            fileHandle.close()
            print("Downloaded and saved: " .. filename)
        else
            print("Failed to download: " .. filename)
        end
    end
end
 
local function main()
    local files = getGitHubFileList()
    if #files > 0 then
        deleteExistingFiles(files)
        downloadFiles(files)
    else
        print("No files to download.")
    end
end
 
main()
