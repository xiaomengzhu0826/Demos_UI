using Godot;
using System;
using System.Linq;

public partial class DiamondTransition : CanvasLayer
{
    private ColorRect _colorRect;
    private ShaderMaterial _shaderMaterial;
    private Tween _tween;

    public override void _Ready()
    {
        _colorRect = GetNode<ColorRect>("ColorRect");
        _shaderMaterial = (ShaderMaterial)_colorRect.Material;

        // 创建一个 Tween
        _tween = GetTree().CreateTween();

        // 从 progress=0 到 progress=1，耗时 2 秒
        _tween.TweenMethod(Callable.From<float>(SetProgress), 0f, 1f, 2f);
    }

    private void SetProgress(float value)
    {
        _shaderMaterial.SetShaderParameter("progress", value);
    }

    // 可选：按键切换 Shader 并重新播放动画
    public override void _Input(InputEvent @event)
    {
        if (@event.IsActionPressed("ui_accept"))
        {
            // 1. 把 Keys 转成列表
            var keys = AssetsManager.SCENE1_PREFABS.Keys.ToList();

            // 2. 随机取一个索引
            int index = (int)(GD.Randi() % keys.Count);

            // 3. 取随机 key
            AssetsManager.Scene1 randomKey = keys[index];
            Shader newShader = AssetsManager.SCENE1_PREFABS[randomKey];
            ChangeShader(newShader);
            // 重新播放 Tween
            _tween = GetTree().CreateTween();
            _tween.TweenMethod(Callable.From<float>(SetProgress), 0f, 1f, 2f);
        }
    }

    private void ChangeShader(Shader newShader)
    {
        if (_colorRect.Material is ShaderMaterial mat)
        {
            mat.Shader = newShader;
        }
    }
}
