/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, September 2013
 */

package org.gamepl.coreservices.services.std.display.interfaces;
import org.gamepl.coreservices.services.std.display.renderers.interfaces.IRenderer;

/**
 * ...
 * @author Aris Kostakos
 */
interface IScene
{
	var rendererType( default, null ):String;
	var renderer( default, null ):IRenderer;
	
	var posX( default, null ):Int;
	var posY( default, null ):Int;
	var width( default, null ):Int;
	var height( default, null ):Int;
}