<link rel=stylesheet href="../../libs/js/codemirror/addon/merge/merge.css">
<script src="../../libs/js/diff-match-patch/diff-match-patch.js"></script>
<script src="../../libs/js/codemirror/addon/merge/merge.js"></script>
<style>
/* Grid of 6 */
.group:after,.section{clear:both}.section{padding:0;margin:0}.col{display:block;float:left;margin:1% 0 1% 1.6%}.col:first-child{margin-left:0}.group:after,.group:before{content:"";display:table}.group{zoom:1}.span_6_of_6{width:100%}.span_5_of_6{width:83.06%}.span_4_of_6{width:66.13%}.span_3_of_6{width:49.2%}.span_2_of_6{width:32.26%}.span_1_of_6{width:15.33%}@media only screen and (max-width:480px){.col{margin:1% 0}.span_1_of_6,.span_2_of_6,.span_3_of_6,.span_4_of_6,.span_5_of_6,.span_6_of_6{width:100%}}

/* Glyph to improve usability of code compare */
.CodeMirror-merge-copybuttons-left > .CodeMirror-merge-copy {
    visibility: hidden;
}
.CodeMirror-merge-copybuttons-left > .CodeMirror-merge-copy::before {
    visibility: visible;
    content: '\25ba\25ba\25ba';
}
#subjectCompare .CodeMirror-merge, .CodeMirror-merge .CodeMirror {
  height: 50px;
}
</style>

<div class="section group">
    <div class="col span_1_of_6">
        <div id="fileBrowser" style="float: left; width: 200px; margin: 4px">
        Email Templates:
            <div id="fileList"></div>
        </div>
    </div>
    <div id="codeArea" class="col span_4_of_6">
        <div id="codeContainer" class="card" style="float: left; padding: 8px; display: none">
        	<div id="subject" style="padding: 8px; font-size: 140%; font-weight: bold"></div>
        	<div id="divSubject" style="border: 1px solid black">
        		<textarea id="subjectCode"></textarea>
        		<div id="subjectCompare"></div>
        	</div>
        	<br />
            <div id="filename" style="padding: 8px; font-size: 140%; font-weight: bold"></div>
            <div id="divCode" style="border: 1px solid black">
                <textarea id="code"></textarea>
                <div id="codeCompare"></div>
            </div>
            <br />
            <div>
            	<fieldset><legend>Template Variables</legend><br />
	            <table class="table">
		            <tr>
		                <td><b>{{$recordID}}</b></td>
		                <td>The ID number of the request</td>
		            </tr>
		            <tr>
		                <td><b>{{$fullTitle}}</b></td>
		                <td>The full title of the request</td>
		            </tr>
		            <tr>
		                <td><b>{{$truncatedTitle}}</b></td>
		                <td>A truncated version of the request title</td>
		            </tr>
		            <tr>
		            	<td><b>{{$lastStatus}}</b></td>
		            	<td>The last action taken for the request</td>
		            </tr>
		            <tr>
		            	<td><b>{{$comment}}</b></td>
		            	<td>The last comment associated with the request</td>
		            </tr>
		            <tr>
		            	<td><b>{{$service}}</b></td>
		            	<td>The service associated with the request</td>
		            </tr>
		            <tr>
		            	<td><b>{{$siteRoot}}</b></td>
		            	<td>The root URL of the LEAF site</td>
		            </tr>
	            </table>
	        </div>
            <div>
                <table class="table">
                    <tr>
                        <td colspan="2">Keyboard Shortcuts within coding area</td>
                    </tr>
                    <tr>
                        <td>Save</td>
                        <td>Ctrl + S</td>
                    </tr>
                    <tr>
                        <td>Fullscreen</td>
                        <td>F11</td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <div class="col span_1_of_6">
        <div id="controls" style="float: right; width: 170px; visibility: hidden">
            <div class="buttonNorm" onclick="save();"><img id="saveIndicator" src="../../libs/dynicons/?img=media-floppy.svg&w=32" alt="Save" /> Save Changes<span id="saveStatus"></span></div><br /><br /><br />
            <div class="buttonNorm modifiedTemplate" onclick="restore();"><img src="../../libs/dynicons/?img=x-office-document-template.svg&w=32" alt="Restore" /> Restore Original</div><br />
            <div class="buttonNorm" id="btn_compareStop" style="display: none" onclick="loadContent();"><img src="../../libs/dynicons/?img=text-x-generic.svg&w=32" alt="Normal view" /> Stop Comparing</div>
            <div class="buttonNorm modifiedTemplate" id="btn_compare" onclick="compare();"><img src="../../libs/dynicons/?img=edit-copy.svg&w=32" alt="Compare" /> Compare with Original</div><br /><br /><br />
        </div>
    </div>
