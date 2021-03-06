<?php
  $title="JUMAN++表記ゆれ検出サンプル";
  include "./header.php";
?>
<div class="container">
  <h1><?= $title ?></h1>
  <textarea id="input" cols=100 rows=10></textarea>
  <div>
    <p>
    例：申込みと申し込み。粗利と荒利。シミュレーションとシュミレーション。ふんいきとふいんき。売上と売り上げと売上げ。七人の侍と７人の侍。たこやきとたこ焼きとタコ焼きとタコヤキと蛸焼き。サーモンとシャケと鮭とサケ。
    <p>
    <a href="./show_userdic.php">ユーザー辞書</a>
  </div>
  <button id="analyze">検出</button> 
  <div id="result"></div>
</div>
<script type="text/javascript">
(function(){
  $('#analyze').on('click', function(){
    $.ajax({
      type: "POST",
      url:      './analyze.php',
      data:     { 'input': $('#input').val() },
      dataType: 'html',
      success: function(response){
        $('#result').html(response);
      },
      error: function(response) {
        alert(response);
      }
    });
  });
})();
</script>
<?php include "./footer.php"; ?>
