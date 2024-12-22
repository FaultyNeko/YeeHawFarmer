using Godot;
using System;

public partial class Player : CharacterBody2D
{
	[Export]
	public float Speed = 200.0f;
	[Export]
	public float ShootInterval = 0.2f;

	private Shotgun _primaryShotgun;
	private Shotgun _secondaryShotgun;
	private bool _rageMode = false;
	private float _timeSinceLastShot = 0.0f;
	private Vector2 _velocity = Vector2.Zero;
	
	// Get the gravity from the project settings to be synced with RigidBody nodes.
	public float gravity = ProjectSettings.GetSetting("physics/2d/default_gravity").AsSingle();


	public override void _Ready()
	{
		// Load primary shotgun
		PackedScene primaryShotgunScene = (PackedScene)ResourceLoader.Load("res://PrimaryShotgun.tscn");
		_primaryShotgun = (Shotgun)primaryShotgunScene.Instantiate();
		AddChild(_primaryShotgun);

		// Load secondary shotgun (initially disabled)
		PackedScene secondaryShotgunScene = (PackedScene)ResourceLoader.Load("res://SecondaryShotgun.tscn");
		_secondaryShotgun = (Shotgun)secondaryShotgunScene.Instantiate();
		_secondaryShotgun.SetProcess(false);
		_secondaryShotgun.SetPhysicsProcess(false);
		AddChild(_secondaryShotgun);
	}
	public void _Process(float delta)
	{
		HandleInput(delta);
	}
	public override void _PhysicsProcess(double delta)
	{
		MoveAndSlide();
	}

	private void HandleInput(double delta)
	{
		_velocity = Vector2.Zero;
		if (Input.IsActionPressed("ui_right"))
			_velocity.X += 1;
		if (Input.IsActionPressed("ui_left"))
			_velocity.X -= 1;
		if (Input.IsActionPressed("ui_down"))
			_velocity.Y += 1;
		if (Input.IsActionPressed("ui_up"))
			_velocity.Y -= 1;

		_velocity = _velocity.Normalized() * Speed;
		Velocity = _velocity;
		
		if (Input.IsActionJustPressed("shoot"))
		{//make there subclasses to make them work
			_primaryShotgun.Shoot(GlobalPosition, Rotation);
			if (_rageMode)
			{
				_secondaryShotgun.Shoot(GlobalPosition, Rotation);
			}
		}
	}
	//add inputs later
	public void TriggerRageMode()
	{
		_rageMode = true;
		_secondaryShotgun.SetProcess(true);
		_secondaryShotgun.SetPhysicsProcess(true);
	}

	public void EndRageMode()
	{
		_rageMode = false;
		_secondaryShotgun.SetProcess(false);
		_secondaryShotgun.SetPhysicsProcess(false);
	}
}
