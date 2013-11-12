/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

package co.gamep.sliced.services.std.display.renderers.interfaces;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalView;

/**
 * ...
 * @author Aris Kostakos
 */
interface IRenderer
{
	var logicalViewSet( default, null ):Array<ILogicalView>;
	var uses3dEngine( default, null ):Bool;
	
	function render ( logicalView:ILogicalView):Void;
}