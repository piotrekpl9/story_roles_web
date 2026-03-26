const http = require('http');
const httpProxy = require('http-proxy');

const TARGET = 'https://api.storyroles.com';
const PORT = 8080;

const proxy = httpProxy.createProxyServer({
  target: TARGET,
  changeOrigin: true,
  secure: true,
});

proxy.on('error', (err, req, res) => {
  console.error('Proxy error:', err.message);
  res.writeHead(502, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify({ error: 'Proxy error', message: err.message }));
});

proxy.on('proxyRes', (proxyRes) => {
  proxyRes.headers['access-control-allow-origin'] = '*';
  proxyRes.headers['access-control-allow-methods'] = 'GET, POST, PUT, DELETE, OPTIONS, PATCH';
  proxyRes.headers['access-control-allow-headers'] = 'Authorization, Content-Type, Accept';
  proxyRes.headers['access-control-allow-credentials'] = 'true';
});

const server = http.createServer((req, res) => {
  if (req.method === 'OPTIONS') {
    res.writeHead(204, {
      'access-control-allow-origin': '*',
      'access-control-allow-methods': 'GET, POST, PUT, DELETE, OPTIONS, PATCH',
      'access-control-allow-headers': 'Authorization, Content-Type, Accept',
      'access-control-allow-credentials': 'true',
      'access-control-max-age': '86400',
    });
    res.end();
    return;
  }

  console.log(`${req.method} ${req.url}`);
  proxy.web(req, res);
});

server.listen(PORT, () => {
  console.log(`Dev proxy running on http://localhost:${PORT}`);
  console.log(`Forwarding to: ${TARGET}`);
});
