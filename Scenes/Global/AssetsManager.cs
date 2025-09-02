using Godot;
using System;
using System.Collections.Generic;

public partial class AssetsManager : Node
{
    public static AssetsManager Instance { get; private set; }

    //OVERALL
    public enum Scene1
    {
        SHADER_1,
        SHADER_2
    }

    public static readonly Dictionary<Scene1, Shader> SCENE1_PREFABS = new()
    {
        {Scene1.SHADER_1,GD.Load<Shader>("res://Scenes/DiamondTransition/transition_1.gdshader")},
        {Scene1.SHADER_2,GD.Load<Shader>("uid://ck3n4q5vpl4td")},
    };
    
    public override void _Ready()
    {
        Instance = this;
    }
}
