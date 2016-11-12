var _DenisKolodin$elm_dygraphs$Native_Dygraphs = function() {

// VIRTUAL-DOM WIDGETS

// `toHtml` called everytime component appeared or model changed
function toHtml(factList, skipChildren) {
	var model = extractModel(factList);
	// Event's uses this facts to dispatch custom event
	return _elm_lang$virtual_dom$Native_VirtualDom.custom(factList, model, implementation);
}

function emptyModel() {
	return {
		shared: null,
		options: { },
	};
}

function extractModel(factList) {
	var model = emptyModel();
	var current = factList;
	while (current.ctor != "[]") {
		var payload = current._0;
		model.options[payload.key] = payload.value;
		current = current._1;
	}
	return model;
}

// WIDGET IMPLEMENTATION

var implementation = {
	render: render,
	diff: diff
};

//
// `render` function calls everytime component appeared on th screen
// if you have tabs/pages and component hides it will be destroyed
// and new one created when you back to tab with this component
// `render` also be called
//
// It's impossible to detect when it destroyed, because it needs DOMNodeRemoved event
// which fires when component self-destroyed, but this API was deprecated
// and only MutationObserver available. The last needs an information about a parent
// which isn't available, because `div` created dynamically and will attached
// to tree later. Information about parent isn't available here.
//
function render(model) {

	var shared = {
		// Shared reference to an instance
		instance: null,
	}

	var div = document.createElement('div');
	div.setAttribute("class", "elm-dygraphs");

	var instance = new Dygraph(div);
	shared.instance = instance;

	var dummy = emptyModel();
	dummy.shared = shared;
	// It uses editor instance of prev and copy it to new
	diff({ model: dummy }, { model: model })

	return div;
}

// `diff` called everytime view updates, but you are still on the same page
function diff(prev, next) {
	var pm = prev.model;
	var nm = next.model;
	var shared = pm.shared;
	if (shared != null) {
		shared.instance.updateOptions(nm.options, false);
	}
	nm.shared = shared;
    return null;
}

return {
	toHtml: F2(toHtml),
};

}();
