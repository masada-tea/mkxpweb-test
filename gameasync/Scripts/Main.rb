#==============================================================================
# ■ Main
#------------------------------------------------------------------------------
# 　各クラスの定義が終わった後、ここから実際の処理が始まります。
#==============================================================================

begin
  # トランジション準備
  Graphics.freeze
  # シーンオブジェクト (タイトル画面) を作成
  $scene = Scene_Title.new
  # $scene が有効な限り main メソッドを呼び出す
# 追加する関数（ブラウザから毎フレーム呼ばれる）
$prev_scene = nil
def main_update_loop
  if $scene != nil
    if $scene != $prev_scene
      $prev_scene.dispose if $prev_scene != nil
      $scene.main
      $prev_scene = $scene
    end
    Graphics.update
    Input.update
    $scene.update
  else
    raise "END"
  end
end

# 削除する箇所（元の無限ループ）
# while $scene != nil
#   $scene.main
# end
  # フェードアウト
  Graphics.transition(20)
rescue Errno::ENOENT
  # 例外 Errno::ENOENT を補足
  # ファイルがオープンできなかった場合、メッセージを表示して終了する
  filename = $!.message.sub("No such file or directory - ", "")
  print("ファイル #{filename} が見つかりません。")
end