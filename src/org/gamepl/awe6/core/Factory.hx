/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, July 2013
 */

 package org.gamepl.awe6.core;
import awe6.interfaces.IKernel;
import org.gamepl.awe6.core.gui.Overlay;
import org.gamepl.awe6.core.scenes.Game;
import org.gamepl.awe6.core.scenes.Intro;
import org.gamepl.awe6.core.scenes.SceneTransition;
import awe6.core.AFactory;
import awe6.core.TextStyle;
import awe6.interfaces.EScene;
import awe6.interfaces.ETextStyle;
import awe6.interfaces.IAssetManagerProcess;
import awe6.interfaces.IOverlayProcess;
import awe6.interfaces.IPreloader;
import awe6.interfaces.IScene;
import awe6.interfaces.ISceneTransition;
import awe6.interfaces.ISession;
import awe6.interfaces.ITextStyle;
import org.gamepl.coreservices.core.ServiceFactory;

/**
 * ...
 * @author Aris Kostakos
 */

class Factory extends AFactory 
{
	private var _assetManager:AssetManager;

	override private function _configurer( p_isPreconfig:Bool = false ):Void 
	{
		if ( p_isPreconfig ) 
		{
			id = "GamePlus";
			version = "0.2.8";
			author = "Aris Kostakos";
			isDecached = true;
			width = 1200;
			height = 400;
			bgColor = 0xFF999999;
			startingSceneType = GAME;
			targetFramerate = 20;
			isFixedUpdates = true;
		}
	}
	
	override private function _launchKernel():Void
	{
		if ( _concreteKernel != null )
		{
			return;
		}
		_configure( false );
		_concreteKernel = new Kernel( this, _context );
	}

	override public function onInitComplete( kernel:IKernel ):Void
	{
		super.onInitComplete(kernel);
		// extend here
		
		//Create Service Factory (which will create S.L.I.C.E.D.)
		var l_serviceFactory:ServiceFactory = new ServiceFactory(_kernel);
	}
	
	override public function createAssetManager():IAssetManagerProcess 
	{
		if ( _assetManager == null ) 
		{
			_assetManager = new AssetManager( _kernel );
		}
		return _assetManager;
	}

	override public function createOverlay():IOverlayProcess 
	{
		var l_overlay:Overlay = new Overlay( _kernel );
		return l_overlay;
	}

	override public function createPreloader():IPreloader 
	{
		return new Preloader( _kernel, _getAssetUrls(), isDecached );
	}

	override public function createScene( p_type:EScene ):IScene 
	{
		switch ( p_type ) 
		{
			case GAME :
				return new Game( _kernel, p_type );
			case INTRO :
				return new Intro( _kernel, p_type );
			default :
				null;
		}
		return super.createScene( p_type );
	}

	override public function createSceneTransition( ?p_typeIncoming:EScene, ?p_typeOutgoing:EScene ):ISceneTransition 
	{
		var l_sceneTransition:SceneTransition = new SceneTransition( _kernel );
		return l_sceneTransition;
	}

	override public function createSession( ?p_id:String ):ISession 
	{
		return new Session( _kernel, p_id );
	}

	override public function createTextStyle( ?p_type:ETextStyle ):ITextStyle 
	{
		if ( p_type == null ) 
		{
			p_type = BODY;
		}
		var l_fontName:String = _assetManager.font.fontName;
		var l_result:TextStyle = new TextStyle( l_fontName, 12, 0x808080 );
		l_result.size = switch ( p_type ) 
		{
			case HEADLINE :
				24;
			case OVERSIZED :
				72;
			case SUBHEAD :
				18;
			case BUTTON :
				10;
			case SMALLPRINT :
				6;
			default : 
				12;
		}
		return l_result;
	}

	override public function getBackSceneType( p_type:EScene ):EScene 
	{
		switch ( p_type ) 
		{
			case GAME :
				return INTRO;
			case INTRO :
				return null;
			default : 
				null;
		}
		return super.getBackSceneType( p_type );
	}

	override public function getNextSceneType( p_type:EScene ):EScene 
	{
		switch ( p_type ) 
		{
			case GAME :
				return RESULTS;
			case INTRO :
				return GAME;
			default : 
				null;
		}
		return super.getNextSceneType( p_type );
	}

}
