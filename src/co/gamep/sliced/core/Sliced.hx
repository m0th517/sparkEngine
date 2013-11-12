/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package co.gamep.sliced.core;
import co.gamep.sliced.interfaces.ISound;
import co.gamep.sliced.interfaces.ILogic;
import co.gamep.sliced.interfaces.IInput;
import co.gamep.sliced.interfaces.IComms;
import co.gamep.sliced.interfaces.IEvent;
import co.gamep.sliced.interfaces.IDisplay;

/**
 * ...
 * @author Aris Kostakos
 */
class Sliced
{
	public static var sound( default, null ):ISound;
	public static var logic( default, null ):ILogic;
	public static var input( default, null ):IInput;
	public static var comms( default, null ):IComms;
	public static var event( default, null ):IEvent;
	public static var display( default, null ):IDisplay;
	
	public static function init():Void
	{
		//Create Service Factory (which will create S.L.I.C.E.D.)
		var l_serviceFactory:ServiceFactory = new ServiceFactory();
	}
	
	public static function assignServices(p_sound:ISound, p_logic:ILogic, p_input:IInput, p_comms:IComms, p_event:IEvent, p_display:IDisplay):Void
	{
		Console.log("Init Core (S.L.I.C.E.D.)...");
		sound = p_sound;
		logic = p_logic;
		input = p_input;
		comms = p_comms;
		event = p_event;
		display = p_display;
	}
	
	//@todo: maybe inline all the update functions?
	inline public static function update():Void
	{
		//Input Update
		Sliced.input.update();
		
		//Event Update
		Sliced.event.update();
		
		//Logic Update
		Sliced.logic.update();
		
		//Display Update
		Sliced.display.update();
	}
}