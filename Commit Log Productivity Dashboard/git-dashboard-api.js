/*
 * Git Activity Dashboard - JavaScript Backend Bridge
 * Copyright 2025 Kyle J. Coder
 * Licensed under the Apache License, Version 2.0
 */

class GitActivityAPI {
    constructor() {
        this.repoPath = this.detectRepoPath();
        this.dataFile = 'git-activity-data.json';
        this.lastUpdate = null;
    }

    detectRepoPath() {
        // Get current page URL and derive repo path
        const currentPath = window.location.pathname;
        // Remove the dashboard folder and file from path to get repo root
        const repoDir = currentPath.replace(/\/Commit Log Productivity Dashboard\/git-activity-dashboard\.html$/, '')
            .replace(/\\Commit Log Productivity Dashboard\\git-activity-dashboard\.html$/, '');
        return repoDir;
    } async executeGitCommand(startDate, endDate) {
        try {
            // Create PowerShell command to execute our script (relative to dashboard location)
            const command = `powershell.exe -ExecutionPolicy Bypass -File ".\\Get-GitActivity.ps1" -StartDate "${startDate}" -EndDate "${endDate}" -OutputFormat "json"`;

            // In a real browser environment, this would need to be handled differently
            // For now, we'll simulate the call and provide instructions
            console.log('Executing:', command);

            // Show user what's happening
            this.showExecutionStatus(startDate, endDate);

            // Try to load existing data file or use fallback
            return await this.loadDataFile();

        } catch (error) {
            console.error('Error executing git command:', error);
            throw error;
        }
    }

    async loadDataFile() {
        try {
            // Try to load the JSON data file created by PowerShell script
            const response = await fetch(this.dataFile);
            if (response.ok) {
                const data = await response.json();
                this.lastUpdate = new Date();
                return data;
            }
        } catch (error) {
            console.log('Data file not found, using demo data');
        }

        // Fallback to demo data if file doesn't exist
        return this.getDemoData();
    } showExecutionStatus(startDate, endDate) {
        const statusDiv = document.createElement('div');
        statusDiv.className = 'note';
        statusDiv.innerHTML = `
            <strong>🔄 Executing Git Analysis...</strong><br>
            <code>Get-GitActivity.ps1 -StartDate "${startDate}" -EndDate "${endDate}"</code><br><br>
            <strong>📋 To enable real-time data:</strong><br>
            1. Open PowerShell in the "Commit Log Productivity Dashboard" folder<br>
            2. Run: <code>.\\Get-GitActivity.ps1 -StartDate "${startDate}" -EndDate "${endDate}"</code><br>
            3. Refresh this page to see live data<br><br>
            <strong>📁 Or use the launcher:</strong> Double-click <code>Launch-Git-Dashboard.bat</code><br><br>
            <em>Currently showing demo data below...</em>
        `;

        const resultsDiv = document.getElementById('results');
        resultsDiv.insertBefore(statusDiv, resultsDiv.firstChild);
    }

    getDemoData() {
        // Generate realistic demo data based on current date range
        const today = new Date();
        const commits = [];

        // Create sample commits for demonstration
        for (let i = 0; i < 5; i++) {
            const commitDate = new Date(today.getTime() - (i * 24 * 60 * 60 * 1000));
            commits.push({
                hash: this.generateRandomHash(),
                fullHash: this.generateRandomHash(40),
                author: 'Kyle J. Coder',
                email: 'kyle.coder@va.gov',
                date: commitDate.toISOString(),
                message: this.getSampleCommitMessage(i),
                filesChanged: Math.floor(Math.random() * 10) + 1,
                linesAdded: Math.floor(Math.random() * 500) + 50,
                linesRemoved: Math.floor(Math.random() * 100) + 5
            });
        }

        const totalCommits = commits.length;
        const totalFiles = commits.reduce((sum, c) => sum + c.filesChanged, 0);
        const totalAdded = commits.reduce((sum, c) => sum + c.linesAdded, 0);
        const totalRemoved = commits.reduce((sum, c) => sum + c.linesRemoved, 0);
        const productivityScore = Math.min(100, Math.round((totalCommits * 10) + (totalAdded / 100)));

        return {
            summary: {
                totalCommits,
                filesChanged: totalFiles,
                linesAdded: totalAdded,
                linesRemoved: totalRemoved,
                productivityScore,
                dateRange: "Demo Data",
                generatedAt: new Date().toISOString()
            },
            commits: commits.sort((a, b) => new Date(b.date) - new Date(a.date))
        };
    }

    generateRandomHash(length = 7) {
        const chars = '0123456789abcdef';
        let result = '';
        for (let i = 0; i < length; i++) {
            result += chars.charAt(Math.floor(Math.random() * chars.length));
        }
        return result;
    }

