package ru.interactivelab.touchscript.clusters
{
	import flash.geom.Point;

	public class Cluster1 extends Cluster {
		
		public function Cluster1() {
			super();
		}
		
		public function get hasCluster():Boolean {
			return _points.length > 0;
		}
		
		public function getCenterPosition():Point {
			return _getCenterPosition(_points);
		}
		
		public function getPreviousCenterPosition():Point {
			return _getPreviousCenterPosition(_points);
		}
		
	}
}