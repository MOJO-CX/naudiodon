const portAudio = require('../');

// List all audio devices
console.log('\nAudio Devices:');
const devices = portAudio.getDevices();
devices.forEach((device, index) => {
    console.log(`[${index}] ${device.name}`);
    console.log(`    Input channels: ${device.maxInputChannels}`);
    console.log(`    Output channels: ${device.maxOutputChannels}`);
    console.log(`    Default sample rate: ${device.defaultSampleRate}`);
});

// List audio host APIs
console.log('\nHost APIs:');
const apis = portAudio.getHostAPIs();
console.log(`Default Host API: ${apis.defaultHostAPI}`);

apis.HostAPIs.forEach(api => {
    console.log(`\n[${api.id}] ${api.name} (${api.type})`);
    console.log(`    Device count: ${api.deviceCount}`);
    console.log(`    Default input: ${api.defaultInput === 4294967295 ? 'None' : api.defaultInput}`);
    console.log(`    Default output: ${api.defaultOutput === 4294967295 ? 'None' : api.defaultOutput}`);
}); 