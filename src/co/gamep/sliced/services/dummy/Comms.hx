/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package co.gamep.sliced.services.dummy;

import co.gamep.sliced.interfaces.IComms;
import co.gamep.sliced.core.AService;

/**
 * ...
 * @author Aris Kostakos
 */
class Comms extends AService implements IComms
{
	public function new() 
	{
		super();
		_init();
	}
	
	private function _init():Void
	{
		Console.log("Init Comms Dummy Service...");
	}
	
}