const http = require('http');
const fs = require('fs');
const path = require('path');

const root = __dirname;
const port = 4173;

const mimeTypes = {
  '.css': 'text/css; charset=utf-8',
  '.html': 'text/html; charset=utf-8',
  '.ico': 'image/x-icon',
  '.jpeg': 'image/jpeg',
  '.jpg': 'image/jpeg',
  '.js': 'application/javascript; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.png': 'image/png',
  '.svg': 'image/svg+xml',
  '.webp': 'image/webp',
};

function resolvePath(urlPath) {
  const requestPath = decodeURIComponent((urlPath || '/').split('?')[0]);
  const normalized = path.normalize(requestPath).replace(/^([\\/])+/, '');
  return requestPath === '/'
    ? path.join(root, 'index.html')
    : path.join(root, normalized);
}

const server = http.createServer((req, res) => {
  let filePath = resolvePath(req.url);

  fs.stat(filePath, (statErr, stats) => {
    if (!statErr && stats.isDirectory()) {
      filePath = path.join(filePath, 'index.html');
    }

    fs.readFile(filePath, (readErr, data) => {
      if (readErr) {
        res.writeHead(404, { 'Content-Type': 'text/plain; charset=utf-8' });
        res.end('Not Found');
        return;
      }

      const ext = path.extname(filePath).toLowerCase();
      res.writeHead(200, {
        'Content-Type': mimeTypes[ext] || 'application/octet-stream',
      });
      res.end(data);
    });
  });
});

server.listen(port, '127.0.0.1', () => {
  console.log(`SkillNode local server running at http://127.0.0.1:${port}`);
});
