[CmdletBinding()]
param(
    [string]$ContainerName = 'sim-postgres',
    [string]$Image = 'postgres:15',
    [string]$VolumeName = 'sim-postgres-data',
    [int]$HostPort = 5432,
    [string]$SeedWorkbook = 'scripts/seed.xlsx'
)

$ErrorActionPreference = 'Stop'
$root = Resolve-Path (Join-Path $PSScriptRoot '..')
Set-Location $root

function Assert-DockerAvailable {
    if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
        throw 'Docker CLI not found. Install Docker Desktop or Docker Engine before running this script.'
    }

    try {
        docker info | Out-Null
    } catch {
        throw 'Docker daemon is not running or inaccessible. Start Docker Desktop and try again.'
    }
}

$envDefaults = @{
    DB_HOST = 'localhost'
    DB_PORT = "$HostPort"
    DB_NAME = 'skills_inventory'
    DB_USER = 'sim_user'
    DB_PASSWORD = 'SimP@ssw0rd'
}

$backendEnvPath = Join-Path $root 'backend/.env'
if (-not (Test-Path $backendEnvPath)) {
    Write-Host "Creating backend/.env with default credentials"
    "DB_HOST=$($envDefaults.DB_HOST)" | Out-File $backendEnvPath -Encoding ASCII
    "DB_PORT=$($envDefaults.DB_PORT)" | Out-File $backendEnvPath -Append -Encoding ASCII
    "DB_NAME=$($envDefaults.DB_NAME)" | Out-File $backendEnvPath -Append -Encoding ASCII
    "DB_USER=$($envDefaults.DB_USER)" | Out-File $backendEnvPath -Append -Encoding ASCII
    "DB_PASSWORD=$($envDefaults.DB_PASSWORD)" | Out-File $backendEnvPath -Append -Encoding ASCII
    "JWT_SECRET=super-secret-key" | Out-File $backendEnvPath -Append -Encoding ASCII
}

Assert-DockerAvailable

Write-Host "Pulling Postgres image '$Image'..."
docker pull $Image | Out-Null

if ((docker ps -a --format '{{.Names}}' | Where-Object { $_ -eq $ContainerName })) {
    Write-Host "Removing existing container '$ContainerName'"
    docker rm -f $ContainerName | Out-Null
}

if (-not (docker volume ls --format '{{.Name}}' | Where-Object { $_ -eq $VolumeName })) {
    Write-Host "Creating docker volume '$VolumeName'"
    docker volume create $VolumeName | Out-Null
}

Write-Host "Starting Postgres container..."
docker run -d --name $ContainerName `
    -e POSTGRES_USER=$($envDefaults.DB_USER) `
    -e POSTGRES_PASSWORD=$($envDefaults.DB_PASSWORD) `
    -e POSTGRES_DB=$($envDefaults.DB_NAME) `
    -v "$VolumeName:/var/lib/postgresql/data" `
    -p "$HostPort:5432" `
    $Image | Out-Null

Write-Host 'Waiting for Postgres to accept connections...'
$ready = $false
for ($i = 0; $i -lt 30; $i++) {
    $result = docker exec $ContainerName pg_isready -U $($envDefaults.DB_USER) -d $($envDefaults.DB_NAME) 2>$null
    if ($LASTEXITCODE -eq 0) {
        $ready = $true
        break
    }
    Start-Sleep -Seconds 2
}
if (-not $ready) {
    throw 'Postgres did not become ready in time.'
}

$python = Get-Command python -ErrorAction Stop
pip show pandas | Out-Null 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host 'Installing Python dependencies (pandas, psycopg2-binary, python-dotenv, openpyxl)...'
    pip install pandas psycopg2-binary python-dotenv openpyxl | Out-Null
}

Write-Host 'Seeding base tables from Excel workbook...'
python scripts/xlsxtoDB.py $SeedWorkbook

Write-Host 'Assigning randomized employee skills...'
python scripts/assign_random_skills.py --min-skills 3 --max-skills 7 --truncate

Write-Host 'Assigning randomized team focus priorities...'
python scripts/randomize_team_focus.py --min-per-team 2 --max-per-team 4 --truncate

Write-Host 'Environment bootstrap completed.'
