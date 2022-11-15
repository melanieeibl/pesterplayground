function Get-Emoji ( [string]$name ) {
    $filePath = "$PSScriptRoot\GetEmojisResponse.json"

    # $response = $(Invoke-WebRequest -Uri https://emoji-api.com/emojis?access_key=cf001d90d64552bb561601737e9c5a02ee670a32).Content
    # Set-Content -Path $filePath -Value $response

    $response = Get-Content -Path $filePath

    $result = $response | ConvertFrom-Json

    if ($name.Contains("*")) {
        $name.Replace("*", "")
        $emojis = $result | Where-Object { $_.slug -like $name } | Select-Object -Property character
        return $emojis.character
    } else {
        $emoji = $result | Where-Object { $_.slug -eq $name }
        return $emoji.character
    }
}

Get-Emoji
