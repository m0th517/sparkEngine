/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, January 2015
 */

package tools.spark.sliced.services.std.display.active_displayentity_references.core;

import tools.spark.sliced.services.std.display.active_displayentity_references.interfaces.IActiveStageAreaReference;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.framework.layout.containers.Group;

/**
 * ...
 * @author Aris Kostakos
 */
class ActiveStageAreaReference implements IActiveStageAreaReference
{
	public var stageAreaEntity( default, null ):IGameEntity;
	public var layoutElement( default, null ):Group;
	
	public function new(p_stageAreaEntity:IGameEntity) 
	{
		stageAreaEntity = p_stageAreaEntity;
		
		_init();
	}
	
	inline private function _init():Void
	{
		//A brand new root Group is created..
		layoutElement = new Group(stageAreaEntity, "StageArea", this);
	}
}