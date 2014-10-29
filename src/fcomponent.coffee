ComponentsHolder = ($)->
  if typeof String.prototype.trim isnt 'function'
    String.prototype.trim = -> this.replace /^\s+|\s+$/g, ''

  ATTR = "data-component"

  do ($=$)->
    components = {}
    {
      add:(component, name=component.name)->
        unless name
          throw new Error("Components:need name")
        unless component.init?
          throw new Error("Components:#{name} component.init == null ")
        unless component.destroy?
          throw new Error("Components:#{name} component.destroy == null ")
        components[name] = component

      item: (name, $el, options, args...)->
        c = components[name]
        return unless c
        return if $el.is("[#{ATTR}-#{name}]")
        if options
          $el.data name, options
        else
          options = $el.data(name)
        c.init.apply c, [$el, options].concat(args)
        $el.attr "#{ATTR}-#{name}", ""

      init: ($root, args...)->
        $items = $root.find("[#{ATTR}]")
        _this = this
        $items.each (i)->
          $el = $items.eq(i)
          names = $el.attr(ATTR).split()
          for name in names
            name = name.trim()
            _this.item.apply _this, [name, $el].concat(args)

      destroy: ($root)->
        for name, c of components
          $items = $root.find "[#{ATTR}-#{name}]"
          $items.each (i)->
            $el = $items.eq(i)
            c.destroy $el
            $el.removeAttr "#{ATTR}-#{name}"
            if $el.is("[#{ATTR}]")
              val = $el.attr ATTR
              $el.attr ATTR, val.split(",").concat(name).join(",")
            else
              $el.attr ATTR, name

      api: (name, funcname, $el, args...)->
        component = components[name]
        return "not api" if component.api
        _func = component.api[funcname]
        return "not api:#{funcname}" unless _func
        $items = $el.find("[#{ATTR}-#{name}]")
        $items.each (i)->
          _func.apply null, [$items].concat(args)
        if $el.is("[#{ATTR}-#{name}]")
          _func.apply null, [$el].concat(args)
    }
ComponentsHolder.version = "0.0.0"
if (typeof define is 'function') and (typeof define.amd is 'object') and define.amd
  define ["jquery"], ($)-> ComponentsHolder($)
else
  window.ServerClient = ComponentsHolder(jQuery or $)
