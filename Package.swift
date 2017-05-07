import PackageDescription

let package = Package(
	name: "PerfectTemplate",
	targets: [],
	dependencies: [
		.Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2, minor: 0),
		.Package(url: "https://github.com/PerfectlySoft/Perfect-Mustache.git", majorVersion:2),
		.Package(url:"https://github.com/PerfectlySoft/Perfect-MariaDB.git", majorVersion: 2, minor: 0)
    ]
)
