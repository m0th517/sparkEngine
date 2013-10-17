/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, September 2013
 */

package org.gamepl.coreservices.services.std.display.core;
import org.gamepl.coreservices.services.std.display.interfaces.IScene;
import org.gamepl.coreservices.services.std.display.interfaces.IObject;

/**
 * ...
 * @author Aris Kostakos
 */
class Scene implements IScene
{
	public var posX( default, default ):Int;
	public var posY( default, default ):Int;
	
	public var objectSet( default, null ):Array<IObject>;
	public var modifiedLastUpdate( default, default ):Bool;
	//camera?
	
	public function new() 
	{
		_init();
	}
	
	private function _init():Void
	{
		Console.log("Init Scene...");
		objectSet = new Array<IObject>();
		modifiedLastUpdate = false; //???
	}
	
	public function addObject(object:IObject):Void
	{
		objectSet.push(object);
	}
	
	public function removeObject(object:IObject):Void
	{
		objectSet.remove(object);
	}
}