    getSampleCommitMessage(index) {
        const messages = [
            'feat: implement HTML dashboard for git activity reporting',
            'docs: update user documentation and workflow guides',
            'refactor: optimize PowerShell script performance',
            'fix: resolve date range filtering issues',
            'feat: add export functionality for management reports',
            'style: improve dashboard UI/UX and responsiveness',
            'test: add comprehensive validation for git data parsing'
        ];
        return messages[index % messages.length];
    }

    async refreshData(startDate, endDate) {
        try {
            console.log(`Refreshing data for ${startDate} to ${endDate}`);
            return await this.executeGitCommand(startDate, endDate);
        } catch (error) {
            console.error('Error refreshing data:', error);
            return this.getDemoData();
        }
    }

    getLastUpdateTime() {
        return this.lastUpdate ? this.lastUpdate.toLocaleString() : 'Never';
    }

    async exportData(data, format = 'json') {
        const timestamp = new Date().toISOString().slice(0, 19).replace(/:/g, '-');
        const filename = `git-activity-export-${timestamp}`;

        switch (format.toLowerCase()) {
            case 'json':
                this.downloadFile(JSON.stringify(data, null, 2), `${filename}.json`, 'application/json');
                break;
            case 'csv':
                const csv = this.convertToCSV(data.commits);
                this.downloadFile(csv, `${filename}.csv`, 'text/csv');
                break;
            case 'html':
                const html = this.generateHTMLReport(data);
                this.downloadFile(html, `${filename}.html`, 'text/html');
                break;
            default:
                throw new Error(`Unsupported format: ${format}`);
        }
    }

    convertToCSV(commits) {
        const headers = ['Hash', 'Author', 'Date', 'Message', 'Files Changed', 'Lines Added', 'Lines Removed'];
        const rows = commits.map(commit => [
            commit.hash,
            commit.author,
            commit.date,
            `"${commit.message.replace(/"/g, '""')}"`,
            commit.filesChanged,
            commit.linesAdded,
            commit.linesRemoved
        ]);

        return [headers, ...rows].map(row => row.join(',')).join('\n');
    }

    generateHTMLReport(data) {
        const summary = data.summary;
        const commits = data.commits;

        const commitRows = commits.map(commit => `
            <tr>
                <td style="font-family: monospace; background: #f8f9fa;">${commit.hash}</td>
                <td>${new Date(commit.date).toLocaleString()}</td>
                <td>${commit.message}</td>
                <td style="text-align: center;">${commit.filesChanged}</td>
                <td style="text-align: center; color: green;">+${commit.linesAdded}</td>
                <td style="text-align: center; color: red;">-${commit.linesRemoved}</td>
            </tr>
        `).join('');

        return `
<!DOCTYPE html>
<html>
<head>
    <title>Git Activity Report - ${summary.dateRange}</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
        .container { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { text-align: center; margin-bottom: 30px; }
        .summary { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .card { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; border-radius: 8px; text-align: center; }
        .card h3 { font-size: 2rem; margin: 0; }
        .card p { margin: 5px 0 0 0; opacity: 0.9; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #f8f9fa; font-weight: 600; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🚀 Git Activity Report</h1>
            <p>Generated: ${summary.generatedAt} | Range: ${summary.dateRange}</p>
        </div>

        <div class="summary">
            <div class="card">
                <h3>${summary.totalCommits}</h3>
                <p>Total Commits</p>
            </div>
            <div class="card">
                <h3>${summary.filesChanged}</h3>
                <p>Files Changed</p>
            </div>
            <div class="card">
                <h3>+${summary.linesAdded}</h3>
                <p>Lines Added</p>
            </div>
            <div class="card">
                <h3>${summary.productivityScore}%</h3>
                <p>Productivity Score</p>
            </div>
        </div>

        <h2>📝 Detailed Commit History</h2>
        <table>
            <thead>
                <tr>
                    <th>Hash</th>
                    <th>Date</th>
                    <th>Message</th>
                    <th>Files</th>
                    <th>Added</th>
                    <th>Removed</th>
                </tr>
            </thead>
            <tbody>
                ${commitRows}
            </tbody>
        </table>
    </div>
</body>
</html>
        `;
    }

    downloadFile(content, filename, mimeType) {
        const blob = new Blob([content], { type: mimeType });
        const url = URL.createObjectURL(blob);
        const link = document.createElement('a');
        link.href = url;
        link.download = filename;
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        URL.revokeObjectURL(url);
    }
}

// Global API instance
window.gitAPI = new GitActivityAPI();
