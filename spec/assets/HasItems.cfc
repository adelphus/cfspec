<cfcomponent output="false"><cfscript>

	function init(size) {
		$size = size;
		return this;
	}

	function getItems() {
		return left("abcdefghijklmnopqrstuvwxyz", $size);
	}

</cfscript></cfcomponent>