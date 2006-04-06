function decodeURLWithAmp(str) {
str = str.replace(/&amp;/g, "&");          
return str;
}

function decodeChars(str) {
str = str.replace(/&lt;/g, "<");          
str = str.replace(/&gt;/g, ">");
return str;
}