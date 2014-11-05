(function() {
  var ComponentsHolder,
    __slice = [].slice;

  ComponentsHolder = function($) {
    var ATTR, destroyItem, initializer, scope;
    if (typeof String.prototype.trim !== 'function') {
      String.prototype.trim = function() {
        return this.replace(/^\s+|\s+$/g, '');
      };
    }
    ATTR = "data-sblock";
    destroyItem = function($el, name, c) {
      var names, val;
      c.destroy($el);
      $el.removeAttr("" + ATTR + "-" + name);
      if ($el.is("[" + ATTR + "]")) {
        val = $el.attr(ATTR);
        names = val.split(",");
        if (names.indexOf(name) < 0) {
          names.push(name);
          val = names.join(",");
        }
        return $el.attr(ATTR, val);
      } else {
        return $el.attr(ATTR, name);
      }
    };
    initializer = function() {
      var blocks;
      blocks = {};
      return {
        add: function(block, name) {
          if (name == null) {
            name = block.name;
          }
          if (!name) {
            return "blocks:need name";
          }
          if (block.init == null) {
            return "blocks:" + name + " block.init == null";
          }
          if (block.destroy == null) {
            return "blocks:" + name + " block.destroy == null";
          }
          if (blocks[name] != null) {
            return "blocks:" + name + " block is already define";
          }
          blocks[name] = block;
          return null;
        },
        item: function() {
          var $el, args, c, name, options;
          name = arguments[0], $el = arguments[1], options = arguments[2], args = 4 <= arguments.length ? __slice.call(arguments, 3) : [];
          c = blocks[name];
          if (!c) {
            return "block not found";
          }
          if ($el.is("[" + ATTR + "-" + name + "]")) {
            return "block is initialized";
          }
          if (options) {
            $el.data(name, options);
          } else {
            options = $el.data(name);
          }
          c.init.apply(c, [$el, options].concat(args));
          $el.attr("" + ATTR + "-" + name, "");
          return null;
        },
        init: function() {
          var $items, $root, args, name, names, _i, _len, _this;
          $root = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
          _this = this;
          if ($root.is("[" + ATTR + "]")) {
            names = $root.attr(ATTR).split();
            for (_i = 0, _len = names.length; _i < _len; _i++) {
              name = names[_i];
              name = name.trim();
              _this.item.apply(_this, [name, $root].concat(args));
            }
          }
          $items = $root.find("[" + ATTR + "]");
          $items.each(function(i) {
            var $el, _j, _len1, _results;
            $el = $items.eq(i);
            names = $el.attr(ATTR).split();
            _results = [];
            for (_j = 0, _len1 = names.length; _j < _len1; _j++) {
              name = names[_j];
              name = name.trim();
              _results.push(_this.item.apply(_this, [name, $el].concat(args)));
            }
            return _results;
          });
          return null;
        },
        destroy: function($root) {
          var $items, c, name;
          for (name in blocks) {
            c = blocks[name];
            $items = $root.find("[" + ATTR + "-" + name + "]");
            $items.each(function(i) {
              return destroyItem($items.eq(i), name, c);
            });
            if ($root.is("[" + ATTR + "-" + name + "]")) {
              destroyItem($root, name, c);
            }
          }
          return null;
        },
        api: function() {
          var $el, $items, args, block, funcname, name, _func;
          name = arguments[0], funcname = arguments[1], $el = arguments[2], args = 4 <= arguments.length ? __slice.call(arguments, 3) : [];
          block = blocks[name];
          if (block.api) {
            return "not api";
          }
          _func = block.api[funcname];
          if (!_func) {
            return "not api:" + funcname;
          }
          $items = $el.find("[" + ATTR + "-" + name + "]");
          $items.each(function(i) {
            return _func.apply(null, [$items].concat(args));
          });
          if ($el.is("[" + ATTR + "-" + name + "]")) {
            _func.apply(null, [$el].concat(args));
          }
          return null;
        }
      };
    };
    scope = {
      "default": initializer()
    };
    scope["default"]._ = {
      scope: function(name) {
        return scope[name] != null ? scope[name] : scope[name] = initializer();
      },
      remove: function(name) {
        if (name === "default") {
          scope["default"] = initializer();
        }
        if (scope[name] != null) {
          return scope[name] = null;
        }
      }
    };
    return scope["default"];
  };

  ComponentsHolder.version = "0.0.1";

  if ((typeof define === 'function') && (typeof define.amd === 'object') && define.amd) {
    define(["jquery"], function($) {
      return ComponentsHolder($);
    });
  } else {
    window.sblock = ComponentsHolder(jQuery || $);
  }

}).call(this);
