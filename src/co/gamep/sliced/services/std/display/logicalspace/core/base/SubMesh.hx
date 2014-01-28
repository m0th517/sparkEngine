package co.gamep.sliced.services.std.display.logicalspace.core.base;

class SubMesh implements IRenderable {
	public var UVData(default,never) : Dynamic;
	public var UVOffset(default,never) : Int;
	public var UVStride(default,never) : Int;
	public var _index : Int;
	public var _material : co.gamep.sliced.services.std.display.logicalspace.materials.MaterialBase;
	public var animationSubGeometry : co.gamep.sliced.services.std.display.logicalspace.animators.data.AnimationSubGeometry;
	public var animator(default,never) : co.gamep.sliced.services.std.display.logicalspace.animators.IAnimator;
	public var animatorSubGeometry : co.gamep.sliced.services.std.display.logicalspace.animators.data.AnimationSubGeometry;
	public var bounds(default,never) : co.gamep.sliced.services.std.display.logicalspace.bounds.BoundingVolumeBase;
	public var castsShadows(default,never) : Bool;
	public var indexData(default,never) : Dynamic;
	public var inverseSceneTransform(default,never) : Dynamic;
	public var material : co.gamep.sliced.services.std.display.logicalspace.materials.MaterialBase;
	public var mouseEnabled(default,never) : Bool;
	public var numTriangles(default,never) : Int;
	public var numVertices(default,never) : Int;
	public var offsetU : Float;
	public var offsetV : Float;
	public var parentMesh : co.gamep.sliced.services.std.display.logicalspace.entities.Mesh;
	public var scaleU : Float;
	public var scaleV : Float;
	public var sceneTransform(default,never) : Dynamic;
	public var shaderPickingDetails(default,never) : Bool;
	public var sourceEntity(default,never) : co.gamep.sliced.services.std.display.logicalspace.entities.Entity;
	public var subGeometry : ISubGeometry;
	public var uvRotation : Float;
	public var uvTransform(default,never) : Dynamic;
	public var vertexData(default,never) : Dynamic;
	public var vertexNormalData(default,never) : Dynamic;
	public var vertexNormalOffset(default,never) : Int;
	public var vertexOffset(default,never) : Int;
	public var vertexStride(default,never) : Int;
	public var vertexTangentData(default,never) : Dynamic;
	public var vertexTangentOffset(default,never) : Int;
	public var visible(default,never) : Bool;
	public function new():Void {super();}}