const { spawnSync } = require("child_process");
const { platform } = process;
const { existsSync, chmodSync } = require("fs");
const { join } = require("path");

function makeExecutable(filePath) {
  try {
    chmodSync(filePath, "755");
  } catch (err) {
    console.error(`Failed to make ${filePath} executable:`, err);
  }
}

function runBuildScript() {
  const isWindows = platform === "win32";
  const scriptName = isWindows ? "build-portaudio.bat" : "build-portaudio.sh";
  const scriptPath = join(__dirname, scriptName);

  // Make shell script executable on Unix systems
  if (!isWindows) {
    makeExecutable(scriptPath);
  }

  // On Windows, ensure we're using the correct shell
  const options = {
    stdio: "inherit",
    shell: isWindows ? true : "/bin/bash",
  };

  // Run the appropriate build script
  const result = spawnSync(isWindows ? scriptPath : scriptPath, [], options);

  if (result.error) {
    console.error("Failed to run build script:", result.error);
    process.exit(1);
  }

  if (result.status !== 0) {
    console.error(`Build script failed with status ${result.status}`);
    process.exit(result.status);
  }
}

runBuildScript();
