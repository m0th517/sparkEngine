/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, September 2013
 */

package co.gamep.sliced.services.std.event.core;

import flambe.input.Key;
import haxe.ds.ObjectMap;
import co.gamep.sliced.interfaces.IEvent;
import co.gamep.sliced.core.AService;
import co.gamep.sliced.services.std.logic.gde.interfaces.EEventType;
import co.gamep.sliced.services.std.logic.gde.interfaces.EEventPrefab;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameTrigger;

/**
 * ...
 * @author Aris Kostakos
 */
class Event extends AService implements IEvent
{
	private var _eventTypeFilterFlags:Map < EEventType, ObjectMap < Dynamic, Bool >> ;
	private var _eventTypeFilterTriggers:Map < EEventType, ObjectMap < Dynamic, Array<IGameTrigger> >> ;
	
	//@note: There are dumb objects that will serve as keys to the filter arrays above. I just needed something to give a unique pointer
		//Btw, a String would not work since in JavaScript a string is apparently a primitive, not an object. So Empty arrays should do the trick
	private var _NO_FILTER:Array<Dynamic>;
	private var _FILTER_VARIABLE_USER_ENTITY:Array<Dynamic>;
	
	private var _prefabConvertToType:Map<EEventPrefab,EEventType>;
	private var _prefabConvertToFilter:Map<EEventPrefab,Dynamic>;
	
	public function new() 
	{
		super();
		
		_init();
	}
	
	private function _init():Void
	{
		Console.log("Init Event std Service...");
		
		_NO_FILTER = new Array<Dynamic>();
		_FILTER_VARIABLE_USER_ENTITY = new Array<Dynamic>();
		
		_eventTypeFilterFlags = new Map < EEventType, ObjectMap < Dynamic, Bool >> ();
		_eventTypeFilterTriggers = new Map < EEventType, ObjectMap < Dynamic, Array<IGameTrigger> >> ();
		
		_initPrefabConvertToTypeMap();
		_initPrefabConvertToFilterMap();
	}
	
	
	public function addTrigger(p_gameTrigger:IGameTrigger):Void
	{
		var l_eventType:EEventType = _prefabConvertToType[p_gameTrigger.eventPrefab];
		var l_eventFilter:Dynamic = _prefabConvertToFilter[p_gameTrigger.eventPrefab];
		
		//Replace Filter with an appropriate variable if needed
		if (l_eventFilter == _FILTER_VARIABLE_USER_ENTITY)
		{
			l_eventFilter = p_gameTrigger.parentEntity;
		}
		
		//Add additional filter variable changes here
		//...
		
		//Create a slot for the eventType included in the trigger's prefab
		if (_eventTypeFilterTriggers.exists(l_eventType) == false)
			_eventTypeFilterTriggers.set(l_eventType, new ObjectMap < Dynamic, Array<IGameTrigger> > () );
		
		//Create a slot for the eventFilter included in the trigger's prefab
		if (_eventTypeFilterTriggers[l_eventType].exists(l_eventFilter) == false)
			_eventTypeFilterTriggers[l_eventType].set(l_eventFilter, new Array<IGameTrigger>() );
		
		//Push the trigger to the correct slot
		_eventTypeFilterTriggers.get(l_eventType).get(l_eventFilter).push(p_gameTrigger);
	}
	
	public function raiseEvent(p_eventType:EEventType, ?p_eventFilter:Dynamic):Void
	{
		if (p_eventFilter == null)
			p_eventFilter = _NO_FILTER;
			
		//Create a slot for the raised eventType
		if (_eventTypeFilterFlags.exists(p_eventType) == false)
			_eventTypeFilterFlags[p_eventType] = new ObjectMap < Dynamic, Bool > ();
			
		_eventTypeFilterFlags[p_eventType].set(p_eventFilter, true);
		
		if (p_eventFilter != _NO_FILTER)
			_eventTypeFilterFlags[p_eventType].set(_NO_FILTER, true);
	}
	
	inline private function _doTriggers(p_eventType:EEventType, p_eventFilter:Dynamic):Void
	{
		//Console.info("Activating triggers for: " + p_eventType);
		
		if (_eventTypeFilterTriggers.exists(p_eventType))
		{
			if (_eventTypeFilterTriggers[p_eventType].exists(p_eventFilter))
			{
				//Console.warn("Triggers exist");
				for (gameTrigger in _eventTypeFilterTriggers[p_eventType].get(p_eventFilter))
				{
					gameTrigger.doPass();
				}
			}
			else
			{
				//Console.warn("Triggers map don't exist in this event's filter");
			}
		}
		else
		{
			//Console.warn("Triggers map don't exist in this event");
		}
	}
	
