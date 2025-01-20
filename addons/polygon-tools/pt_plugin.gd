@tool
extends EditorPlugin

#--------------------------------------------------------------------------------------------------------------------------------

const TOOL_NAME = "Triangulate Polygon"
const TOOL_NAME1 = "Clear Bone Weights"

func _enter_tree():
  add_tool_menu_item(TOOL_NAME, callback)
  add_tool_menu_item(TOOL_NAME1, callback1)

func _exit_tree():
  remove_tool_menu_item(TOOL_NAME)
  remove_tool_menu_item(TOOL_NAME1)

func triangulate(poly: Polygon2D)->void:
  print_debug('triangulate ', poly)
  var delaunay = Delaunator.new(poly.polygon)
  var tris = delaunay.triangles
  print_debug('done. %d triangles' % tris.size())
  var polys = []
  for i in range(0, tris.size(), 3):
    polys.push_back(tris.slice(i, i + 3))
  poly.polygons = polys

func clear_weights(poly: Polygon2D)->void:
  poly.clear_bones()
  pass


func callback():
  var sel:Array[Node] = get_editor_interface().get_selection().get_selected_nodes();
  if sel.size() != 1:
    print('Can only triangualte 1 polygon at a time.')
    return

  if sel[0] is not Polygon2D:
    print('Can only triangualte Polygon2D.')
    return
  triangulate(sel[0])

func callback1():
  var sel:Array[Node] = get_editor_interface().get_selection().get_selected_nodes();
  if sel.size() != 1:
    print('Can only clear weights of 1 polygon at a time.')
    return

  if sel[0] is not Polygon2D:
    print('Can only clear weights of Polygon2D.')
    return
  clear_weights(sel[0])
    #func _handles(object: Object) -> bool:
  #if object is Spline2D:
    #return true
  #return false

#func _edit(object: Object)->void:
  #if object == spline:
    #return
  #if spline:
    #spline.shape_updated.disconnect(_on_shape_updated)
    #spline = null
  #if object:
    #spline = object as Spline2D
    #if spline.points.is_empty():
      #set_mode(MODE.CREATE)
    #spline.shape_updated.connect(_on_shape_updated)
  #update_overlays()

#func _make_visible(visible: bool)->void:
  #if visible:
    #ctl.show()
  #else:
    #ctl.hide()
