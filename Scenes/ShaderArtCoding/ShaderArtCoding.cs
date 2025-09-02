using Godot;
using System;

public partial class ShaderArtCoding : Node2D
{
	private ShaderMaterial _shaderMat;

	public override void _Ready()
	{
		var colorRect = GetNode<ColorRect>("%ColorRect");
		_shaderMat = colorRect.Material as ShaderMaterial;
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		if (_shaderMat != null)
		{
			// 更新 shader 里的 iTime uniform
			float time = (float)Time.GetTicksMsec() / 1000.0f; // 秒
			_shaderMat.SetShaderParameter("iTime", time);
			UpdateResolution();
		}
	}
	
	private void UpdateResolution()
    {
        Vector2 resolution = GetViewport().GetVisibleRect().Size;
        _shaderMat.SetShaderParameter("iResolution", resolution);
    }
}