	public function update():Void
	{
		for (flag in _eventTypeFilterFlags.keys())
		{
			if (_eventTypeFilterFlags[flag].get(_NO_FILTER) == true)
			{
				for (filterFlag in _eventTypeFilterFlags[flag].keys())
				{
					if (_eventTypeFilterFlags[flag].get(filterFlag) == true)
					{
						_eventTypeFilterFlags[flag].set(filterFlag, false);
						_doTriggers(flag, filterFlag);
					}
				}
			}
		}
	}
	
	///////////////////////////
	
	private function _initPrefabConvertToTypeMap():Void
	{
		_prefabConvertToType = new Map<EEventPrefab,EEventType>();
		
		_prefabConvertToType[EEventPrefab.CREATED] = EEventType.CREATED;
		_prefabConvertToType[EEventPrefab.UPDATE] = EEventType.UPDATE;
		_prefabConvertToType[EEventPrefab.MOUSE_LEFT_CLICK] = EEventType.MOUSE_LEFT_CLICK;
		_prefabConvertToType[EEventPrefab.MOUSE_RIGHT_CLICK] = EEventType.MOUSE_RIGHT_CLICK;
		_prefabConvertToType[EEventPrefab.MOUSE_LEFT_CLICKED] = EEventType.MOUSE_LEFT_CLICKED;
		_prefabConvertToType[EEventPrefab.MOUSE_RIGHT_CLICKED] = EEventType.MOUSE_RIGHT_CLICKED;
		_prefabConvertToType[EEventPrefab.MOUSE_OVER] = EEventType.MOUSE_OVER;
		_prefabConvertToType[EEventPrefab.MOUSE_OUT] = EEventType.MOUSE_OUT;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_ALT] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_BACKSPACE] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_CAPS_LOCK] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_CONTROL] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_DELETE] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_DOWN] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_END] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_ENTER] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_ESCAPE] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_F1] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_F10] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_F11] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_F12] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_F13] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_F14] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_F15] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_F2] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_F3] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_F4] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_F5] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_F6] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_F7] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_F8] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_F9] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_HOME] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_INSERT] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_LEFT] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMPAD_0] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMPAD_1] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMPAD_2] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMPAD_3] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMPAD_4] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMPAD_5] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMPAD_6] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMPAD_7] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMPAD_8] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMPAD_9] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMPAD_ADD] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMPAD_DECIMAL] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMPAD_DIVIDE] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMPAD_ENTER] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMPAD_MULTIPLY] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMPAD_SUBTRACT] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_PAGE_DOWN] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_PAGE_UP] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_RIGHT] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_SHIFT] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_SPACE] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_TAB] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_UP] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_A] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_B] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_C] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_D] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_E] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_F] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_G] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_H] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_I] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_J] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_K] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_L] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_M] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_N] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_O] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_P] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_Q] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_R] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_S] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_T] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_U] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_V] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_W] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_X] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_Y] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_Z] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMBER_0] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMBER_1] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMBER_2] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMBER_3] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMBER_4] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMBER_5] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMBER_6] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMBER_7] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMBER_8] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_NUMBER_9] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_EQUALS] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_SLASH] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_BACKSLASH] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_LEFTBRACKET] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_RIGHTBRACKET] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_BACKQUOTE] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_COMMA] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_COMMAND] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_MINUS] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_PERIOD] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_QUOTE] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_SEMICOLON] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_ANDROIDMENU] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_ANDROIDSEARCH] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_PRESSED_UNKNOWN] = EEventType.KEY_PRESSED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_ALT] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_BACKSPACE] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_CAPS_LOCK] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_CONTROL] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_DELETE] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_DOWN] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_END] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_ENTER] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_ESCAPE] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_F1] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_F10] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_F11] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_F12] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_F13] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_F14] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_F15] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_F2] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_F3] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_F4] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_F5] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_F6] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_F7] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_F8] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_F9] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_HOME] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_INSERT] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_LEFT] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMPAD_0] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMPAD_1] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMPAD_2] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMPAD_3] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMPAD_4] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMPAD_5] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMPAD_6] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMPAD_7] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMPAD_8] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMPAD_9] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMPAD_ADD] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMPAD_DECIMAL] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMPAD_DIVIDE] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMPAD_ENTER] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMPAD_MULTIPLY] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMPAD_SUBTRACT] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_PAGE_DOWN] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_PAGE_UP] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_RIGHT] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_SHIFT] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_SPACE] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_TAB] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_UP] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_A] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_B] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_C] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_D] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_E] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_F] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_G] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_H] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_I] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_J] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_K] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_L] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_M] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_N] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_O] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_P] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_Q] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_R] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_S] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_T] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_U] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_V] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_W] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_X] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_Y] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_Z] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMBER_0] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMBER_1] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMBER_2] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMBER_3] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMBER_4] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMBER_5] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMBER_6] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMBER_7] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMBER_8] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_NUMBER_9] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_EQUALS] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_SLASH] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_BACKSLASH] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_LEFTBRACKET] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_RIGHTBRACKET] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_BACKQUOTE] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_COMMA] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_COMMAND] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_MINUS] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_PERIOD] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_QUOTE] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_SEMICOLON] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_ANDROIDMENU] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_ANDROIDSEARCH] = EEventType.KEY_RELEASED;
		_prefabConvertToType[EEventPrefab.KEY_RELEASED_UNKNOWN] = EEventType.KEY_RELEASED;
	}

	private function _initPrefabConvertToFilterMap():Void
	{
		_prefabConvertToFilter = new Map<EEventPrefab,Dynamic>();
		
		_prefabConvertToFilter.set(EEventPrefab.CREATED , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.UPDATE , _NO_FILTER);
		_prefabConvertToFilter.set(EEventPrefab.MOUSE_LEFT_CLICK , _NO_FILTER);
		_prefabConvertToFilter.set(EEventPrefab.MOUSE_RIGHT_CLICK , _NO_FILTER);
		_prefabConvertToFilter.set(EEventPrefab.MOUSE_LEFT_CLICKED , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.MOUSE_RIGHT_CLICKED , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.MOUSE_OVER , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.MOUSE_OUT , _FILTER_VARIABLE_USER_ENTITY);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED , _NO_FILTER);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED , _NO_FILTER);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_ALT, Key.Alt);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_BACKSPACE, Key.Backspace);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_CAPS_LOCK, Key.CapsLock);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_CONTROL, Key.Control);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_DELETE, Key.Delete);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_DOWN, Key.Down);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_END, Key.End);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_ENTER, Key.Enter);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_ESCAPE, Key.Escape);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F1, Key.F1);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F10, Key.F10);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F11, Key.F11);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F12, Key.F12);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F13, Key.F13);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F14, Key.F14);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F15, Key.F15);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F2, Key.F2);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F3, Key.F3);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F4, Key.F4);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F5, Key.F5);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F6, Key.F6);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F7, Key.F7);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F8, Key.F8);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F9, Key.F9);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_HOME, Key.Home);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_INSERT, Key.Insert);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_LEFT, Key.Left);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_0, Key.Numpad0);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_1, Key.Numpad1);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_2, Key.Numpad2);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_3, Key.Numpad3);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_4, Key.Numpad4);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_5, Key.Numpad5);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_6, Key.Numpad6);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_7, Key.Numpad7);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_8, Key.Numpad8);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_9, Key.Numpad9);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_ADD, Key.NumpadAdd);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_DECIMAL, Key.NumpadDecimal);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_DIVIDE, Key.NumpadDivide);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_ENTER, Key.NumpadEnter);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_MULTIPLY, Key.NumpadMultiply);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMPAD_SUBTRACT, Key.NumpadSubtract);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_PAGE_DOWN, Key.PageDown);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_PAGE_UP, Key.PageUp);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_RIGHT, Key.Right);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_SHIFT, Key.Shift);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_SPACE, Key.Space);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_TAB, Key.Tab);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_UP, Key.Up);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_A, Key.A);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_B, Key.B);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_C, Key.C);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_D, Key.D);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_E, Key.E);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_F, Key.F);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_G, Key.G);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_H, Key.H);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_I, Key.I);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_J, Key.J);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_K, Key.K);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_L, Key.L);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_M, Key.M);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_N, Key.N);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_O, Key.O);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_P, Key.P);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_Q, Key.Q);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_R, Key.R);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_S, Key.S);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_T, Key.T);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_U, Key.U);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_V, Key.V);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_W, Key.W);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_X, Key.X);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_Y, Key.Y);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_Z, Key.Z);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMBER_0, Key.Number0);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMBER_1, Key.Number1);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMBER_2, Key.Number2);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMBER_3, Key.Number3);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMBER_4, Key.Number4);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMBER_5, Key.Number5);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMBER_6, Key.Number6);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMBER_7, Key.Number7);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMBER_8, Key.Number8);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_NUMBER_9, Key.Number9);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_EQUALS, Key.Equals);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_SLASH, Key.Slash);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_BACKSLASH, Key.Backslash);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_LEFTBRACKET, Key.LeftBracket);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_RIGHTBRACKET, Key.RightBracket);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_BACKQUOTE, Key.Backquote);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_COMMA, Key.Comma);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_COMMAND, Key.Command);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_MINUS, Key.Minus);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_PERIOD, Key.Period);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_QUOTE, Key.Quote);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_SEMICOLON, Key.Semicolon);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_ANDROIDMENU, Key.Menu);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_ANDROIDSEARCH, Key.Search);
		_prefabConvertToFilter.set(EEventPrefab.KEY_PRESSED_UNKNOWN, Key.Unknown);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_ALT, Key.Alt);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_BACKSPACE, Key.Backspace);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_CAPS_LOCK, Key.CapsLock);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_CONTROL, Key.Control);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_DELETE, Key.Delete);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_DOWN, Key.Down);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_END, Key.End);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_ENTER, Key.Enter);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_ESCAPE, Key.Escape);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F1, Key.F1);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F10, Key.F10);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F11, Key.F11);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F12, Key.F12);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F13, Key.F13);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F14, Key.F14);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F15, Key.F15);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F2, Key.F2);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F3, Key.F3);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F4, Key.F4);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F5, Key.F5);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F6, Key.F6);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F7, Key.F7);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F8, Key.F8);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F9, Key.F9);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_HOME, Key.Home);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_INSERT, Key.Insert);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_LEFT, Key.Left);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_0, Key.Numpad0);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_1, Key.Numpad1);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_2, Key.Numpad2);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_3, Key.Numpad3);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_4, Key.Numpad4);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_5, Key.Numpad5);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_6, Key.Numpad6);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_7, Key.Numpad7);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_8, Key.Numpad8);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_9, Key.Numpad9);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_ADD, Key.NumpadAdd);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_DECIMAL, Key.NumpadDecimal);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_DIVIDE, Key.NumpadDivide);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_ENTER, Key.NumpadEnter);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_MULTIPLY, Key.NumpadMultiply);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMPAD_SUBTRACT, Key.NumpadSubtract);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_PAGE_DOWN, Key.PageDown);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_PAGE_UP, Key.PageUp);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_RIGHT, Key.Right);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_SHIFT, Key.Shift);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_SPACE, Key.Space);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_TAB, Key.Tab);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_UP, Key.Up);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_A, Key.A);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_B, Key.B);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_C, Key.C);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_D, Key.D);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_E, Key.E);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_F, Key.F);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_G, Key.G);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_H, Key.H);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_I, Key.I);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_J, Key.J);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_K, Key.K);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_L, Key.L);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_M, Key.M);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_N, Key.N);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_O, Key.O);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_P, Key.P);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_Q, Key.Q);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_R, Key.R);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_S, Key.S);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_T, Key.T);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_U, Key.U);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_V, Key.V);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_W, Key.W);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_X, Key.X);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_Y, Key.Y);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_Z, Key.Z);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMBER_0, Key.Number0);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMBER_1, Key.Number1);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMBER_2, Key.Number2);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMBER_3, Key.Number3);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMBER_4, Key.Number4);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMBER_5, Key.Number5);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMBER_6, Key.Number6);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMBER_7, Key.Number7);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMBER_8, Key.Number8);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_NUMBER_9, Key.Number9);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_EQUALS, Key.Equals);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_SLASH, Key.Slash);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_BACKSLASH, Key.Backslash);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_LEFTBRACKET, Key.LeftBracket);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_RIGHTBRACKET, Key.RightBracket);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_BACKQUOTE, Key.Backquote);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_COMMA, Key.Comma);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_COMMAND, Key.Command);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_MINUS, Key.Minus);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_PERIOD, Key.Period);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_QUOTE, Key.Quote);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_SEMICOLON, Key.Semicolon);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_ANDROIDMENU, Key.Menu);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_ANDROIDSEARCH, Key.Search);
		_prefabConvertToFilter.set(EEventPrefab.KEY_RELEASED_UNKNOWN, Key.Unknown);
	}
}