</div>

<!--{include file="site_elements/generic_confirm_xhrDialog.tpl"}-->

<script>

function save() {
	$('#saveIndicator').attr('src', '../images/indicator.gif');
	var data = '';
	var subject = '';
	if(codeEditor.getValue == undefined) {
	    data = codeEditor.edit.getValue();
	}
	else {
	    data = codeEditor.getValue();
	}

	if (subjectEditor.getValue == undefined) {
		subject = subjectEditor.edit.getValue();
	}
	else {
		subject = subjectEditor.getValue();
	}

	$.ajax({
		type: 'POST',
		data: {CSRFToken: '<!--{$CSRFToken}-->',
			   file: data,
			   subjectFile: subject,
			   subjectFileName: currentSubjectFile},
		url: '../api/system/emailtemplates/_' + currentFile,
		success: function(res) {
			$('#saveIndicator').attr('src', '../../libs/dynicons/?img=media-floppy.svg&w=32');
			$('.modifiedTemplate').css('display', 'block');
			if($('#btn_compareStop').css('display') != 'none') {
			    $('#btn_compare').css('display', 'none');
			}

            var time = new Date().toLocaleTimeString();
            $('#saveStatus').html('<br /> Last saved: ' + time);
            currentFileContent = data;
            currentSubjectContent = subject;
            if(res != null) {
                alert(res);
            }
		}
	});
}

function restore() {
	dialog.setTitle('Are you sure?');
	dialog.setContent('This will restore the template to the original version.');

	dialog.setSaveHandler(function() {
		$.ajax({
	        type: 'DELETE',
	        url: '../api/system/emailtemplates/_' + currentFile + '?subjectFileName=' + currentSubjectFile + '&CSRFToken=<!--{$CSRFToken}-->',
	        success: function() {
	            loadContent(currentFile, currentSubjectFile);
	        }
	    });
		dialog.hide();
	});
	
	dialog.show();
}

var dv;
function compare() {
    $('.CodeMirror').remove();
    $('#codeCompare').empty();
    $('#subjectCompare').empty();
    $('#btn_compare').css('display', 'none');
    $('#btn_compareStop').css('display', 'block');

    $.ajax({
        type: 'GET',
        url: '../api/system/emailtemplates/_' + currentFile + '/standard',
        success: function(standard) {
            codeEditor = CodeMirror.MergeView(document.getElementById("codeCompare"), {
                mode: "htmlmixed",
                lineNumbers: true,
                indentUnit: 4,
                value: currentFileContent.replace(/\r\n/g, "\n"),
                origLeft: standard.file.replace(/\r\n/g, "\n"),
                showDifferences: true,
                collapseIdentical: true,
                lineWrapping: true,
                extraKeys: {
                    "Ctrl-S": function(cm) {
                        save();
                    }
                  }
              });


            subjectEditor = CodeMirror.MergeView(document.getElementById("subjectCompare"), {
                mode: "htmlmixed",
                lineNumbers: true,
                indentUnit: 4,
                value: currentSubjectContent.replace(/\r\n/g, "\n"),
                origLeft: standard.subjectFile.replace(/\r\n/g, "\n"),
                showDifferences: true,
                collapseIdentical: true,
                lineWrapping: true,
                extraKeys: {
                    "Ctrl-S": function(cm) {
                        save();
                    }
                  }
              });

            updateEditorSize();
        },
        cache: false
    });
}

