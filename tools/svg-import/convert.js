var parse = require('xml-parser');
var argv = process.argv;
var fs = require('fs');
var spawn = require('child_process').spawn;


var scaleFactor = 0.5;


function parsePolygonNode(child, solids, dangers) {
  var svgString = child.attributes.points;

  var colorString = child.attributes.fill;
  var redHex = colorString.substr(1, 2);
  var greenHex = colorString.substr(3, 2);
  var blueHex = colorString.substr(5, 2);
  var r = parseInt(redHex, 16);
  var g = parseInt(greenHex, 16);
  var b = parseInt(blueHex, 16);

  var svgString = svgString.replace(/(\r\n|\n|\r)/gm, ' ').replace(/\t/gm, ' ').replace(/\s+/gm, ' ').trim();
  var pointPairs = svgString.split(' ')


  var points = [];
  pointPairs.forEach(function (pair) {
    var coords = pair.split(',');
    points.push({x: parseFloat(coords[0]) * scaleFactor, y: -parseFloat(coords[1]) * scaleFactor});
  });
  
  if (g > r) {
    solids.push(points);
  } else {
    dangers.push(points);
  }
}

function parseTextNode(node, output) {
  var content = node.content;
  var transform = node.attributes.transform;
  var numberRegexString = '(\\-?[0-9]+(?:\\.[0-9]+)?)\\s?';
  var regexString = 'matrix\\(';

  for (var i = 0; i < 6; i++) {
    regexString += numberRegexString
  }

  regexString += '\\)';
  
  var regex = new RegExp(regexString);
  var result = regex.exec(transform)
  
  var x = parseFloat(result[5]) * scaleFactor;
  var y = -parseFloat(result[6]) * scaleFactor;
  
  if (content) {
    if (content === 'goal') {
      output.goal = {x: x, y: y};
    } else {
      output.buttons.push({button: content, x: x, y: y});
    }
  } else {
    var spawnButtons = [];
    node.children.forEach(function (child) {
      if (child.content !== 'spawn') {
        spawnButtons.push(child.content);
      }
    });
    output.spawn = {x: x, y: y, buttons: spawnButtons};
  }
}

function formatWithFilter(node, filter) {
  if (!filter(node)) {
    return '';
  }
  var string = '<' + node.name;
  Object.keys(node.attributes).forEach(function (attr) {
    var val = node.attributes[attr];
    string += ' ' + attr + '="' + val + '"';
  });
  string += '>'
  
  node.children.forEach(function (child) {
    string += formatWithFilter(child, filter);
  });

  string += '</' + node.name + '>'
  return string;
}


var filename = process.argv[2];

// Exit if file is not specified.
if (!filename) {
  console.log('usage: convert <filename without .svg>');
  return;
}

var xml = fs.readFileSync(filename + '.svg', 'utf8');
var start = xml.indexOf('<svg')

var tree = parse(xml.substr(start));


var output = {
  solids: [],
  dangers: [],
  buttons: [],
  foregrounds: [],
  backgrounds: []
};


var backgroundSvg = xml.substr(0, start);
var foregroundSvg = xml.substr(0, start);



backgroundSvg += formatWithFilter(tree.root, function (node) {
  var id = node.attributes['id']
  return id != 'foreground' && id != 'world';
});

foregroundSvg += formatWithFilter(tree.root, function (node) {
  var id = node.attributes['id']
  return id != 'background' && id != 'world';
});

tree.root.children.forEach(function (child, k) {
  if (child.attributes['id'] == 'world') {
    child.children.forEach(function (child, k) {
      
      if (child.name === 'polygon' || child.name === 'polyline') {
        parsePolygonNode(child, output.solids, output.dangers);
      }
      
      if (child.name === 'text') {
        parseTextNode(child, output);
      }
    });
  }
});

var width = parseFloat(tree.root.attributes.width);
var height = parseFloat(tree.root.attributes.height);
var tileSize = 1024;

try {fs.mkdirSync(filename);} catch(e) {};


var nCols = Math.ceil(width / tileSize);
var nRows = Math.ceil(height/ tileSize);
var id = 0;
  for (var row = 0; row < nRows; row++) {
    for (var col = 0; col < nCols; col++) {
    var offsetX = col * tileSize * scaleFactor;
    var offsetY = - row * tileSize * scaleFactor;

    output.foregrounds.push({
      x: offsetX,
      y: offsetY,
      src: 'foreground' + id + '.png'
    });

    output.backgrounds.push({
      x: offsetX,
      y: offsetY,
      src: 'background' + id + '.png'
    });
    id++;
  }
}


var levelJson = JSON.stringify(output);
fs.writeFileSync(filename + '/level.json', levelJson, 'utf8');

var fgSvgName = filename + '/foreground.svg';
var bgSvgName = filename + '/background.svg';

fs.writeFileSync(fgSvgName, foregroundSvg, 'utf8');
fs.writeFileSync(bgSvgName, backgroundSvg, 'utf8');

var fgPngName = filename + '/foreground%d.png';
var bgPngName = filename + '/background%d.png';



var svg_to_png = require('svg-to-png');

svg_to_png.convert(fgSvgName, filename, {
  defaultWidth: width,
  defaultHeight: height
}) // async, returns promise
.then( function(){
  // Do tons of stuff
  spawn('convert', ['-crop', tileSize + 'x' + tileSize, filename + '/foreground.png', fgPngName])

});


svg_to_png.convert(bgSvgName, filename, {
  defaultWidth: width,
  defaultHeight: height
}) // async, returns promise
.then( function(){
  // Do tons of stuff
  spawn('convert', ['-crop', tileSize + 'x' + tileSize, filename + '/background.png', bgPngName]);
});






//spawn('convert', ['-antialias', '-background', 'none', '-density', 72 * superSampling, '-crop', tileSize + 'x' + tileSize, fgSvgName, fgPngName]);
//spawn('convert', ['-antialias', '-background', 'none', '-density', 72 * superSampling, '-crop', tileSize + 'x' + tileSize, bgSvgName, bgPngName]);


