const branches = [
  "prod",
  "stage",
  "main"
]

let plugins = [
  "@semantic-release/commit-analyzer"
]

if (process.env.CLUTCH_ENV == "prod") {
  changeLog = [
    "@semantic-release/release-notes-generator",
    [
      "@semantic-release/changelog",
      {
        "changelogTitle": "# Changelog",
        "changelogFile": "docs/CHANGELOG.md"
      }
    ],
    [
      "@semantic-release/git",
      {
        "assets": [
          "docs/CHANGELOG.md",
          "package.json",
          "package-lock.json"
        ],
        "message": "chore(release): ${nextRelease.version} [skip ci]\n\n${nextRelease.notes}"
      }
    ],
    [
      "@semantic-release/github",
      {
        "successComment": "This issue has been resolved in version [${nextRelease.version}](<github_release_url>)",
        "releasedLabels": [
          "released"
        ],
        "failComment": false,
        "failTitle": false,
        "addReleases": "top"
      }
    ]
  ]
  plugins = plugins.concat(changeLog);
}

module.exports = {
  repositoryUrl: "https://github.com/nbugden/gh-actions.git",
  tagFormat: `${process.env.CLUTCH_ENV}-\${version}`,
  branches,
  debug: true,
  plugins
}