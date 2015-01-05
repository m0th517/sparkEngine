/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.space2_5D.interfaces;

/**
 * @author Aris Kostakos
 */

interface IEntity2_5D extends IObjectContainer2_5D
{
	function createInstance (p_view2_5D:IView2_5D):Dynamic;
	function update(?p_view2_5D:IView2_5D):Void;
}