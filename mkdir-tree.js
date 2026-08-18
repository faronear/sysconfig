const fs = require('fs');
const path = require('path');

const letters = 'abcdefghijklmnopqrstuvwxyz'.split('');

const wordsByLetter = {
  a: ['almond', 'amber', 'apricot', 'atlas', 'aurora', 'avocado', 'alpine', 'amethyst', 'anchor', 'aspen'],
  b: ['bamboo', 'beacon', 'berry', 'blossom', 'brisk', 'brook', 'bison', 'butter', 'breeze', 'birch'],
  c: ['cabin', 'canyon', 'cedar', 'cinder', 'clover', 'copper', 'coral', 'crimson', 'cumulus', 'currant'],
  d: ['daisy', 'delta', 'dune', 'drift', 'dolphin', 'dream', 'durian', 'dewdrop', 'dandelion', 'dynamo'],
  e: ['elm', 'ember', 'echo', 'everest', 'eclipse', 'enigma', 'estate', 'eagle', 'elder', 'emerald'],
  f: ['falcon', 'fern', 'fig', 'flame', 'forest', 'frost', 'fable', 'fairy', 'fjord', 'fusion'],
  g: ['garland', 'gem', 'ginger', 'glacier', 'granite', 'grove', 'garnet', 'grape', 'gull', 'galaxy'],
  h: ['harbor', 'hazel', 'heather', 'horizon', 'hunter', 'hyacinth', 'honey', 'hollow', 'harvest', 'holly'],
  i: ['island', 'ivory', 'iris', 'inferno', 'ivy', 'indigo', 'icicle', 'ignite', 'imprint', 'inlet'],
  j: ['jasmine', 'jet', 'juniper', 'journey', 'jungle', 'joy', 'jasper', 'jolly', 'jacket', 'jade'],
  k: ['kepler', 'kiwi', 'kestrel', 'knoll', 'kale', 'kernel', 'kimber', 'koral', 'kite', 'kraken'],
  l: ['lagoon', 'lantern', 'lemon', 'lilac', 'lunar', 'linden', 'lotus', 'lark', 'lattice', 'larch'],
  m: ['maple', 'marble', 'meadow', 'meteor', 'mint', 'moss', 'mango', 'monarch', 'morrow', 'mulberry'],
  n: ['nectar', 'nelson', 'nimbus', 'north', 'nova', 'nutmeg', 'nori', 'night', 'narrow', 'nymph'],
  o: ['oak', 'opal', 'orchid', 'orbit', 'otter', 'olive', 'onyx', 'oasis', 'ocean', 'omega'],
  p: ['pebble', 'petal', 'pine', 'poppy', 'prairie', 'quartz', 'pixel', 'pocket', 'panda', 'plume'],
  q: ['quill', 'quartz', 'quiver', 'quest', 'quince', 'quiet', 'quasar', 'quick', 'quokka', 'quarry'],
  r: ['rain', 'raven', 'reed', 'ridge', 'river', 'rose', 'roam', 'ripple', 'ruby', 'ranger'],
  s: ['sage', 'saffron', 'salmon', 'sandal', 'sequoia', 'shadow', 'spruce', 'summit', 'sunset', 'safflower'],
  t: ['tide', 'timber', 'topaz', 'thistle', 'travel', 'trident', 'tulip', 'tundra', 'talon', 'teal'],
  u: ['umbra', 'unity', 'ultra', 'upland', 'utopia', 'uranus', 'umbrella', 'unicorn', 'urban', 'uphill'],
  v: ['valley', 'velvet', 'verve', 'violet', 'vivid', 'voyage', 'vapor', 'vulture', 'vine', 'willow'],
  w: ['water', 'watson', 'willow', 'whisper', 'wren', 'wander', 'walnut', 'weaver', 'wisp', 'winter'],
  x: ['xenon', 'xeric', 'xylem', 'xenial', 'xylophone', 'xanthic', 'xenith', 'xerus', 'xavier', 'xylograph'],
  y: ['yarrow', 'yalow', 'yellow', 'yonder', 'yew', 'yogurt', 'yonder', 'young', 'yarn', 'yearn'],
  z: ['zephyr', 'zenith', 'zebra', 'zinnia', 'zoe', 'zucchini', 'zen', 'zesty', 'zonal', 'zorro']
};

function randomWord(letter) {
  const list = wordsByLetter[letter] || ['word'];
  return list[Math.floor(Math.random() * list.length)];
}

function generateTree(baseDir, depth, currentDepth = 1) {
  if (currentDepth > depth) {
    return;
  }

  for (const letter of letters) {
    const word = randomWord(letter);
    const dirName = word;
    const fullPath = path.join(baseDir, dirName);

    fs.mkdirSync(fullPath, { recursive: true });

    if (currentDepth < depth) {
      generateTree(fullPath, depth, currentDepth + 1);
    }
  }
}

function main() {
  const depthArg = process.argv[2];
  const depth = Number.parseInt(depthArg, 10);

  if (!Number.isInteger(depth) || depth < 1) {
    console.log('Usage: node generate-nested-random-dirs.js <depth>');
    console.log('Example: node generate-nested-random-dirs.js 3');
    process.exit(1);
  }

  const currentDir = process.cwd();
  generateTree(currentDir, depth, 1);
  console.log(`Created directory tree to depth ${depth} under ${currentDir}`);
}

main();
