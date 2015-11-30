<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template name="vkbeautify-js">
        <script><![CDATA[
            /*
               VKBeautify https://github.com/vkiryukhin/vkBeautify
               javascript plugin to pretty-print or minify text in XML, JSON, CSS and SQL formats.
               Version - 0.98.00.beta

            */
            (function(){function m(e){var b="    ";if(isNaN(parseInt(e)))b=e;else switch(e){case 1:b=" ";break;case 2:b="  ";break;case 3:b="   ";break;case 4:b="    ";break;case 5:b="     ";break;case 6:b="      ";break;case 7:b="       ";break;case 8:b="        ";break;case 9:b="         ";break;case 10:b="          ";break;case 11:b="           ";break;case 12:b="            "}e=["\n"];for(ix=0;100>ix;ix++)e.push(e[ix]+b);return e}function k(){this.step="    ";this.shift=m(this.step)}function p(e,b){return e.replace(/\s{1,}/g,
            " ").replace(/ AND /ig,"~::~"+b+b+"AND ").replace(/ BETWEEN /ig,"~::~"+b+"BETWEEN ").replace(/ CASE /ig,"~::~"+b+"CASE ").replace(/ ELSE /ig,"~::~"+b+"ELSE ").replace(/ END /ig,"~::~"+b+"END ").replace(/ FROM /ig,"~::~FROM ").replace(/ GROUP\s{1,}BY/ig,"~::~GROUP BY ").replace(/ HAVING /ig,"~::~HAVING ").replace(/ IN /ig," IN ").replace(/ JOIN /ig,"~::~JOIN ").replace(/ CROSS~::~{1,}JOIN /ig,"~::~CROSS JOIN ").replace(/ INNER~::~{1,}JOIN /ig,"~::~INNER JOIN ").replace(/ LEFT~::~{1,}JOIN /ig,"~::~LEFT JOIN ").replace(/ RIGHT~::~{1,}JOIN /ig,
            "~::~RIGHT JOIN ").replace(/ ON /ig,"~::~"+b+"ON ").replace(/ OR /ig,"~::~"+b+b+"OR ").replace(/ ORDER\s{1,}BY/ig,"~::~ORDER BY ").replace(/ OVER /ig,"~::~"+b+"OVER ").replace(/\(\s{0,}SELECT /ig,"~::~(SELECT ").replace(/\)\s{0,}SELECT /ig,")~::~SELECT ").replace(/ THEN /ig," THEN~::~"+b+"").replace(/ UNION /ig,"~::~UNION~::~").replace(/ USING /ig,"~::~USING ").replace(/ WHEN /ig,"~::~"+b+"WHEN ").replace(/ WHERE /ig,"~::~WHERE ").replace(/ WITH /ig,"~::~WITH ").replace(/ ALL /ig," ALL ").replace(/ AS /ig,
            " AS ").replace(/ ASC /ig," ASC ").replace(/ DESC /ig," DESC ").replace(/ DISTINCT /ig," DISTINCT ").replace(/ EXISTS /ig," EXISTS ").replace(/ NOT /ig," NOT ").replace(/ NULL /ig," NULL ").replace(/ LIKE /ig," LIKE ").replace(/\s{0,}SELECT /ig,"SELECT ").replace(/\s{0,}UPDATE /ig,"UPDATE ").replace(/ SET /ig," SET ").replace(/~::~{1,}/g,"~::~").split("~::~")}k.prototype.xml=function(e,b){for(var a=e.replace(/>\s{0,}</g,"><").replace(/</g,"~::~<").replace(/\s*xmlns\:/g,"~::~xmlns:").replace(/\s*xmlns\=/g,
            "~::~xmlns=").split("~::~"),k=a.length,f=!1,g=0,d="",c=0,l=b?m(b):this.shift,c=0;c<k;c++)if(-1<a[c].search(/<!/)){if(d+=l[g]+a[c],f=!0,-1<a[c].search(/--\x3e/)||-1<a[c].search(/\]>/)||-1<a[c].search(/!DOCTYPE/))f=!1}else-1<a[c].search(/--\x3e/)||-1<a[c].search(/\]>/)?(d+=a[c],f=!1):/^<\w/.exec(a[c-1])&&/^<\/\w/.exec(a[c])&&/^<[\w:\-\.\,]+/.exec(a[c-1])==/^<\/[\w:\-\.\,]+/.exec(a[c])[0].replace("/","")?(d+=a[c],f||g--):d=-1<a[c].search(/<\w/)&&-1==a[c].search(/<\//)&&-1==a[c].search(/\/>/)?f?d+=a[c]:
            d+=l[g++]+a[c]:-1<a[c].search(/<\w/)&&-1<a[c].search(/<\//)?f?d+=a[c]:d+=l[g]+a[c]:-1<a[c].search(/<\//)?f?d+=a[c]:d+=l[--g]+a[c]:-1<a[c].search(/\/>/)?f?d+=a[c]:d+=l[g]+a[c]:-1<a[c].search(/<\?/)?d+(l[g]+a[c]):-1<a[c].search(/xmlns\:/)||-1<a[c].search(/xmlns\=/)?d+(l[g]+a[c]):d+a[c];return"\n"==d[0]?d.slice(1):d};k.prototype.json=function(e,b){b=b?b:this.step;return"undefined"===typeof JSON?e:"string"===typeof e?JSON.stringify(JSON.parse(e),null,b):"object"===typeof e?JSON.stringify(e,null,b):e};
            k.prototype.css=function(e,b){for(var a=e.replace(/\s{1,}/g," ").replace(/\{/g,"{~::~").replace(/\}/g,"~::~}~::~").replace(/\;/g,";~::~").replace(/\/\*/g,"~::~/*").replace(/\*\//g,"*/~::~").replace(/~::~\s{0,}~::~/g,"~::~").split("~::~"),k=a.length,f=0,g="",d=0,c=b?m(b):this.shift,d=0;d<k;d++)/\{/.exec(a[d])?g+=c[f++]+a[d]:/\}/.exec(a[d])?g+=c[--f]+a[d]:(/\*\\/.exec(a[d]),g+=c[f]+a[d]);return g.replace(/^\n{1,}/,"")};k.prototype.sql=function(e,b){for(var a=e.replace(/\s{1,}/g," ").replace(/\'/ig,
            "~::~'").split("~::~"),k=a.length,f=[],g=0,d=this.step,c=0,l="",h=0,n=b?m(b):this.shift,h=0;h<k;h++)f=h%2?f.concat(a[h]):f.concat(p(a[h],d));k=f.length;for(h=0;h<k;h++)a=f[h],c-=a.replace(/\(/g,"").length-a.replace(/\)/g,"").length,/\s{0,}\s{0,}SELECT\s{0,}/.exec(f[h])&&(f[h]=f[h].replace(/\,/g,",\n"+d+d+"")),/\s{0,}\s{0,}SET\s{0,}/.exec(f[h])&&(f[h]=f[h].replace(/\,/g,",\n"+d+d+"")),/\s{0,}\(\s{0,}SELECT\s{0,}/.exec(f[h])?(g++,l+=n[g]+f[h]):/\'/.exec(f[h])?(1>c&&g&&g--,l+=f[h]):(l+=n[g]+f[h],1>c&&
            g&&g--);return l=l.replace(/^\n{1,}/,"").replace(/\n{1,}/g,"\n")};k.prototype.xmlmin=function(e,b){return(b?e:e.replace(/\<![ \r\n\t]*(--([^\-]|[\r\n]|-[^\-])*--[ \r\n\t]*)\>/g,"").replace(/[ \r\n\t]{1,}xmlns/g," xmlns")).replace(/>\s{0,}</g,"><")};k.prototype.jsonmin=function(e){return"undefined"===typeof JSON?e:JSON.stringify(JSON.parse(e),null,0)};k.prototype.cssmin=function(e,b){return(b?e:e.replace(/\/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+\//g,"")).replace(/\s{1,}/g," ").replace(/\{\s{1,}/g,
            "{").replace(/\}\s{1,}/g,"}").replace(/\;\s{1,}/g,";").replace(/\/\*\s{1,}/g,"/*").replace(/\*\/\s{1,}/g,"*/")};k.prototype.sqlmin=function(e){return e.replace(/\s{1,}/g," ").replace(/\s{1,}\(/,"(").replace(/\s{1,}\)/,")")};window.vkbeautify=new k})();
        ]]></script>
    </xsl:template>

</xsl:stylesheet>