var currentFile = '';
var currentSubjectFile = '';
var currentFileContent = '';
var currentSubjectContent = '';
function loadContent(file, subjectFile) {
    if(file == undefined) {
        file = currentFile;
    }
    if(subjectFile == undefined) {
    	subjectFile = currentSubjectFile;
    }
    $('.CodeMirror').remove();
    $('#codeCompare').empty();
    $('#subjectCompare').empty();
    $('#btn_compareStop').css('display', 'none');
    
    initEditor();
	currentFile = file;
	currentSubjectFile = subjectFile;
	$('#codeContainer').css('display', 'none');
	$('#controls').css('visibility', 'visible');
	$('#filename').html(file.replace('.tpl', ''));

	if (subjectFile == '')
	{
		$('#subject').hide();
        $('#divSubject').hide();
		subjectEditor.setOption("readOnly", true);
	}
	else
	{
        $('#subject').show();
        $('#divSubject').show();
		$('#subject').html(subjectFile.replace('.tpl', ''));
	}

	$.ajax({
		type: 'GET',
		url: '../api/system/emailtemplates/_' + file,
		success: function(res) {
		    currentFileContent = res.file;
		    currentSubjectContent = res.subjectFile;
			$('#codeContainer').fadeIn();
			codeEditor.setValue(res.file);
			subjectEditor.setValue(res.subjectFile);

			if(res.modified == 1) {
				$('.modifiedTemplate').css('display', 'block');
			}
			else {
				$('.modifiedTemplate').css('display', 'none');
			}
		},
		cache: false
	});
	$('#saveStatus').html('');
}

function updateEditorSize() {
    codeWidth = $('#codeArea').width() - 30;
    $('#codeContainer').css('width', codeWidth + 'px');
    $('#divSubject .CodeMirror').css('height', '50px');
}

function initEditor () {
    codeEditor = CodeMirror.fromTextArea(document.getElementById("code"), {
        mode: "htmlmixed",
        lineNumbers: true,
        indentUnit: 4,
        extraKeys: {
            "F11": function(cm) {
              cm.setOption("fullScreen", !cm.getOption("fullScreen"));
            },
            "Esc": function(cm) {
              if (cm.getOption("fullScreen")) cm.setOption("fullScreen", false);
            },
            "Ctrl-S": function(cm) {
                save();
            }
          }
      });

    subjectEditor = CodeMirror.fromTextArea(document.getElementById("subjectCode"), {
        mode: "htmlmixed",
        viewportMargin: 5,
        lineNumbers: true,
        indentUnit: 4,
        extraKeys: {
            "F11": function(cm) {
              cm.setOption("fullScreen", !cm.getOption("fullScreen"));
            },
            "Esc": function(cm) {
              if (cm.getOption("fullScreen")) cm.setOption("fullScreen", false);
            },
            "Ctrl-S": function(cm) {
                save();
            }
          }
      });

    updateEditorSize();
}

var codeEditor = null;
var subjectEditor = null;
$(function() {
	dialog = new dialogController('confirm_xhrDialog', 'confirm_xhr', 'confirm_loadIndicator', 'confirm_button_save', 'confirm_button_cancelchange');

    initEditor();

    $(window).on('resize', function() {
        updateEditorSize();
    });

	$.ajax({
		type: 'GET',
		url: '../api/system/emailtemplates',
 		success: function(res) {
			var buffer = '<ul>';
			for(var i in res) {
				file = res[i]['fileName'].replace('.tpl', '');
				buffer += '<li onclick="loadContent(\''+ res[i]['fileName'] +'\', \'' + res[i]['subjectFileName'] + '\');"><a href="#">' + file + '</a></li>';
			}
			buffer += '</ul>';
			$('#fileList').html(buffer);
		},
		cache: false
	});
	
	loadContent('LEAF_main_email_template.tpl', undefined);
});
</script>