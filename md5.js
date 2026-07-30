// convert plain text password to 32bit MD5 encrypted hexadecimal to be used in FutuOpenD.xml
// usage: node md5.js "your_password_here"

const crypto = require('crypto')

function md5Hex32 (str) {
  return crypto.createHash('md5').update(String(str), 'utf8').digest('hex') // 32 hex chars
}

// Example:
const password = process.argv[2] || 'your_password_here'
console.log(md5Hex32(password))
