describe "test interface", ->

  it "check scope", ->
    sblock = window.sblock._.scope("test")
    (window.sblock isnt sblock).should.be.ok
    window.sblock._.remove("test")
    (!!sblock).should.be.ok
    (sblock isnt window.sblock._.scope("test"))

  it "check add method", ->
    sblock = window.sblock._.scope("test")
    "blocks:need name".should.eql sblock.add {}
    "blocks:hello block.destroy == null".should.eql sblock.add init: (->), name: "hello"
    "blocks:hello1 block.init == null".should.eql sblock.add destroy:(->), name: "hello1"
    "blocks:need name".should.eql sblock.add {init: (->), destroy:(->)}
    #ok
    (not sblock.add { init:(->), destroy:(->), name:"test" }).should.be.ok
    #dublicate init component
    "blocks:test block is already define".should.eql sblock.add {init:(->), destroy:(->), name:"test"}

describe "test init method", ->
  sblock = window.sblock._.scope("test")
  sblock.add {
    name: "hello"
    init: ($el, msg)->
      $el.text(msg)
    destroy: ($el)->
      $el.empty()
  }
  $root = $("""<div>
    <div id="hello" data-sblock="hello" data-hello="hello world"/>
  </div>""")
  $el = $root.find("#hello")

  it "check init destroy methods", ->
    sblock.init $root
    "hello world".should.eql $el.text()
    "hello".should.eql $el.attr("data-sblock")
    $el.is("[data-sblock-hello]").should.be.ok

    sblock.destroy $root
    "".should.eql $el.text()
    "hello".should.eql $el.attr("data-sblock")
    $el.is("[data-sblock-hello]").should.be.not.ok
    "hello world".should.eql $el.data("hello")

  it "check item method", ->
    $el1 = $("<div>")
    sblock.item "hello", $el1, "hello man"
    "hello man".should.eql $el1.text()
    (not $el1.attr("data-sblock")).should.be.ok
    $el1.is("[data-sblock-hello]").should.be.ok
    "hello man".should.eql $el1.data("hello")
    sblock.destroy $el1

    "".should.eql $el1.text()
    $el.is("[data-sblock-hello]").should.be.not.ok
