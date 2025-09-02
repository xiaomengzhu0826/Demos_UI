using Godot;
using System;

public partial class VeryFastProceduralOcean : Node2D
{
	private static readonly float SUN_SPEED = .8f;
	private static readonly float SUN_PHASE = 4.0f;

	private ShaderMaterial _shaderMat;

	public override void _Ready()
	{
		var colorRect = GetNode<ColorRect>("%ColorRect");
		_shaderMat = colorRect.Material as ShaderMaterial;
		_shaderMat.SetShaderParameter("SUN_SPEED", SUN_SPEED);
		_shaderMat.SetShaderParameter("SUN_PHASE", SUN_PHASE);

		UpdateResolution();
	}

	private void UpdateResolution()
    {
        Vector2 resolution = GetViewport().GetVisibleRect().Size;
        _shaderMat.SetShaderParameter("RES", resolution);
    }


}
