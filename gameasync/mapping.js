var mappingArray = [
["data", "Data?h="],
["data/actors", "Data/Actors.rxdata?h=6155a56c9d378679ecc1795971a786b3"],
["data/animations", "Data/Animations.rxdata?h=c7356b0a19683db75ff94287458ee553"],
["data/armors", "Data/Armors.rxdata?h=9ff1f23a53841ee4a0487ce41c11aaf9"],
["data/classes", "Data/Classes.rxdata?h=e8ffd7706941e38b577173c20b403089"],
["data/commonevents", "Data/CommonEvents.rxdata?h=cdfdb9eeb8b969b4acc9810d8de7b712"],
["data/enemies", "Data/Enemies.rxdata?h=038e6284856a2e62f078882232540bc7"],
["data/items", "Data/Items.rxdata?h=296b18c02fb5811ddc85313455016836"],
["data/map001", "Data/Map001.rxdata?h=361aad07e7243ed87624e4a576d8ef11"],
["data/mapinfos", "Data/MapInfos.rxdata?h=f4e2d00c9a7bc4a55cbc3a4c7c080cd9"],
["data/scripts", "Data/Scripts.rxdata?h=c622920f6c4202f59b44611ed468bf20"],
["data/skills", "Data/Skills.rxdata?h=9e9c2d473f52bc0ce29442a66e0ab2f6"],
["data/states", "Data/States.rxdata?h=7062c45c5f4db130ec1c4f44213d28fc"],
["data/system", "Data/System.rxdata?h=19d70094eb610aa0a7da1199cb987868"],
["data/tilesets", "Data/Tilesets.rxdata?h=eb9f8fd0b9bde157e316147dc494dfe5"],
["data/troops", "Data/Troops.rxdata?h=8691d48e7fb3755c035d6269be32c19e"],
["data/weapons", "Data/Weapons.rxdata?h=ff6c7da332016ebb03dcbf3d7018f6b0"],
["game", "Game.exe?h=3aa09f7607c9b487f74a29c3dffc5df4"],
["game", "Game.ini?h=c84975eba54d16b3243a82588ee3d01f"],
["game", "Game.rxproj?h=8b3d27798d88da90ec326fcc3e3ccd19"],
["rgss104j", "RGSS104J.dll?h=ae858cb108e43fa708d81525cd48662e"],
["bitmap-map", "bitmap-map.js?h=8d29145a907a99d776f9603eb356d5fa"],
["mapping", "mapping.js?h=46e28d8e9bf01dc2d7d0b604368dee69"],
["rgss", "rgss.rb?h=e4f6ce1cd6617eedd6e4704cfd0d263b"],
];

var mapping = {};
for (var i = 0; i < mappingArray.length; i++) {
    mapping[mappingArray[i][0]] = mappingArray[i][1];
}

