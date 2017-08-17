class SideMenuHelper

  @initializeSideMenu = ()->

    SideMenuHelper.$side_menu = $('.side-nav')
    SideMenuHelper.additional_menus = {}
    SideMenuHelper.handlebars_template = Handlebars.compile($('#Handlebars-SideBar-CollapsibleMenu').html())
    # initialization of visualization code.
    # This controls the padding of the sidenav.
    SideMenuHelper.initializeTopMenuController()
    # collapse button, the one that shows the sidenav on mobile
    $(".button-collapse").sideNav()
    SideMenuHelper.renderMenus()

  @initializeTopMenuController = ->

    # This changes the padding of the side nav when the window is scrolled.
    # So it doesn't leave a blank space when the top embl-ebi bar disapears
    win = $(window)
    $sidenav = $(".side-nav")

    maxPadding = $('#masthead-contaniner').height()
    win.resize ->
      top = win.scrollTop()
      maxPadding = $('#masthead-contaniner').height()
      footer_h = $('footer').height()
      $sidenav.css
        'paddingBottom': footer_h + 'px'
        'paddingTop': maxPadding - top + 'px'
    win.scroll ->
      top = win.scrollTop()

      if top > maxPadding
        $sidenav.css
          'paddingTop': '0px'
      else:
        $sidenav.css
          'paddingTop': maxPadding - top + 'px'

  @addMenu = (menu_key, menu_data)->
    if _.isObject(menu_data)
      SideMenuHelper.additional_menus[menu_key] = menu_data
      SideMenuHelper.additional_menus[menu_key].menu_class = menu_key

  @removeMenu = (menu_key)->
    delete SideMenuHelper.additional_menus[menu_key]
    $(SideMenuHelper.$side_menu).find('.'+menu_key).remove()

  @expandMenu = (menu_key)->
    SideMenuHelper.$side_menu.find('.collapsible-header').show()
    SideMenuHelper.$side_menu.find('.collapsible-body').hide()
    SideMenuHelper.$side_menu.find('.'+menu_key).show()

  @findMenuLink: (menu_key, link_class_key)->
    return @$side_menu.find('.'+menu_key).find('.'+link_class_key)

  @updateSelectedLink: (menu_key, link_class_key, selected)->
    $link = SideMenuHelper.findMenuLink(menu_key, link_class_key)
    if selected
      $link.addClass('selected')
    else
      $link.removeClass('selected')

  @renderMenus = ()->
    # Shows all the headers and hides all the bodies
    SideMenuHelper.$side_menu.find('.collapsible-header').show()
    SideMenuHelper.$side_menu.find('.collapsible-body').hide()

    for menu_key_i, menu_data_i of SideMenuHelper.additional_menus
      $(SideMenuHelper.$side_menu).find('.'+menu_key_i).remove()
      html_menu = SideMenuHelper.handlebars_template(menu_data_i)
      $(SideMenuHelper.$side_menu).append(html_menu)

      # Linking selection events
      for link_i in menu_data_i.links
        if link_i.select_callback and link_i.link_class_key
          SideMenuHelper.findMenuLink(menu_key_i, link_i.link_class_key).click(link_i.select_callback)
      # Open on render
      if menu_data_i.show_on_render
        SideMenuHelper.$side_menu.find('.collapsible-body.'+menu_key_i).show()

    if SideMenuHelper.$side_menu.find('.collapsible-header').length == 1
      SideMenuHelper.$side_menu.find('.collapsible-header').hide()
      SideMenuHelper.$side_menu.find('.collapsible-body').show()