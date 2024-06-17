# ���݂̃X�N���v�g�̃f�B���N�g���Ɉړ�����
Set-Location $PSScriptRoot

# pip�̃o�[�W�����`�F�b�N�𖳌�������
$Env:PIP_DISABLE_PIP_VERSION_CHECK = 1

# Python�̉��z�����쐬����
if (!(Test-Path -Path "venv")) {
    Write-Output "Creating Python virtual environment..."
    python -m venv venv
}
.\venv\Scripts\Activate

# pip���A�b�v�O���[�h����
Write-Output "pip���A�b�v�O���[�h"
python.exe -m pip install --upgrade pip

# ���|�W�g�����N���[�����ē���̃R�~�b�g�Ƀ`�F�b�N�A�E�g����
git clone --filter=blob:none --no-checkout --sparse https://github.com/lllyasviel/stable-diffusion-webui-forge.git
cd stable-diffusion-webui-forge
git sparse-checkout add javascript ldm_patched localizations modules modules_forge configs extensions-builtin html
git checkout "29be1da7cf2b5dccfc70fbdd33eb35c56a31ffb7"
Remove-Item README.md
Remove-Item LICENSE.txt
Remove-Item CODEOWNERS
Remove-Item CHANGELOG.md
Remove-Item .gitignore
Remove-Item screenshot.png

# ���̃f�B���N�g���Ɉړ�����
cd ..

# stable-diffusion-webui-forge�̓��e����̃f�B���N�g���ɍċA�I�ɃR�s�[����
$sourceDir = "stable-diffusion-webui-forge"
$excludeDirs = @("$sourceDir\.git", "$sourceDir\.github")

Get-ChildItem -Path $sourceDir -Recurse | Where-Object {
    $path = $_.FullName
    -not ($excludeDirs | Where-Object { $path.StartsWith($_) }) -or
    $path.StartsWith("$sourceDir\repositories\.git") -or
    $path.StartsWith("$sourceDir\repositories\.github")
} | ForEach-Object {
    $destPath = $_.FullName.Replace("$sourceDir\", "")
    if (-not $_.PSIsContainer) {
        $destDir = [System.IO.Path]::GetDirectoryName($destPath)
        if (-not (Test-Path $destDir)) {
            New-Item -ItemType Directory -Path $destDir | Out-Null
        }
        Copy-Item -Path $_.FullName -Destination $destPath -Force
    } else {
        if (-not (Test-Path $destPath)) {
            New-Item -ItemType Directory -Path $destPath | Out-Null
        }
    }
}

# stable-diffusion-webui-forge�t�H���_���폜����
Remove-Item -Path "stable-diffusion-webui-forge" -Recurse -Force

# Line2Normalmap_setup.py�����s����
python .\AI_Assistant_setup.py

# AI-Assistantl_DL.cmd�����s����
.\AI_Assistant_model_DL.cmd

# webui-user.bat�����s����
.\webui-user.bat

Write-Output "�C���X�g�[������"
Read-Host -Prompt "Press Enter to exit"
