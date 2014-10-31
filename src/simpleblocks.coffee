ComponentsHolder = ($)->
  if typeof String.prototype.trim isnt 'function'
    String.prototype.trim = -> this.replace /^\s+|\s+$/g, ''

  ATTR = "data-sblock"

  do ($=$)->
    blocks = {}
    {
      add:(block, name=block.name)->
        unless name
          throw new Error("Components:need name")
        unless block.init?
          throw new Error("Components:#{name} block.init == null ")
        unless block.destroy?
          throw new Error("Components:#{name} block.destroy == null ")
        blocks[name] = block

      item: (name, $el, options, args...)->
        c = blocks[name]
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
        for name, c of blocks
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
        block = blocks[name]
        return "not api" if block.api
        _func = block.api[funcname]
        return "not api:#{funcname}" unless _func
        $items = $el.find("[#{ATTR}-#{name}]")
        $items.each (i)->
          _func.apply null, [$items].concat(args)
        if $el.is("[#{ATTR}-#{name}]")
          _func.apply null, [$el].concat(args)
    }
ComponentsHolder.version = "0.0.1"
if (typeof define is 'function') and (typeof define.amd is 'object') and define.amd
  define ["jquery"], ($)-> ComponentsHolder($)
else
  window.ServerClient = ComponentsHolder(jQuery or $)
