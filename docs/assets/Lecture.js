if(window.MathJax){
  MathJax.Hub.Config({
    tex2jax: {
      skipTags: ['script', 'noscript', 'style', 'textarea'],
      inlineMath: [ ['$','$'] ],
      displayMath: [ ['$$','$$'] ]
    },
    TeX: {
      Macros: {
        dd: ["\\mathrm{d}"],
        ee: ["\\mathrm{e}"],
        ii: ["\\mathrm{i}"],
        unit: ["\\,\\mathrm{#1}", 1],
        TeV: ["\\unit{GeV}"],
        GeV: ["\\unit{GeV}"],
        MeV: ["\\unit{GeV}"],
        keV: ["\\unit{keV}"],
        fb: ["\\unit{fb}"],
        pb: ["\\unit{pb}"],
        w: ["_{\\mathrm{#1}}", 1],
        sub: ["_"],
        conj: ["^*"]
      }
    }
  });
  MathJax.Hub.Queue(function() {
    $(MathJax.Hub.getAllJax()).map(function(index, elem) {
      return(elem.SourceElement());
    }).parent().addClass('has-jax');
  });
  MathJax.Hub.Configured();
}

remark.macros.code_title = function() { return '<h6 class="code_title">' + this + '</h6>'; };
remark.macros.width = function (width) { return '<img style="width:' + width + '" src="' + this + '" />'; };
remark.macros.height = function (height) { return '<img style="height:' + height + '" src="' + this + '" />'; };
remark.macros.style = function (style) { return '<span style="' + style + '">' + this + '</span>'; };
remark.macros.answer = function() { return '<button type="button" onclick="alert(\'' + this + '\'); return false;">show answer</button>'; }
remark.macros.hint  = function() { return '<button type="button" onclick="alert(\'' + this + '\'); return false;">Give me a hint!</button>'; }
remark.macros.arxiv = function(arxiv_id) { return '<span class="arxiv_link"><a href="http://arxiv.org/abs/' + arxiv_id + '">' + (typeof(this) == 'string' ? this : arxiv_id) + '</a></span>'; }
addCodePrompt = function(){
  var codeBlocks = document.getElementsByTagName('code');
  document.getElementsByClassName('hljs').forEach(function(code){
    code.getElementsByTagName('div').forEach(function(line){
      if(line.innerHTML.replace(/<.*?>/g, '').substring(0, 5) == '&gt; '){
        line.innerHTML = line.innerHTML.replace(/^(<.*?>)?&gt; /, '<span class="code-prompt"></span>$1');
      }
    });
  });
}

//if(document.addEventListener){
  document.addEventListener('DOMContentLoaded', addCodePrompt, false);
//}else if(windows.attachEvent){
//  window.attachEvent('onload', addCodePrompt);
//}else{
//  window.onload = addCodePrompt;
//}


remark.highlighter.engine.registerLanguage("output", function(hljs){
  return {
    case_insensitive: true,
    contains: [
      hljs.NUMBER_MODE,
      hljs.APOS_STRING_MODE,
      hljs.QUOTE_STRING_MODE,
      hljs.CSS_NUMBER_MODE,
    ],
  };
});
