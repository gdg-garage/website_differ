// Copyright (c) 2016, ZdenÄ›k MlÄŤoch. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:diff_parser/diff_parser.dart' as diff_parser;
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'dart:io';

main(List<String> arguments) {
  Directory data = new Directory("bin/pages");


  Document first;
  for(var entity in data.listSync()){
    if(entity is File){
      Document document = parse(entity.readAsStringSync());
      if(first==null){
        first = document;
        continue;
      }
      for(var i =0;i<first.children.length;i++){
        var comparison = compareNodes(document.children[i],first.children[i]);
        if(comparison!=null){
          if(comparison is Element){
            print(comparison.innerHtml);
          }
        }
      }


    }
  }
}

Node compareNodes(Node a, Node b){
  if(a is Element && b is Element && a.localName == b.localName){
    // check children
    if(a.children.length != b.children.length){
      return a;
    }

    for(int i = 0;i<a.children.length;i++){
      var comparison = compareNodes(a.children[i], b.children[i]);
      if(comparison!=null){
        return comparison;
      }
    }
    return null;
  }

  if(a is Text && b is Text){
    if(a!=b){
      return a;
    }
    return null;
  }
  return a;
}
