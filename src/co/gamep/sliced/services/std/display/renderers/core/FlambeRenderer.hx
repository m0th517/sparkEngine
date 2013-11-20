/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

 package co.gamep.sliced.services.std.display.renderers.core;

import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalView;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalScene;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalCamera;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalEntity;
import co.gamep.sliced.services.std.display.renderers.interfaces.IRenderer;
import flambe.Entity;


/**
 * ...
 * @author Aris Kostakos
 */
class FlambeRenderer extends ARenderer
{
	private var _viewPointerSet:Map<ILogicalView,Entity>;
	private var _scenePointerSet:Map<ILogicalScene,Entity>;
	private var _entityPointerSet:Map<ILogicalEntity,Entity>;
	private var _cameraPointerSet:Map<ILogicalCamera,Entity>;
	
	public function new() 
	{
		super();
		
		_init();
	}
	
	inline private function _init():Void
	{
		Console.info("Creating Flambe Renderer...");
		uses3DEngine = false;
	}
	
	override public function update ():Void
	{
		super.update();
	}
	
	override public function render ( p_logicalView:ILogicalView):Void
	{
		//render a view
		
	}
}