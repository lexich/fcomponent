FComponent - Frontend components
==========
### Description
FComponent is a small arhitecture framework for creating litte
simple components. It may be usefull for simple integration to you
MV* framework. For example backbone.

### API
#### `add(component, name)`  
register component  

- `component` - object of custom component definition  
              component must have `add` and `destroy` methods,
              otherwise method add throw Error. You can also
              define `name` of component or pass it as second 
              param.  
Type: Object {add:function(){}, destroy: function(){}}  
- `name` - name of component  
Type: String  
Default: `component.name` 
Example:  
```javascript
var fcomponent = require("fcomponent");
fcomponent.add({
  init: function($el, message){
    $el.html("<p>" + message + "</p>");
  },
  destroy: function($el){
    $el.empty();
  }
}, "test");
```

#### `init($root, arguments...)`  
Initialize all register components in `$root` DOM element  
- `$root` - dom element where find components  
Type: jQuery DOM object  
- `arguments` - additional params for initialize component  
Example:

Define component in html
```html
<body>
<div 
  data-component="test" 
  data-test="Hello component" />
<div 
  data-component="test" 
  data-test="Hello component2" />
</body>
```

Initialize all components in body
```javascript
var $ = require("jquery");
var fcomponent = require("fcomponent");
fcomponent.init($("body"));
```

Result html is:
```html
<body>
<div 
  data-component="test" 
  data-component-test
  data-test="Hello component">
  <p>Hello component</p>
</div>
<div 
  data-component="test" 
  data-component-test
  data-test="Hello component2">
  <p>Hello component2</p>
</div>
</body>
```

### `item(name, $el, options, argunments...)`  
Method to init not marked html element as component  
- `name` - name of using component  
- `$el` - DOM element  
- `options` - options for initialize component
- `arguments` - additional params for initialize component  
Example:  

```javascript
var $ = require("jquery");
var fcomponent = require("fcomponent");
var $el = $('<div>');
$("body").append($el);
fcomponent.item("test", $el, "Hello component 3");
```

html dom result:
```html
<body>
<div 
  data-component="test" 
  data-component-test
  data-test="Hello component">
  <p>Hello component</p>
</div>
<div 
  data-component="test" 
  data-component-test
  data-test="Hello component2">
  <p>Hello component2</p>
</div>
<div 
  data-component="test" 
  data-component-test>
  <p>Hello component3</p>
</div>
</body>
```

#### `destroy($root)`
Destroy all initialize components in `$root` DOM element
- `$root` - dom element where find components  
Type: jQuery DOM object  
Example:  
```javascript
var $ = require("jquery");
var fcomponent = require("fcomponent");
fcomponent.destroy($("body"));
```

#### `api(name, funcname, $el, args...)`  
Call custom api for component
- `name` - name of component  
- `funcname` - name of callable function  
- `$el` - element where find dom element for initialize components  
- `arguments` - additional params  
Example:
```javascript
fcomponent.add({
  init: function($el, val){
    $el.text(val || 0)
  },
  destroy: function($el){
    $el.empty();
  },
  api: {
    val: function($el, val){
      $el.text(val || 0);
    }
  }
}, "test");
/* after initializing apply method `api.val` to `$el` */
$el.text() === "0"; //true
fcomponent.api("test", "val", $el,  2);
$el.text() === "2"; //true
```  

html dom result:
```html
<body>
  <div 
  data-component="test" 
  data-test="Hello component"/>
  <div 
    data-component="test" 
    data-test="Hello component2"/>
  <div data-component="test"/>
</body>
```

### Example of Backbone integration
```javascript
View = Backbone.View.extend({
  render: function(){
    fcomponent.init(this.$el);
  },
  remove: function(){
    fcomponent.destroy(this.$el);
    Backbone.View.prototype.remove.call(this);
  }
});
```
### Cbangelog
- 0.0.1 - public version
