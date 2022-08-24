const FS = require("fs");
const Path = require("path");
const Subprocess = require("child_process");

const CWD = __dirname;
const PKG = CWD;

const Copy = (source, target, debug = false) => {
    (debug) && console.log("[Debug] Source", source);
    (debug) && console.log("   -> Target", target);

    try {
        FS.mkdirSync( target, { recursive: true } );
    } catch ( e ) {}
    FS.readdirSync( source, { withFileTypes: true } ).forEach( (element) => {
        const Directory = element?.isDirectory() || false;
        const Link = element?.isSymbolicLink() || false;
        const Socket = element?.isSocket() || false;
        const File = element?.isFile() || false;

        try {
            if ( Directory ) {
                Copy( Path.join(source, element.name), Path.join( target, element.name ) );
            } else {
                FS.copyFileSync( Path.join( source, element.name ), Path.join( target, element.name ), FS.constants.COPYFILE_EXCL | FS.constants.COPYFILE_FICLONE );
            }
        } catch ( e ) {}
    } );
};

Subprocess.execSync("npm install --silent", {
    stdio: "ignore", cwd: PKG, env: process.env
});

Copy(Path.join(PKG, "node_modules"), Path.join(PKG, "layer/nodejs/node_modules"));

process.stdout.write(JSON.stringify({
    "Successful": "True"
}));