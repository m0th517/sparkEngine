package co.gamep.sliced.services.std.display.logicalspace.animators;

class AnimatorBase extends co.gamep.sliced.services.std.display.logicalspace.library.assets.NamedAssetBase implements co.gamep.sliced.services.std.display.logicalspace.library.assets.IAsset {
	public var absoluteTime(default,never) : Float;
	public var activeAnimation(default,never) : co.gamep.sliced.services.std.display.logicalspace.animators.nodes.AnimationNodeBase;
	public var activeAnimationName(default,never) : String;
	public var activeState(default,never) : co.gamep.sliced.services.std.display.logicalspace.animators.states.IAnimationState;
	public var animationSet(default,never) : IAnimationSet;
	public var assetType(default,never) : String;
	public var autoUpdate : Bool;
	public var playbackSpeed : Float;
	public var time : Int;
	public var updatePosition : Bool;
	public function new():Void {super();}}
