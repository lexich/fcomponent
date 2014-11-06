ComponentsHolder = ($)->
  if typeof String.prototype.trim isnt "function"
    String.prototype.trim = -> this.replace /^\s+|\s+$/g, ""

  ATTR = "data-sblock"

  destroyItem = ($el, name, c)->
    c.destroy $el
    $el.removeAttr "#{ATTR}-#{name}"
    if $el.is("[#{ATTR}]")
      val = $el.attr ATTR
      names = val.split(",")
      if names.indexOf(name) < 0
        names.push name
        val = names.join(",")
      $el.attr ATTR, val
    else
      $el.attr ATTR, name

  initializer = ->
    blocks = {}
    {
      add: (block, name=block.name)->
        return "blocks:need name" unless name
        return "blocks:#{name} block.init == null" unless block.init?
        return "blocks:#{name} block.destroy == null" unless block.destroy?
        return "blocks:#{name} block is already define" if blocks[name]?
        blocks[name] = block
        null

      item: (name, $el, options, args...)->
        c = blocks[name]
        return "block not found" unless c
        return "block is initialized" if $el.is("[#{ATTR}-#{name}]")
        if options
          $el.data name, options
        else
          options = $el.data(name)
        c.init.apply c, [$el, options].concat(args)
        $el.attr "#{ATTR}-#{name}", ""
        null

      init: ($root, args...)->
        _this = this
        if $root.is("[#{ATTR}]")
          names = $root.attr(ATTR).split()
          for name in names
            name = name.trim()
            _this.item.apply _this, [name, $root].concat(args)

        $items = $root.find("[#{ATTR}]")
        $items.each (i)->
          $el = $items.eq(i)
          names = $el.attr(ATTR).split()
          for name in names
            name = name.trim()
            _this.item.apply _this, [name, $el].concat(args)
        null

      destroy: ($root)->
        for name, c of blocks
          $items = $root.find "[#{ATTR}-#{name}]"
          $items.each (i)->
            destroyItem $items.eq(i), name, c
          if $root.is "[#{ATTR}-#{name}]"
            destroyItem $root, name, c
        null

      api: (name, funcname, $el, args...)->
        block = blocks[name]
        return "block \"#{name}\" not found" unless block
        return "api property not found in \"#{name}\" block" unless block.api
        _func = block.api[funcname]
        return "method \"#{funcname}\" not found in api of \"#{name}\" block" unless _func
        $items = $el.find("[#{ATTR}-#{name}]")
        $items.each (i)->
          _func.apply null, [$items].concat(args)
        if $el.is("[#{ATTR}-#{name}]")
          _func.apply null, [$el].concat(args)
        null
    }

  scope = {}
  remove = (name="")-> scope[name] = null if scope[name]?
  resolve = (name="")-> scope[name] or (scope[name] = initializer())
  resolve.remove = remove
  resolve


ComponentsHolder.version = "0.0.1"
if (typeof define is "function") and (typeof define.amd is "object") and define.amd
  define ["jquery"], ($)-> ComponentsHolder($)
else
  window.sblock = ComponentsHolder(jQuery or $)
