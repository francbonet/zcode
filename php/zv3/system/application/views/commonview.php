<!--

<?php 

/*
*
* MIT License
* 
* Copyright (c) 2008, Juan Delgado - Zarate
* 
* http://zarate.tv/projects/zcode/
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
* 
*/

echo utf8_encode($misc_freak_warning); 

?>

-->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="<?php echo $language->shortID; ?>" lang="<?php echo $language->shortID; ?>">
<head>
	
	<title>Z&aacute;rate <?php if(isset($secondaryTitle)){ echo " - ".$secondaryTitle; } ?></title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	
	<link rel="alternate" type="application/rss+xml" title="ZBlog RSS Feed" href="http://blog.zarate.tv/feed/" />
	
	<base href="<?php echo base_url(); ?>" />
	
	<?php if(isset($pageCss)){ foreach($pageCss as $css){ ?>
	<link rel="stylesheet" href="css/<?php echo $css; ?>" type="text/css" media="screen" />
	<?php } } ?>
	
	<?php if(isset($pageJS)){ foreach($pageJS as $js){ ?>
	<script type="text/javascript" src="js/<?php echo $js; ?>"></script>
	<?php } } ?>
	
	<script type="text/javascript">
		
		var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
		document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
		
	</script>
	
	<script type="text/javascript">
		
		var pageTracker = _gat._getTracker("UA-158766-1");
		pageTracker._initData();
		pageTracker._trackPageview();
		
	</script>
	
</head>
<body>

<?php $this->load->view($contentView); ?>

</body>
</html>