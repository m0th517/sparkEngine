/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

 package co.gamep.sliced.services.std.display.renderers.core;

import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalCamera;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalEntity;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalScene;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalView;
import co.gamep.sliced.services.std.display.renderers.interfaces.IRenderer;

/**
 * ...
 * @author Aris Kostakos
 */
class ARenderer implements IRenderer
{
	public var logicalViewSet( default, null ):Array<ILogicalView>;
	public var uses3DEngine( default, null ):Bool;
	
	private function new() 
	{
		_aRendererInit();
	}

	inline private function _aRendererInit():Void
	{
		logicalViewSet = new Array<ILogicalView>();
	}
	
	public function render ( p_logicalView:ILogicalView):Void
	{
		//override...
		
	}
	
	public function update ():Void
	{
		//update 'dirty' views
		for (logicalView in logicalViewSet)
		{
			_updateView(logicalView);
		}
	}
	
	private function _updateView(p_logicalView:ILogicalView):Void
	{
		//override...
		
	}
	
	private function _updateScene(p_logicalScene:ILogicalScene):Void
	{
		//override...
		
	}
	
	private function _updateCamera(p_logicalCamera:ILogicalCamera):Void
	{
		//override...
		
	}
	
	private function _updateEntity(p_logicalEntity:ILogicalEntity, p_logicalScene:ILogicalScene):Void
	{
		//override...
		
	}
}